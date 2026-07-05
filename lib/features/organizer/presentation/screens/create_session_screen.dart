import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/capacity_selector.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/coach_picker_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/duplicate_picker.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/duration_pills.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/payment_guard_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/post_create_photo_prompt.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_type_cards.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/venue_picker_sheet.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:image_picker/image_picker.dart';

/// Two-step create-session flow aligned to the backend `StoreSessionRequest`
/// contract. Step 1 = Detail (type, title, coaches); Step 2 = Jadwal & Rincian.
class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPaymentGuard());
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

  Future<void> _checkPaymentGuard() async {
    final ready =
        await ref.read(organizerRepositoryProvider).isPayoutConfigured();
    if (!mounted || ready) return;
    final goSettings = await showPaymentGuard(context);
    if (!mounted) return;
    context.pop();
    if (goSettings) context.push(AppRoutes.organizerProfile);
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
        ? Formatters.fromMinorUnits(payload.price!, currency).toString()
        : '';
    final recent = ref.read(createSessionRecentProvider).valueOrNull ?? [];
    final match = recent.where((r) => r.id == sessionId).firstOrNull;
    setState(() => _appliedDuplicateLabel = match != null
        ? Formatters.formatDateTimeCompact(match.startAt)
        : 'sesi lain');
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
      if (wantPhoto) await _pickAndUploadCover(session.id);
      _notifier.reset();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi berhasil dibuat')),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal membuat sesi. Coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickAndUploadCover(String sessionId) async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null || !mounted) return;
    try {
      await ref
          .read(organizerRepositoryProvider)
          .uploadSessionCoverPhoto(sessionId, File(picked.path));
    } catch (_) {
      // Non-blocking — the session is already created.
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createSessionDraftProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Sesi'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: Text(
              'Langkah ${_step + 1}/2 · ${_step == 0 ? 'Detail' : 'Jadwal & Rincian'}',
              style:
                  AppTypography.caption.copyWith(color: AppColors.textTertiary),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: _step == 0 ? _buildStep1(draft) : _buildStep2(draft),
            ),
          ),
          if (_error != null)
            Container(
              width: double.infinity,
              color: AppColors.errorLight,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
              child: Text(_error!,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.errorDark)),
            ),
          _buildFooter(draft),
        ],
      ),
    );
  }

  Widget _buildStep1(CreateSessionDraft draft) {
    final recent = ref.watch(createSessionRecentProvider).valueOrNull ?? [];
    final coaches = ref.watch(createSessionCoachesProvider).valueOrNull ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DuplicatePicker(
          recent: recent,
          onPicked: _onDuplicatePicked,
          appliedLabel: _appliedDuplicateLabel,
          onClear: _clearDuplicate,
        ),
        const SizedBox(height: AppDimensions.xl),
        _label('TIPE SESI'),
        SessionTypeCards(value: draft.type, onChanged: _notifier.setType),
        const SizedBox(height: AppDimensions.xl),
        _label('JUDUL', optional: true),
        TextField(
          controller: _titleCtrl,
          maxLength: 200,
          onChanged: _notifier.setTitle,
          decoration: const InputDecoration(
            hintText: 'mis. Latihan Grup Kamis Pagi',
            counterText: '',
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        _label('COACH'),
        _CoachField(
          coaches: coaches,
          selectedIds: draft.coachIds,
          onOpen: () async {
            final result = await showCoachPicker(context,
                coaches: coaches, selected: draft.coachIds);
            if (result != null) _notifier.setCoaches(result);
          },
          onRemove: _notifier.toggleCoach,
        ),
      ],
    );
  }

  Widget _buildStep2(CreateSessionDraft draft) {
    final currency = ref.watch(tenantCurrencyProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('JADWAL'),
        Row(
          children: [
            Expanded(
              child: _PickerField(
                icon: Icons.calendar_today_outlined,
                label: draft.date != null
                    ? Formatters.formatDate(draft.date!)
                    : 'Tanggal',
                filled: draft.date != null,
                onTap: _pickDate,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: _PickerField(
                icon: Icons.schedule_outlined,
                label: draft.startTime ?? 'Jam',
                filled: draft.startTime != null,
                onTap: _pickTime,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
        _label('DURASI'),
        DurationPills(
          value: draft.durationMinutes,
          onChanged: _notifier.setDuration,
        ),
        if (draft.type != SessionType.private) ...[
          const SizedBox(height: AppDimensions.xl),
          _label('KAPASITAS'),
          CapacitySelector(
            value: draft.capacity,
            onChanged: _notifier.setCapacity,
            defaultLimit: draft.type == SessionType.trial ? 10 : 15,
          ),
        ],
        const SizedBox(height: AppDimensions.xl),
        _label('VENUE', optional: true),
        _VenueField(
          venueName: draft.venueName,
          onOpen: _pickVenue,
          onClear: _notifier.clearVenue,
        ),
        const SizedBox(height: AppDimensions.lg),
        _label('HARGA SESI', optional: true),
        TextField(
          controller: _priceCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) {
            final n = num.tryParse(v);
            _notifier.setPrice(
                n == null ? null : Formatters.toMinorUnits(n, currency));
          },
          decoration: InputDecoration(
            prefixText: '${Formatters.currencySymbol(currency)} ',
            hintText: 'Kosongkan untuk gratis',
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        _label('CATATAN', optional: true),
        TextField(
          controller: _notesCtrl,
          maxLines: 3,
          maxLength: 2000,
          onChanged: _notifier.setNotes,
          decoration: const InputDecoration(counterText: ''),
        ),
      ],
    );
  }

  Widget _buildFooter(CreateSessionDraft draft) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: _step == 0
            ? SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      draft.step1Valid ? () => setState(() => _step = 1) : null,
                  child: const Text('Lanjut'),
                ),
              )
            : Row(
                children: [
                  OutlinedButton(
                    onPressed:
                        _submitting ? null : () => setState(() => _step = 0),
                    child: const Text('Kembali'),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          (!_submitting && draft.canSubmit) ? _submit : null,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Terbitkan Sesi'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

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
    final current = ref.read(createSessionDraftProvider).startTime;
    final initial = current != null
        ? TimeOfDay(
            hour: int.tryParse(current.split(':').first) ?? 8,
            minute: int.tryParse(current.split(':').last) ?? 0,
          )
        : const TimeOfDay(hour: 8, minute: 0);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      // Snap the minutes to the nearest quarter hour.
      final snapped = ((picked.minute / 15).round() * 15) % 60;
      final hour = (picked.minute > 52) ? (picked.hour + 1) % 24 : picked.hour;
      _notifier.setStartTime(
        '${hour.toString().padLeft(2, '0')}:${snapped.toString().padLeft(2, '0')}',
      );
    }
  }

  Future<void> _pickVenue() async {
    final venues = ref.read(createSessionVenuesProvider).valueOrNull ?? [];
    final picked = await showVenuePicker(context,
        venues: venues,
        selectedId: ref.read(createSessionDraftProvider).venueId);
    if (picked != null) _notifier.setVenue(id: picked.id, name: picked.name);
  }

  Widget _label(String text, {bool optional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          Text(text,
              style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              )),
          if (optional) ...[
            const SizedBox(width: 6),
            Text('(opsional)',
                style: AppTypography.caption
                    .copyWith(color: AppColors.textTertiary)),
          ],
        ],
      ),
    );
  }
}

