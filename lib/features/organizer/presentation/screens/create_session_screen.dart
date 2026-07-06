import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/currency_input_formatter.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/capacity_selector.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/coach_picker_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/create_session_header.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/duplicate_picker.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/duration_pills.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/payment_guard_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/picker_tile.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/post_create_photo_prompt.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/section_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_ticket_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_type_cards.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/time_wheel_picker.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/create_venue_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/venue_picker_sheet.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Two-step create-session flow aligned to the backend `StoreSessionRequest`
/// contract. Step 1 = Detail (type, title, coaches); Step 2 = Jadwal & Rincian,
/// anchored by a live session-ticket preview.
class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key, this.sessionId});

  /// Non-null puts the screen in edit mode: hydrates from
  /// `getEditPayload`, renders a single-scroll form, and saves via update
  /// instead of create.
  final String? sessionId;

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  int _step = 0;
  bool _submitting = false;
  String? _error;
  String? _appliedDuplicateLabel;

  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  bool get _isEdit => widget.sessionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadForEdit());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkPaymentGuard());
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  CreateSessionDraftNotifier get _notifier =>
      ref.read(createSessionDraftProvider.notifier);

  void _back() {
    if (_step == 1) {
      setState(() => _step = 0);
    } else {
      context.pop();
    }
  }

  Future<void> _checkPaymentGuard() async {
    final ready = await ref
        .read(organizerRepositoryProvider)
        .isPayoutConfigured();
    if (!mounted || ready) return;
    final goSettings = await showPaymentGuard(context);
    if (!mounted) return;
    context.pop();
    if (goSettings) context.push(AppRoutes.organizerProfile);
  }

  Future<void> _loadForEdit() async {
    try {
      final draft = await ref
          .read(organizerRepositoryProvider)
          .getEditPayload(widget.sessionId!);
      if (!mounted) return;
      _notifier.hydrate(draft);
      _titleCtrl.text = draft.title ?? '';
      _notesCtrl.text = draft.notes ?? '';
      _priceCtrl.text = draft.price != null
          ? Formatters.groupDigits(
              Formatters.fromMinorUnits(
                draft.price!,
                ref.read(tenantCurrencyProvider),
              ).toInt().toString(),
              ref.read(tenantCurrencyProvider),
            )
          : '';
      setState(() {}); // reflect prefill
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Gagal memuat sesi. Coba lagi.');
      }
    }
  }

  Future<void> _onDuplicatePicked(String sessionId) async {
    final repo = ref.read(organizerRepositoryProvider);
    final payload = await repo.getDuplicatePayload(sessionId);
    if (!mounted) return;
    _notifier.applyDuplicate(payload);
    final currency = ref.read(tenantCurrencyProvider);
    _titleCtrl.text = payload.title ?? '';
    _notesCtrl.text = payload.notes ?? '';
    _priceCtrl.text = payload.price != null
        ? Formatters.groupDigits(
            Formatters.fromMinorUnits(
              payload.price!,
              currency,
            ).toInt().toString(),
            currency,
          )
        : '';
    final recent = ref.read(createSessionRecentProvider).valueOrNull ?? [];
    final match = recent.where((r) => r.id == sessionId).firstOrNull;
    setState(
      () => _appliedDuplicateLabel = match != null
          ? Formatters.formatDateTimeCompact(match.startAt)
          : 'sesi lain',
    );
  }

  void _clearDuplicate() {
    _notifier.reset();
    _titleCtrl.clear();
    _notesCtrl.clear();
    _priceCtrl.clear();
    setState(() => _appliedDuplicateLabel = null);
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final session = await _notifier.submit();
      if (!mounted) return;
      final wantPhoto = await showPostCreatePhotoPrompt(context);
      if (wantPhoto && mounted) {
        await editSessionCover(
          context,
          ref,
          sessionId: session.id,
          hasPhoto: false,
        );
      }
      _notifier.reset();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sesi berhasil dibuat')));
      context.pop();
    } on ValidationException catch (e) {
      if (!mounted) return;
      if (e.errors.containsKey('tenant')) {
        // Bank details unset — same guard UX as the init-time check.
        final goSettings = await showPaymentGuard(context);
        if (!mounted) return;
        if (goSettings) context.push(AppRoutes.organizerProfile);
      } else {
        // Field-level rejection (e.g. coach schedule conflict) — surface the
        // server's message in the banner.
        final firstError = e.errors.values
            .expand((messages) => messages)
            .map((m) => m.toString())
            .firstOrNull;
        setState(() => _error = firstError ?? 'Gagal membuat sesi. Coba lagi.');
      }
    } on ForbiddenException {
      if (!mounted) return;
      setState(
        () => _error =
            'Langganan tidak aktif. Perbarui langganan untuk membuat sesi.',
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal membuat sesi. Coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitEdit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await _notifier.submit(); // routes to updateSession (sessionId is set)
      _notifier.reset(); // clear shared draft regardless of mount state (create/edit invariant)
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perubahan disimpan')));
      Navigator.of(context).pop();
    } on ValidationException catch (e) {
      if (!mounted) return;
      final firstError = e.errors.values
          .expand((messages) => messages)
          .map((m) => m.toString())
          .firstOrNull;
      setState(() => _error = firstError ?? 'Gagal menyimpan. Coba lagi.');
    } on ForbiddenException {
      if (!mounted) return;
      setState(() => _error = 'Sesi ini tidak bisa diubah.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal menyimpan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createSessionDraftProvider);
    if (_isEdit) return _buildEditScaffold(draft);
    return _buildCreateScaffold(draft);
  }

  Widget _buildCreateScaffold(CreateSessionDraft draft) {
    return Scaffold(
      backgroundColor: AppSurfaces.background,
      body: Column(
        children: [
          CreateSessionHeader(step: _step, onBack: _back),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.base,
                AppDimensions.base,
                AppDimensions.base,
                AppDimensions.xxl,
              ),
              child: _step == 0 ? _buildStep1(draft) : _buildStep2(draft),
            ),
          ),
          if (_error != null) _errorBanner(),
          _buildFooter(draft),
        ],
      ),
    );
  }

  Widget _buildEditScaffold(CreateSessionDraft draft) {
    final dirty = ref.read(createSessionDraftProvider.notifier).isDirty;
    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          _notifier.reset(); // leaving edit — clear the shared draft so a later create starts blank
          return;
        }
        final leave = await _confirmDiscard();
        if (leave && mounted) {
          _notifier.reset();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppSurfaces.background,
        appBar: AppBar(title: const Text('Edit sesi')),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.base,
                  AppDimensions.base,
                  AppDimensions.base,
                  AppDimensions.xxl,
                ),
                child: Column(
                  children: [
                    _buildStep1(draft),
                    const SizedBox(height: AppDimensions.md),
                    _buildStep2(draft),
                  ],
                ),
              ),
            ),
            if (_error != null) _errorBanner(),
            _buildEditFooter(draft, dirty),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buang perubahan?'),
        content: const Text('Perubahan yang belum disimpan akan hilang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjut edit'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Buang',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return r ?? false;
  }

  Widget _buildEditFooter(CreateSessionDraft draft, bool dirty) {
    return SafeArea(
      minimum: const EdgeInsets.all(AppDimensions.base),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeightLg,
        child: FilledButton(
          onPressed: (dirty && draft.canSubmit && !_submitting)
              ? _submitEdit
              : null,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan perubahan'),
        ),
      ),
    );
  }

  // ── Step 1: Detail ──────────────────────────────────────────────────
  Widget _buildStep1(CreateSessionDraft draft) {
    final recent = ref.watch(createSessionRecentProvider).valueOrNull ?? [];
    final coaches = ref.watch(createSessionCoachesProvider).valueOrNull ?? [];
    final showDuplicate = recent.isNotEmpty || _appliedDuplicateLabel != null;

    return Column(
      children: [
        if (!_isEdit && showDuplicate) ...[
          FormSectionCard(
            eyebrow: 'MULAI CEPAT',
            helper: 'Salin detail dari sesi sebelumnya, lalu sesuaikan.',
            child: DuplicatePicker(
              recent: recent,
              onPicked: _onDuplicatePicked,
              appliedLabel: _appliedDuplicateLabel,
              onClear: _clearDuplicate,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
        ],
        FormSectionCard(
          eyebrow: 'JENIS SESI',
          helper: 'Trial & group bisa dibatasi kapasitasnya; privat 1-on-1.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SessionTypeCards(value: draft.type, onChanged: _notifier.setType),
              const SizedBox(height: AppDimensions.base),
              TextField(
                controller: _titleCtrl,
                maxLength: 200,
                onChanged: _notifier.setTitle,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Judul (opsional)',
                  hintText: 'mis. Latihan Grup Kamis Pagi',
                  counterText: '',
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              TextField(
                controller: _notesCtrl,
                maxLines: 3,
                maxLength: 2000,
                onChanged: _notifier.setNotes,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                  hintText: 'Ceritakan sesi ini ke peserta…',
                  counterText: '',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        FormSectionCard(
          eyebrow: 'COACH',
          helper: 'Minimal satu coach memimpin sesi.',
          trailing: draft.coachIds.isNotEmpty
              ? _CountPill(count: draft.coachIds.length)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PickerTile(
                icon: Icons.sports_tennis_outlined,
                label: 'Coach',
                placeholder: 'Pilih coach',
                value: draft.coachIds.isEmpty
                    ? null
                    : '${draft.coachIds.length} coach dipilih',
                onTap: () async {
                  final result = await showCoachPicker(
                    context,
                    selected: draft.coachIds,
                  );
                  if (result != null) _notifier.setCoaches(result);
                },
              ),
              if (draft.coachIds.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.md),
                SelectedCoachChips(
                  coaches: coaches,
                  selectedIds: draft.coachIds,
                  onRemove: _notifier.toggleCoach,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Step 2: Jadwal & rincian ────────────────────────────────────────
  Widget _buildStep2(CreateSessionDraft draft) {
    final currency = ref.watch(tenantCurrencyProvider);
    final isPrivate = draft.type == SessionType.private;

    return Column(
      children: [
        FormSectionCard(
          eyebrow: 'WAKTU & DURASI',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PickerTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal',
                      placeholder: 'Pilih',
                      value: draft.date != null
                          ? Formatters.formatDate(draft.date!)
                          : null,
                      onTap: _pickDate,
                      trailing: const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: PickerTile(
                      icon: Icons.schedule_outlined,
                      label: 'Jam',
                      placeholder: 'Pilih',
                      value: draft.startTime,
                      onTap: _pickTime,
                      trailing: const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.base),
              DurationPills(
                value: draft.durationMinutes,
                onChanged: _notifier.setDuration,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        FormSectionCard(
          eyebrow: isPrivate ? 'TEMPAT' : 'KAPASITAS & TEMPAT',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isPrivate) ...[
                CapacitySelector(
                  value: draft.capacity,
                  onChanged: _notifier.setCapacity,
                  defaultLimit: draft.type == SessionType.trial ? 10 : 15,
                ),
                const SizedBox(height: AppDimensions.base),
              ],
              _venueField(draft),
            ],
          ),
        ),
        if (_isEdit) ...[
          const SizedBox(height: AppDimensions.md),
          Consumer(
            builder: (context, ref, _) {
              final detail = ref.watch(
                organizerSessionDetailProvider(widget.sessionId!),
              );
              final hasPhoto = detail.valueOrNull?.photoPath != null;
              return PickerTile(
                icon: Icons.photo_camera_outlined,
                label: 'Sampul',
                placeholder: 'Tambah foto sampul',
                value: hasPhoto ? 'Foto terpasang' : null,
                onTap: () => editSessionCover(
                  context,
                  ref,
                  sessionId: widget.sessionId!,
                  hasPhoto: hasPhoto,
                ),
              );
            },
          ),
        ],
        const SizedBox(height: AppDimensions.md),
        FormSectionCard(
          eyebrow: 'BIAYA',
          optional: true,
          child: TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [ThousandsSeparatorInputFormatter(currency)],
            onChanged: (v) {
              // Strip the grouping separators the mask inserts before
              // parsing, else "185.000" reads as 185.0.
              final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
              final n = int.tryParse(digits);
              _notifier.setPrice(
                n == null ? null : Formatters.toMinorUnits(n, currency),
              );
            },
            decoration: InputDecoration(
              labelText: 'Harga per sesi',
              prefixText: '${Formatters.currencySymbol(currency)} ',
              // The prefix is a persistent unit, not a placeholder — give it
              // real contrast instead of the pale hint colour it defaults to.
              prefixStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              hintText: 'Kosongkan untuk gratis',
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        // Live preview sits at the foot of the form: it reads as the result of
        // the fields above and updates as they scroll down to it.
        SessionTicketCard(
          type: draft.type,
          title: _titleCtrl.text,
          onEditTitle: _editSessionTitle,
          whenLine: _whenLine(draft),
          capacityText: _capacityText(draft),
          priceText: draft.price == null
              ? 'Gratis'
              : Formatters.formatCurrency(draft.price!, currency),
        ),
      ],
    );
  }

  Widget _venueField(CreateSessionDraft draft) {
    if (draft.venueName == null) {
      return PickerTile(
        icon: Icons.place_outlined,
        label: 'Venue (opsional)',
        placeholder: 'Pilih atau buat venue',
        value: null,
        onTap: _pickVenue,
      );
    }
    return PickerTile(
      icon: Icons.place,
      label: 'Venue',
      value: draft.venueName,
      onTap: _pickVenue,
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: _notifier.clearVenue,
        icon: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
      ),
    );
  }

  // ── Footer ──────────────────────────────────────────────────────────
  Widget _buildFooter(CreateSessionDraft draft) {
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        border: const Border(top: BorderSide(color: AppColors.neutral100)),
        boxShadow: AppShadows.bottomNav,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.base,
            AppDimensions.md,
            AppDimensions.base,
            AppDimensions.md,
          ),
          child: _step == 0
              ? SizedBox(
                  height: AppDimensions.buttonHeightLg,
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: draft.step1Valid
                        ? () => setState(() => _step = 1)
                        : null,
                    child: const Text('Lanjut ke jadwal'),
                  ),
                )
              : Row(
                  children: [
                    SizedBox(
                      height: AppDimensions.buttonHeightLg,
                      child: OutlinedButton(
                        onPressed: _submitting
                            ? null
                            : () => setState(() => _step = 0),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.base,
                          ),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: SizedBox(
                        height: AppDimensions.buttonHeightLg,
                        child: FilledButton.icon(
                          onPressed: (!_submitting && draft.canSubmit)
                              ? _submit
                              : null,
                          icon: _submitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  size: 20,
                                ),
                          label: Text(_submitting ? 'Membuat…' : 'Buat Sesi'),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _errorBanner() {
    return Container(
      width: double.infinity,
      color: AppColors.errorLight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: AppColors.errorDark),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(
              _error!,
              style: AppTypography.caption.copyWith(color: AppColors.errorDark),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pickers ─────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(createSessionDraftProvider).date ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) _notifier.setDate(picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimeWheelPicker(
      context,
      initial: ref.read(createSessionDraftProvider).startTime,
    );
    if (picked != null) _notifier.setStartTime(picked);
  }

  /// Edit the session title inline from the step-2 preview, so the organizer
  /// doesn't bounce back to step 1 for a one-word change. Writes through the
  /// same controller + notifier, so step 1 stays in sync.
  Future<void> _editSessionTitle() async {
    final saved = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppSurfaces.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TitleEditorSheet(initialValue: _titleCtrl.text),
    );
    if (saved == null || !mounted) return;
    setState(() => _titleCtrl.text = saved.trim());
    _notifier.setTitle(saved.trim());
  }

  Future<void> _pickVenue() async {
    final picked = await showVenuePicker(
      context,
      selectedId: ref.read(createSessionDraftProvider).venueId,
    );
    if (picked == null) return;
    if (picked.id.startsWith('new:')) {
      if (!mounted) return;
      // "Buat venue" → full Places search + map confirm. The sheet creates the
      // venue and returns the persisted option (real numeric id).
      final created = await showCreateVenueSheet(
        context,
        initialQuery: picked.name,
      );
      if (created == null) return;
      ref.invalidate(createSessionVenuesProvider);
      _notifier.setVenue(id: created.id, name: created.name);
    } else {
      _notifier.setVenue(id: picked.id, name: picked.name);
    }
  }

  // ── Ticket helpers ──────────────────────────────────────────────────
  String? _whenLine(CreateSessionDraft draft) {
    if (draft.date == null || draft.startTime == null) return null;
    final d = draft.date!;
    return '${Formatters.formatDayShort(d)}, ${Formatters.formatDateShort(d)}'
        ' · ${draft.startTime} · ${draft.durationMinutes} mnt';
  }

  String _capacityText(CreateSessionDraft draft) {
    if (draft.type == SessionType.private) return '1 orang';
    if (draft.capacity == null) return 'Tak terbatas';
    return '${draft.capacity} orang';
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        '$count dipilih',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Bottom-sheet editor for the session title, opened from the step-2 preview.
/// Owns its own controller so it's disposed with the widget (disposing it
/// manually after the sheet closed tripped a framework `_dependents` assert).
class _TitleEditorSheet extends StatefulWidget {
  const _TitleEditorSheet({required this.initialValue});

  final String initialValue;

  @override
  State<_TitleEditorSheet> createState() => _TitleEditorSheetState();
}

class _TitleEditorSheetState extends State<_TitleEditorSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.lg,
          AppDimensions.sm,
          AppDimensions.lg,
          AppDimensions.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'Judul sesi',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: (v) => Navigator.of(context).pop(v),
              decoration: const InputDecoration(
                hintText: 'Mis. Latihan rutin Sabtu pagi',
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightLg,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_controller.text),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
