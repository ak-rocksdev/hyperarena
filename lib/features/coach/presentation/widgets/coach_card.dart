import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachCard extends StatelessWidget {
  final Coach coach;

  const CoachCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with verified badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary50,
                  child: Text(
                    coach.name.substring(0, 1).toUpperCase(),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (coach.isVerified)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppDimensions.md),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.name,
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  // Sport pills
                  Wrap(
                    spacing: AppDimensions.xs,
                    runSpacing: AppDimensions.xs,
                    children: coach.sports.map((sport) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: sportTheme.backgroundColor(sport),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                        ),
                        child: Text(
                          SportChipSelector.sportLabel(sport),
                          style: AppTypography.badge.copyWith(
                            color: sportTheme.textColor(sport),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star_rounded,
                          size: 16, color: AppColors.accent),
                      const SizedBox(width: 2),
                      Text(
                        coach.rating.toStringAsFixed(1),
                        style: AppTypography.labelMedium,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        '(${coach.totalReviews} ulasan)',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      Text(
                        '${Formatters.formatRupiah(coach.hourlyRate)}/jam',
                        style: AppTypography.priceSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.md),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.push(AppRoutes.coach(coach.id));
                      },
                      child: const Text('Lihat'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