class _CoachField extends StatelessWidget {
  const _CoachField({
    required this.coaches,
    required this.selectedIds,
    required this.onOpen,
    required this.onRemove,
  });

  final List coaches;
  final List<int> selectedIds;
  final VoidCallback onOpen;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.add, size: 18),
          label: Text(selectedIds.isEmpty ? 'Pilih coach' : 'Ubah coach'),
        ),
        if (selectedIds.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.sm),
          SelectedCoachChips(
            coaches: coaches.cast(),
            selectedIds: selectedIds,
            onRemove: onRemove,
          ),
        ],
      ],
    );
  }
}

class _VenueField extends StatelessWidget {
  const _VenueField({
    required this.venueName,
    required this.onOpen,
    required this.onClear,
  });

  final String? venueName;
  final VoidCallback onOpen;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (venueName == null) {
      return OutlinedButton.icon(
        onPressed: onOpen,
        icon: const Icon(Icons.place_outlined, size: 18),
        label: const Text('Pilih / buat venue'),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.base, vertical: AppDimensions.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: [
          const Icon(Icons.place, size: 18, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          Expanded(child: Text(venueName!, style: AppTypography.bodyMedium)),
          GestureDetector(
            onTap: onOpen,
            child: Text('Ubah',
                style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: AppDimensions.md),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close,
                size: 18, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.neutral300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppDimensions.sm),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: filled ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
