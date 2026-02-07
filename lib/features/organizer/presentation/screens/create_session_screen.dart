import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  int _step = 0;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '100000');

  Sport _sport = Sport.tennis;
  String? _venueId;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String _start = '19:00';
  String _end = '21:00';
  SessionPricingModel _pricingModel = SessionPricingModel.margin;
  SessionVisibility _visibility = SessionVisibility.free;
  String? _templateId;
  int _minPlayers = 2;
  int _maxPlayers = 8;
  LevelTier? _minLevel;
  LevelTier? _maxLevel;

  late final TextEditingController _startController;
  late final TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: _start);
    _endController = TextEditingController(text: _end);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _syncDraft() {
    final draft = ref.read(createSessionDraftProvider.notifier);
    draft.setTitle(_titleController.text.trim());
    draft.setDescription(_descriptionController.text.trim());
    draft.setSport(_sport);
    draft.setVenue(
      id: _venueId ?? MockData.venues.first.id,
      name: MockData.venues
          .firstWhere((v) => v.id == (_venueId ?? MockData.venues.first.id))
          .name,
    );
    draft.setDate(_date);
    draft.setTimeRange(_start, _end);
    draft.setPrice(int.tryParse(_priceController.text) ?? 0);
    draft.setParticipants(min: _minPlayers, max: _maxPlayers);
    draft.setJoinDeadline(_date.subtract(const Duration(hours: 6)));
    draft.setPricingModel(_pricingModel);
    draft.setVisibility(_visibility);
    draft.setLevelRange(_minLevel, _maxLevel);
    draft.setTemplate(_templateId);
  }

  Future<void> _publish() async {
    _syncDraft();
    final notifier = ref.read(createSessionDraftProvider.notifier);
    final created = _templateId != null
        ? await notifier.createFromTemplate(_templateId!, date: _date)
        : await notifier.submit();
    notifier.reset();
    if (!mounted) return;
    context.pushReplacement(AppRoutes.organizerSessionDetail(created.id));
  }

  String _levelLabel(LevelTier tier) => switch (tier) {
        LevelTier.rookie => 'Rookie',
        LevelTier.amateur => 'Amateur',
        LevelTier.intermediate => 'Intermediate',
        LevelTier.advanced => 'Advanced',
        LevelTier.pro => 'Pro',
      };

  String _pricingModelLabel(SessionPricingModel model) => switch (model) {
        SessionPricingModel.margin => 'Margin',
        SessionPricingModel.transparent => 'Transparan',
      };

  // ── Step builders ──────────────────────────────────────────────────

  Widget _buildStep1InfoDasar() {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Judul Sesi',
            hintText: 'Contoh: Friendly Match Futsal Malam',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Sport selector
        Text('Cabang Olahraga', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          height: AppDimensions.chipHeight + AppDimensions.sm,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: Sport.values.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppDimensions.sm),
            itemBuilder: (context, index) {
              final sport = Sport.values[index];
              final isSelected = _sport == sport;
              final sportColor = sportTheme?.color(sport) ?? AppColors.primary;
              final sportBg =
                  sportTheme?.backgroundColor(sport) ?? AppColors.primary50;

              return FilterChip(
                selected: isSelected,
                label: Text(SportChipSelector.sportLabel(sport)),
                avatar: Icon(
                  SportChipSelector.sportIcon(sport),
                  size: 18,
                  color: isSelected ? sportColor : AppColors.neutral400,
                ),
                selectedColor: sportBg,
                checkmarkColor: sportColor,
                side: isSelected
                    ? BorderSide(color: sportColor, width: 1.5)
                    : const BorderSide(color: AppColors.neutral200),
                onSelected: (_) => setState(() => _sport = sport),
              );
            },
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Description
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Deskripsi',
            hintText: 'Opsional — deskripsi singkat sesi',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Visibility selector
        Text('Visibilitas', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<SessionVisibility>(
            segments: const [
              ButtonSegment(
                value: SessionVisibility.free,
                label: Text('Terbuka'),
                icon: Icon(Icons.public, size: 18),
              ),
              ButtonSegment(
                value: SessionVisibility.invitationOnly,
                label: Text('Undangan'),
                icon: Icon(Icons.mail_outline, size: 18),
              ),
              ButtonSegment(
                value: SessionVisibility.membersOnly,
                label: Text('Member'),
                icon: Icon(Icons.lock_outline, size: 18),
              ),
            ],
            selected: {_visibility},
            onSelectionChanged: (selected) {
              setState(() => _visibility = selected.first);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStep2JadwalLokasi() {
    final selectedVenueId = _venueId ?? MockData.venues.first.id;
    final joinDeadline = _date.subtract(const Duration(hours: 6));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Venue dropdown
        DropdownButtonFormField<String>(
          initialValue: selectedVenueId,
          isExpanded: true,
          items: MockData.venues
              .map(
                (venue) => DropdownMenuItem(
                  value: venue.id,
                  child: Text(
                    venue.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _venueId = value),
          decoration: InputDecoration(
            labelText: 'Venue',
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Date picker
        Container(
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.xs,
            border: Border.all(color: AppColors.neutral200),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            title: Text('Tanggal', style: AppTypography.caption),
            subtitle: Text(
              Formatters.formatDate(_date),
              style: AppTypography.titleSmall,
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.neutral400,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDate: _date,
              );
              if (picked != null) {
                setState(() => _date = picked);
              }
            },
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Start / End time
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Mulai',
                  hintText: '19:00',
                  prefixIcon:
                      const Icon(Icons.access_time, size: 20),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                onChanged: (v) => _start = v,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: TextField(
                controller: _endController,
                decoration: InputDecoration(
                  labelText: 'Selesai',
                  hintText: '21:00',
                  prefixIcon:
                      const Icon(Icons.access_time, size: 20),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                onChanged: (v) => _end = v,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.base),

        // Join deadline (auto-calculated, read-only)
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.info, size: 20),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  'Batas gabung: ${Formatters.formatDate(joinDeadline)} '
                  '${joinDeadline.hour.toString().padLeft(2, '0')}:'
                  '${joinDeadline.minute.toString().padLeft(2, '0')}',
                  style: AppTypography.caption.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3PesertaHarga() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Max players
        Text('Maks Peserta', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        _buildCounterRow(
          value: _maxPlayers,
          min: 2,
          max: 20,
          onChanged: (v) => setState(() {
            _maxPlayers = v;
            if (_minPlayers > _maxPlayers) _minPlayers = _maxPlayers;
          }),
        ),
        const SizedBox(height: AppDimensions.base),

        // Min players
        Text('Min Peserta', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        _buildCounterRow(
          value: _minPlayers,
          min: 2,
          max: _maxPlayers,
          onChanged: (v) => setState(() => _minPlayers = v),
        ),
        const SizedBox(height: AppDimensions.base),

        // Level range
        Text('Rentang Level (opsional)', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<LevelTier?>(
                initialValue: _minLevel,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<LevelTier?>(
                    child: Text('Semua'),
                  ),
                  ...LevelTier.values.map(
                    (tier) => DropdownMenuItem<LevelTier?>(
                      value: tier,
                      child: Text(_levelLabel(tier)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _minLevel = value),
                decoration: InputDecoration(
                  labelText: 'Min Level',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.md,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: DropdownButtonFormField<LevelTier?>(
                initialValue: _maxLevel,
                isExpanded: true,
                items: [
                  const DropdownMenuItem<LevelTier?>(
                    child: Text('Semua'),
                  ),
                  ...LevelTier.values.map(
                    (tier) => DropdownMenuItem<LevelTier?>(
                      value: tier,
                      child: Text(_levelLabel(tier)),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _maxLevel = value),
                decoration: InputDecoration(
                  labelText: 'Maks Level',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.md,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.base),

        // Price per person
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Harga per Peserta',
            prefixText: 'Rp ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.base),

        // Pricing model
        Text('Model Harga', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<SessionPricingModel>(
            segments: const [
              ButtonSegment(
                value: SessionPricingModel.margin,
                label: Text('Margin'),
              ),
              ButtonSegment(
                value: SessionPricingModel.transparent,
                label: Text('Transparan'),
              ),
            ],
            selected: {_pricingModel},
            onSelectionChanged: (selected) {
              setState(() => _pricingModel = selected.first);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCounterRow({
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
        border: Border.all(color: AppColors.neutral200),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.primary,
            disabledColor: AppColors.neutral300,
          ),
          SizedBox(
            width: 48,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.titleMedium,
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            disabledColor: AppColors.neutral300,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Review() {
    final templatesAsync = ref.watch(organizerTemplatesProvider);
    final sessionsAsync = ref.watch(organizerSessionsProvider);

    final selectedVenueId = _venueId ?? MockData.venues.first.id;
    final venueName = MockData.venues
        .firstWhere((v) => v.id == selectedVenueId)
        .name;
    final price = int.tryParse(_priceController.text) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppShadows.sm,
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ringkasan Sesi', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              _summaryRow(
                'Judul',
                _titleController.text.isEmpty
                    ? '(belum diisi)'
                    : _titleController.text,
              ),
              _summaryRow(
                'Olahraga',
                SportChipSelector.sportLabel(_sport),
              ),
              _summaryRow('Venue', venueName),
              _summaryRow('Tanggal', Formatters.formatDate(_date)),
              _summaryRow(
                'Waktu',
                Formatters.formatTimeRange(_start, _end),
              ),
              _summaryRow('Peserta', '$_minPlayers - $_maxPlayers pemain'),
              if (_minLevel != null || _maxLevel != null)
                _summaryRow(
                  'Level',
                  '${_minLevel != null ? _levelLabel(_minLevel!) : 'Semua'}'
                  ' - '
                  '${_maxLevel != null ? _levelLabel(_maxLevel!) : 'Semua'}',
                ),
              _summaryRow('Harga', Formatters.formatRupiah(price)),
              _summaryRow(
                'Visibilitas',
                Formatters.visibilityLabel(_visibility),
              ),
              _summaryRow(
                'Model Harga',
                _pricingModelLabel(_pricingModel),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.lg),

        // Template / Duplicate section
        Text('Template & Duplikasi', style: AppTypography.titleSmall),
        const SizedBox(height: AppDimensions.sm),
        AsyncValueWidget(
          value: templatesAsync,
          data: (templates) {
            if (templates.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Text(
                  'Tidak ada template tersedia',
                  style: AppTypography.caption,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: Wrap(
                spacing: AppDimensions.sm,
                runSpacing: AppDimensions.sm,
                children: templates.entries.map((entry) {
                  final isActive = _templateId == entry.key;
                  return ActionChip(
                    avatar: Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: isActive
                          ? AppColors.primary
                          : AppColors.neutral400,
                    ),
                    label: Text(entry.value),
                    backgroundColor: isActive
                        ? AppColors.primary50
                        : null,
                    side: isActive
                        ? const BorderSide(color: AppColors.primary)
                        : null,
                    onPressed: () {
                      setState(() {
                        _templateId =
                            _templateId == entry.key ? null : entry.key;
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.sm),
        Text('Duplikasi dari sesi sebelumnya', style: AppTypography.caption),
        const SizedBox(height: AppDimensions.xs),
        AsyncValueWidget(
          value: sessionsAsync,
          data: (sessions) {
            if (sessions.isEmpty) {
              return Text(
                'Belum ada sesi untuk diduplikasi',
                style: AppTypography.caption,
              );
            }
            return Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: sessions.take(5).map((session) {
                return ActionChip(
                  avatar: const Icon(
                    Icons.copy_outlined,
                    size: 16,
                    color: AppColors.neutral400,
                  ),
                  label: Text(session.title),
                  onPressed: () async {
                    final nav = GoRouter.of(context);
                    final created = await ref
                        .read(createSessionDraftProvider.notifier)
                        .duplicateFromSession(
                          session.id,
                          newDate: _date,
                        );
                    if (!mounted) return;
                    nav.pushReplacement(
                      AppRoutes.organizerSessionDetail(created.id),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: AppDimensions.lg),

        // Publish button
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeightLg,
          child: FilledButton.icon(
            onPressed: _publish,
            icon: const Icon(Icons.publish),
            label: const Text('Terbitkan Sesi'),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => setState(() => _step--),
            child: const Text('Kembali'),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.caption,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSurfaces.background,
      appBar: AppBar(
        title: const Text('Buat Sesi Organizer'),
      ),
      body: Stepper(
        currentStep: _step,
        physics: const ClampingScrollPhysics(),
        onStepCancel: () {
          if (_step > 0) {
            setState(() => _step--);
          } else {
            Navigator.pop(context);
          }
        },
        onStepContinue: () async {
          if (_step < 3) {
            _syncDraft();
            setState(() => _step++);
            return;
          }
          // Step 4 publish is handled via the button inside the step
          await _publish();
        },
        onStepTapped: (index) {
          if (index <= _step) {
            setState(() => _step = index);
          }
        },
        controlsBuilder: (context, details) {
          // Step 4 has its own publish button
          if (_step == 3) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(top: AppDimensions.base),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: const Text('Lanjut'),
                ),
                const SizedBox(width: AppDimensions.sm),
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Kembali'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Info Dasar'),
            subtitle: _step > 0
                ? Text(
                    '${SportChipSelector.sportLabel(_sport)}'
                    '${_titleController.text.isNotEmpty ? ' - ${_titleController.text}' : ''}',
                    style: AppTypography.caption,
                  )
                : null,
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: _buildStep1InfoDasar(),
          ),
          Step(
            title: const Text('Jadwal & Lokasi'),
            subtitle: _step > 1
                ? Text(
                    '${Formatters.formatDate(_date)} $_start-$_end',
                    style: AppTypography.caption,
                  )
                : null,
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: _buildStep2JadwalLokasi(),
          ),
          Step(
            title: const Text('Peserta & Harga'),
            subtitle: _step > 2
                ? Text(
                    '$_minPlayers-$_maxPlayers pemain, '
                    '${Formatters.formatRupiah(int.tryParse(_priceController.text) ?? 0)}',
                    style: AppTypography.caption,
                  )
                : null,
            isActive: _step >= 2,
            state: _step > 2 ? StepState.complete : StepState.indexed,
            content: _buildStep3PesertaHarga(),
          ),
          Step(
            title: const Text('Review & Terbitkan'),
            isActive: _step >= 3,
            state: _step == 3 ? StepState.editing : StepState.indexed,
            content: _buildStep4Review(),
          ),
        ],
      ),
    );
  }
}
