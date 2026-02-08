import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/coach/presentation/widgets/radar_chart_widget.dart';

/// Assessment form screen where a coach fills in scores for a student.
/// When [sessionId] is provided, runs in session-linked mode with
/// pre-filled context and improvement feedback fields.
class AssessmentFormScreen extends ConsumerStatefulWidget {
  final String? sessionId;
  final String? sessionTitle;
  final String? studentId;
  final String? studentName;
  final Sport? sport;
  final DateTime? sessionDate;

  const AssessmentFormScreen({
    super.key,
    this.sessionId,
    this.sessionTitle,
    this.studentId,
    this.studentName,
    this.sport,
    this.sessionDate,
  });

  bool get isSessionLinked => sessionId != null;

  @override
  ConsumerState<AssessmentFormScreen> createState() =>
      _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends ConsumerState<AssessmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _strengthController = TextEditingController();
  final _improveController = TextEditingController();
  final _styleController = TextEditingController();

  Sport? _selectedSport;
  int _technique = 5;
  int _stamina = 5;
  int _tactics = 5;
  int _mentality = 5;
  int _consistency = 5;
  LevelTier? _recommendedLevel;

  static const _availableSports = [
    Sport.tennis,
    Sport.badminton,
    Sport.padel,
    Sport.futsal,
  ];

  static String _sportLabel(Sport sport) => switch (sport) {
        Sport.tennis => 'Tennis',
        Sport.badminton => 'Badminton',
        Sport.padel => 'Padel',
        Sport.futsal => 'Futsal',
        Sport.basketball => 'Basketball',
        Sport.volleyball => 'Volleyball',
        Sport.tableTennis => 'Table Tennis',
      };

  @override
  void initState() {
    super.initState();
    if (widget.isSessionLinked) {
      _nameController.text = widget.studentName ?? '';
      _selectedSport = widget.sport;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _strengthController.dispose();
    _improveController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Penilaian berhasil disimpan'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamificationTheme =
        Theme.of(context).extension<GamificationThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),

              // ── Session context banner (session-linked mode) ──
              if (widget.isSessionLinked) ...[
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.primary100),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_outlined,
                        color: AppColors.primary700,
                        size: AppDimensions.iconMd,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.sessionTitle ?? 'Sesi Latihan',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary800,
                              ),
                            ),
                            if (widget.sessionDate != null) ...[
                              const SizedBox(height: AppDimensions.xxs),
                              Text(
                                Formatters.formatDate(widget.sessionDate!),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.base),
                // Show student name as read-only
                Text(
                  'Murid: ${widget.studentName ?? "-"}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
              ],

              // ── Student Name (standalone mode only) ──────────
              if (!widget.isSessionLinked) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Murid',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama murid wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.xl),
              ],

              // ── Sport Selector (standalone mode only) ────────
              if (!widget.isSessionLinked) ...[
                Text('Cabang Olahraga', style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.sm),
                Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.sm,
                  children: _availableSports.map((sport) {
                    final isSelected = _selectedSport == sport;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSport = sport),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                          vertical: AppDimensions.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? sportTheme.backgroundColor(sport)
                              : AppColors.neutral100,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusFull),
                        ),
                        child: Text(
                          _sportLabel(sport),
                          style: AppTypography.labelMedium.copyWith(
                            color: isSelected
                                ? sportTheme.textColor(sport)
                                : AppColors.neutral600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimensions.xl),
              ],

              // ── Sliders ─────────────────────────────────────────
              _buildSlider(
                label: 'Teknik',
                value: _technique,
                onChanged: (v) => setState(() => _technique = v),
              ),
              _buildSlider(
                label: 'Stamina',
                value: _stamina,
                onChanged: (v) => setState(() => _stamina = v),
              ),
              _buildSlider(
                label: 'Taktik',
                value: _tactics,
                onChanged: (v) => setState(() => _tactics = v),
              ),
              _buildSlider(
                label: 'Mental',
                value: _mentality,
                onChanged: (v) => setState(() => _mentality = v),
              ),
              _buildSlider(
                label: 'Konsistensi',
                value: _consistency,
                onChanged: (v) => setState(() => _consistency = v),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Radar Preview ───────────────────────────────────
              Text('Radar Penilaian', style: AppTypography.titleSmall),
              const SizedBox(height: AppDimensions.sm),
              Center(
                child: RadarChartWidget(
                  size: 200,
                  values: [
                    _technique / 10,
                    _stamina / 10,
                    _tactics / 10,
                    _mentality / 10,
                    _consistency / 10,
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Recommended Level ───────────────────────────────
              DropdownButtonFormField<LevelTier>(
                initialValue: _recommendedLevel,
                decoration: const InputDecoration(
                  labelText: 'Level Rekomendasi',
                ),
                items: LevelTier.values.map((tier) {
                  return DropdownMenuItem<LevelTier>(
                    value: tier,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: gamificationTheme.levelColor(tier),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Text(GamificationHelpers.tierLabel(tier)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => _recommendedLevel = value,
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Notes ───────────────────────────────────────────
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Tambahkan catatan untuk murid...',
                  alignLabelWithHint: true,
                ),
              ),

              // ── Improvement fields (session-linked mode only) ──
              if (widget.isSessionLinked) ...[
                const SizedBox(height: AppDimensions.xl),
                const Divider(),
                const SizedBox(height: AppDimensions.base),
                Text(
                  'Feedback Detail Sesi',
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: AppDimensions.base),

                TextFormField(
                  controller: _strengthController,
                  decoration: const InputDecoration(
                    labelText: 'Kelebihan Utama',
                    hintText:
                        'Apa kelebihan utama pemain ini di sesi ini?',
                    prefixIcon: Icon(Icons.star_outline),
                  ),
                ),
                const SizedBox(height: AppDimensions.base),

                TextFormField(
                  controller: _improveController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Yang Perlu Diperbaiki',
                    hintText:
                        'Apa yang perlu diperbaiki? Berikan saran spesifik.',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(Icons.trending_up),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.base),

                TextFormField(
                  controller: _styleController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Gaya Bermain',
                    hintText:
                        'Catatan tentang gaya bermain, pola permainan, atau kebiasaan.',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(Icons.sports),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),

                // Privacy notice
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: AppDimensions.iconSm,
                        color: AppColors.neutral400,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          'Catatan ini hanya dapat dilihat oleh Anda dan pemain.',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppDimensions.xxl),

              // ── Submit Button ───────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: AppShadows.colored,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: AppButton(
                  label: 'Simpan Penilaian',
                  isLarge: true,
                  onPressed: _submit,
                ),
              ),
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodyMedium),
              Text(
                '$value',
                style: AppTypography.numberMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppColors.primary,
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}
