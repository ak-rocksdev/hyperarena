import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final profile = MockData.currentProfile;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;

    // XP thresholds per tier
    const tierThresholds = {
      LevelTier.rookie: 500,
      LevelTier.amateur: 1500,
      LevelTier.intermediate: 3500,
      LevelTier.advanced: 7000,
      LevelTier.pro: 15000,
    };
    final nextThreshold = tierThresholds[profile.levelTier] ?? 500;
    final progress = (profile.totalXp / nextThreshold).clamp(0.0, 1.0);

    String tierLabel(LevelTier tier) => switch (tier) {
          LevelTier.rookie => 'Rookie',
          LevelTier.amateur => 'Amateur',
          LevelTier.intermediate => 'Intermediate',
          LevelTier.advanced => 'Advanced',
          LevelTier.pro => 'Pro',
        };

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.xl),

            // Avatar
            CircleAvatar(
              radius: AppDimensions.avatarXl / 2,
              backgroundColor: AppColors.primary50,
              child: Text(
                (user?.name ?? 'P').substring(0, 1).toUpperCase(),
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),

            // Name
            Text(
              user?.name ?? 'Player',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: AppDimensions.sm),

            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: gamification.levelBackgroundColor(profile.levelTier),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                tierLabel(profile.levelTier),
                style: AppTypography.labelMedium.copyWith(
                  color: gamification.levelTextColor(profile.levelTier),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.base),

            // XP progress
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${profile.totalXp} XP',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  ' / $nextThreshold XP',
                  style: AppTypography.caption,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.neutral100,
                valueColor: AlwaysStoppedAnimation(
                  gamification.levelColor(profile.levelTier),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Quick stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.calendar_today,
                    value: '6',
                    label: 'Total Booking',
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: _StatCard(
                    icon: Icons.sports,
                    value: '${profile.sports.length}',
                    label: 'Olahraga',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.xl),

            // Menu
            _MenuItem(
              icon: Icons.edit,
              label: 'Edit Profil',
              onTap: () {}, // Placeholder
            ),
            _MenuItem(
              icon: Icons.emoji_events,
              label: 'Pencapaian',
              onTap: () {}, // Placeholder
            ),
            _MenuItem(
              icon: Icons.settings,
              label: 'Pengaturan',
              onTap: () {}, // Placeholder
            ),
            _MenuItem(
              icon: Icons.logout,
              label: 'Keluar',
              isDestructive: true,
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).logout();
                if (context.mounted) context.go('/auth/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: AppDimensions.sm),
          Text(value, style: AppTypography.numberMedium),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : null,
      ),
      title: Text(
        label,
        style: isDestructive
            ? AppTypography.bodyLarge.copyWith(color: AppColors.error)
            : AppTypography.bodyLarge,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
