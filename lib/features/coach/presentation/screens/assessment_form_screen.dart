import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/coach/presentation/widgets/radar_chart_widget.dart';

/// Assessment form screen where a coach fills in scores for a student.
class AssessmentFormScreen extends ConsumerStatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  ConsumerState<AssessmentFormScreen> createState() =>
      _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends ConsumerState<AssessmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

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
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
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

              // ── Student Name ────────────────────────────────────
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

              // ── Sport Selector ──────────────────────────────────
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
