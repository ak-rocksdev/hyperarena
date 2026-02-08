import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/gamification/data/models/badge.dart' as app;
import 'package:hyperarena/features/gamification/presentation/widgets/badge_grid.dart';
import 'package:hyperarena/features/gamification/providers/gamification_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeListAsync = ref.watch(badgeListProvider);
    final profile = MockData.currentProfile;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        appBar: AppBar(
          title: Text('Pencapaian'),
          backgroundColor: AppSurfaces.surface,
          elevation: 0,
          shadowColor: Colors.black12,
        ),
        body: AsyncValueWidget<List<app.Badge>>(
          value: badgeListAsync,
          data: (badges) {
            final unlockedCount = badges.where((b) => b.isUnlocked).length;
            final totalCount = badges.length;

            return Column(
              children: [
                Container(
                  color: AppSurfaces.surface,
                  padding: EdgeInsets.all(AppDimensions.screenHorizontal),
                  child: Column(
                    children: [
                      _buildXpHeader(profile.totalXp, profile.levelTier),
                      SizedBox(height: AppDimensions.base),
                      _buildStatsRow(unlockedCount, totalCount),
                    ],
                  ),
                ),
                Container(
                  color: AppSurfaces.surface,
                  child: TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    labelStyle: AppTypography.labelMedium,
                    tabs: const [
                      Tab(text: 'Semua'),
                      Tab(text: 'Terbuka'),
                      Tab(text: 'Terkunci'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      BadgeGrid(badges: badges),
                      BadgeGrid(
                        badges: badges.where((b) => b.isUnlocked).toList(),
                      ),
                      BadgeGrid(
                        badges: badges.where((b) => !b.isUnlocked).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildXpHeader(int totalXp, LevelTier levelTier) {
    final tierLabel = GamificationHelpers.tierLabel(levelTier);
    final xpForNextTier = GamificationHelpers.threshold(levelTier);
    final progress = GamificationHelpers.xpProgress(totalXp, levelTier);

    return Container(
      padding: EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.md,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tierLabel,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimensions.xs),
                  Text(
                    '$totalXp / $xpForNextTier XP',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  size: 32,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int unlockedCount, int totalCount) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.workspace_premium,
            color: AppColors.accent,
            size: 20,
          ),
          SizedBox(width: AppDimensions.sm),
          Text(
            '$unlockedCount / $totalCount badge terbuka',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
