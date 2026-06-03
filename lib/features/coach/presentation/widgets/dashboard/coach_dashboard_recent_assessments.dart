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
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';

class CoachDashboardRecentAssessments extends ConsumerWidget {
  const CoachDashboardRecentAssessments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentsAsync = ref.watch(assessmentListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Penilaian Terbaru', style: AppTypography.titleMedium),
            TextButton(
              onPressed: () => context.go('/coach/students'),
              child: Text(
                'Lihat Semua',
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        AsyncValueWidget<List<Assessment>>(
          value: assessmentsAsync,
          data: (assessments) {
            final sorted = [...assessments]..sort((a, b) => b.date.compareTo(a.date));
            final recent = sorted.take(3).toList();
            if (recent.isEmpty) {
              return EmptyState(
                icon: Icons.assignment_outlined,
                message: 'Belum ada penilaian',
                actionLabel: 'Buat Penilaian',
                onAction: () => context.go('/coach/students'),
              );
            }
            return Column(
              children: recent
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: _AssessmentCard(assessment: a),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  const _AssessmentCard({required this.assessment});

  double get _averageScore =>
      (assessment.technique +
              assessment.stamina +
              assessment.tactics +
              assessment.mentality +
              assessment.consistency) /
          5;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assessment.studentName, style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: AppDimensions.xxs),
                      decoration: BoxDecoration(
                        color: sportTheme.backgroundColor(assessment.sport),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        SportChipSelector.sportLabel(assessment.sport),
                        style: AppTypography.badge.copyWith(
                            color: sportTheme.textColor(assessment.sport)),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      Formatters.formatDate(assessment.date),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _averageScore.toStringAsFixed(1),
                style: AppTypography.numberMedium
                    .copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.xxs),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm,
                    vertical: AppDimensions.xxs),
                decoration: BoxDecoration(
                  color: gamification
                      .levelBackgroundColor(assessment.recommendedLevel),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  GamificationHelpers.tierLabel(assessment.recommendedLevel),
                  style: AppTypography.badge.copyWith(
                      color: gamification
                          .levelTextColor(assessment.recommendedLevel)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
