import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/presentation/widgets/radar_chart_widget.dart';
import 'package:hyperarena/features/coach/providers/student_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class StudentDetailScreen extends ConsumerWidget {
  final String studentName;

  const StudentDetailScreen({super.key, required this.studentName});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentsAsync = ref.watch(studentAssessmentsProvider(studentName));
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;

    return Scaffold(
      appBar: AppBar(title: Text(studentName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.base),

            // ── Avatar ────────────────────────────────────────────
            CircleAvatar(
              radius: AppDimensions.avatarLg / 2,
              backgroundColor: AppColors.primary50,
              child: Text(
                _initials(studentName),
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // ── Student Name ──────────────────────────────────────
            Text(
              studentName,
              style: AppTypography.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xl),

            // ── Section Header ────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Penilaian',
                style: AppTypography.titleMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // ── Assessment List ───────────────────────────────────
            AsyncValueWidget<List<Assessment>>(
              value: assessmentsAsync,
              data: (assessments) {
                if (assessments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.xxl,
                    ),
                    child: Center(
                      child: Text(
                        'Belum ada penilaian',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  );
                }

                final sorted = [...assessments]
                  ..sort((a, b) => b.date.compareTo(a.date));

                return Column(
                  children: sorted
                      .map(
                        (assessment) => _AssessmentDetailCard(
                          assessment: assessment,
                          sportTheme: sportTheme,
                          gamification: gamification,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: AppDimensions.xl),

            // ── New Assessment Button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: AppShadows.colored,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: AppButton(
                  label: 'Buat Penilaian Baru',
                  icon: Icons.add,
                  onPressed: () => context.push(AppRoutes.assessmentNew),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xxl),
          ],
        ),
      ),
    );
  }
}

// ── Assessment Detail Card ──────────────────────────────────────────────
class _AssessmentDetailCard extends StatelessWidget {
  final Assessment assessment;
  final SportThemeExtension sportTheme;
  final GamificationThemeExtension gamification;

  const _AssessmentDetailCard({
    required this.assessment,
    required this.sportTheme,
    required this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    final values = [
      assessment.technique / 10.0,
      assessment.stamina / 10.0,
      assessment.tactics / 10.0,
      assessment.mentality / 10.0,
      assessment.consistency / 10.0,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: Date + Sport Pill ──────────────────────
            Row(
              children: [
                Text(
                  Formatters.formatDate(assessment.date),
                  style: AppTypography.caption,
                ),
                const SizedBox(width: AppDimensions.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: sportTheme.backgroundColor(assessment.sport),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    SportChipSelector.sportLabel(assessment.sport),
                    style: AppTypography.badge.copyWith(
                      color: sportTheme.textColor(assessment.sport),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // ── Radar Chart ───────────────────────────────────
            Center(child: RadarChartWidget(values: values, size: 150)),
            const SizedBox(height: AppDimensions.md),

            // ── Recommended Level Badge ───────────────────────
            Row(
              children: [
                Text(
                  'Rekomendasi Level:',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: gamification
                        .levelBackgroundColor(assessment.recommendedLevel),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    GamificationHelpers.tierLabel(
                      assessment.recommendedLevel,
                    ),
                    style: AppTypography.badge.copyWith(
                      color: gamification
                          .levelTextColor(assessment.recommendedLevel),
                    ),
                  ),
                ),
              ],
            ),

            // ── Notes ─────────────────────────────────────────
            if (assessment.notes != null &&
                assessment.notes!.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.sm),
              Text(
                assessment.notes!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
