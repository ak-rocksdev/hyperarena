import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/gamification/data/models/badge.dart' as app;
import 'package:intl/intl.dart';

class BadgeGrid extends StatelessWidget {
  final List<app.Badge> badges;

  const BadgeGrid({
    super.key,
    required this.badges,
  });

  IconData _badgeIcon(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'timer':
        return Icons.timer;
      case 'group':
        return Icons.group;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppDimensions.screenHorizontal),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        final isUnlocked = badge.isUnlocked;

        return Container(
          decoration: BoxDecoration(
            color: isUnlocked ? AppSurfaces.surface : AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.sm,
            border: Border.all(
              color: isUnlocked ? AppColors.neutral100 : AppColors.neutral300,
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? AppColors.primary50
                            : AppColors.neutral300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _badgeIcon(badge.iconName),
                        size: 32,
                        color: isUnlocked
                            ? AppColors.primary
                            : AppColors.neutral400,
                      ),
                    ),
                    if (!isUnlocked)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 24,
                          color: AppColors.neutral500,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppDimensions.sm),
                Text(
                  badge.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimensions.xs),
                Text(
                  badge.description,
                  style: AppTypography.caption.copyWith(
                    color: isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimensions.sm),
                if (isUnlocked) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent50,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      '+${badge.xpReward} XP',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (badge.unlockedAt != null) ...[
                    SizedBox(height: AppDimensions.xs),
                    Text(
                      DateFormat('dd MMM yyyy').format(badge.unlockedAt!),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
