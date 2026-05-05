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
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/role_switch_section.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/gamification/data/models/badge.dart'
    as badge_model;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final isPlayer = user?.role == UserRole.player;
    final userName = user?.name ?? 'Player';

    // Player-only derivations are `late` so coaches/organizers/owners don't
    // pay the cost of reading mock data, sorting bookings, or resolving theme
    // extensions that their profile never renders.
    late final profile = MockData.currentProfile;
    late final badges = MockData.badges;
    late final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    late final sportTheme =
        Theme.of(context).extension<SportThemeExtension>()!;
    late final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    late final nextThreshold = GamificationHelpers.threshold(profile.levelTier);
    late final progress = GamificationHelpers.xpProgress(
      profile.totalXp,
      profile.levelTier,
    );
    late final xpToNext = nextThreshold - profile.totalXp;

    late final lastThreeBookings = ([...MockData.bookings]
          ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate)))
        .take(3)
        .toList();

    late final sportStats = <Sport, Map<String, int>>{
      Sport.tennis: {'bookings': 4, 'hours': 8},
      Sport.badminton: {'bookings': 2, 'hours': 4},
    };

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── 1. Hero Header SliverAppBar ──
          SliverAppBar(
            expandedHeight: 310,
            pinned: true,
            backgroundColor: AppColors.primary700,
            title: const Text('Profil'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppSurfaces.primaryGradient,
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -30,
                      right: -20,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 30,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    // Center content: avatar + name + level badge
                    SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppDimensions.xl),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Avatar with white border and shadow
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: AppShadows.lg,
                                ),
                                child: CircleAvatar(
                                  radius: AppDimensions.avatarXl / 2,
                                  backgroundColor: AppColors.primary50,
                                  backgroundImage:
                                      user?.avatarUrl != null
                                          ? NetworkImage(user!.avatarUrl!)
                                          : null,
                                  child: user?.avatarUrl == null
                                      ? Text(
                                          Formatters.initials(userName),
                                          style: AppTypography.headingMedium
                                              .copyWith(
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.md),
                              // Player name
                              Text(
                                userName,
                                style: AppTypography.headingMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              if (isPlayer) ...[
                                const SizedBox(height: AppDimensions.sm),
                                // Level badge pill (player-only — tied to gamification)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gamification.levelBackgroundColor(
                                      profile.levelTier,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusFull,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: gamification.levelTextColor(
                                          profile.levelTier,
                                        ),
                                      ),
                                      const SizedBox(width: AppDimensions.xs),
                                      Text(
                                        GamificationHelpers.tierLabel(
                                          profile.levelTier,
                                        ),
                                        style: AppTypography.labelMedium
                                            .copyWith(
                                          color: gamification.levelTextColor(
                                            profile.levelTier,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Rest of content ──
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.base),
                if (isPlayer) ...[
                // ── 2. XP Progress Section ──
                Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    padding: const EdgeInsets.all(AppDimensions.base),
                    decoration: BoxDecoration(
                      color: AppSurfaces.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXl,
                      ),
                      boxShadow: AppShadows.sm,
                    ),
                    child: Column(
                      children: [
                        // XP text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${profile.totalXp}',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' / $nextThreshold XP',
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        // Progress bar
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: gamification
                                      .levelColor(profile.levelTier),
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusFull,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        // XP to next level
                        Text(
                          '+$xpToNext XP ke Level Berikutnya',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: AppDimensions.md),

                // ── 3. Streak Banner ──
                if (profile.bookingStreak > 0) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.base,
                        vertical: AppDimensions.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent50,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: AppColors.accent,
                            size: 22,
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Text(
                            '${profile.bookingStreak} booking berturut-turut!',
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ],

                // ── 4. Pencapaian (Achievements) Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pencapaian', style: AppTypography.titleMedium),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.achievements),
                        child: Text(
                          'Lihat Semua \u2192',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    itemCount: badges.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      return _BadgeCard(
                        badge: badge,
                        tierColor: gamification.levelColor(profile.levelTier),
                        onTap: () => _showBadgeDetail(context, badge),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 5. Statistik Olahraga (Sport Stats) Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Text(
                    'Statistik Olahraga',
                    style: AppTypography.titleMedium,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Column(
                    children: [
                      for (final sport in profile.sports) ...[
                        _SportStatRow(
                          sport: sport,
                          sportTheme: sportTheme,
                          gamification: gamification,
                          bookingCount:
                              sportStats[sport]?['bookings'] ?? 0,
                          hours: sportStats[sport]?['hours'] ?? 0,
                          levelLabel: profile
                                  .selfAssessedLevels[sport.name] ??
                              'rookie',
                        ),
                        if (sport != profile.sports.last)
                          const SizedBox(height: AppDimensions.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 6. Aktivitas Terbaru (Recent Activity) Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Text(
                    'Aktivitas Terbaru',
                    style: AppTypography.titleMedium,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < lastThreeBookings.length; i++) ...[
                        _RecentActivityCard(
                          booking: lastThreeBookings[i],
                          statusTheme: statusTheme,
                          sportTheme: sportTheme,
                          sport: profile.sports.first,
                        ),
                        if (i < lastThreeBookings.length - 1)
                          const SizedBox(height: AppDimensions.sm),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                ], // end if (isPlayer)

                // ── 7. Role Switch Section ──
                const RoleSwitchSection(),

                // ── 8. Menu Items ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.edit,
                        label: 'Edit Profil',
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      if (isPlayer) ...[
                        _MenuItem(
                          icon: Icons.show_chart,
                          label: 'Perkembangan',
                          onTap: () => context.push(AppRoutes.career),
                        ),
                        _MenuItem(
                          icon: Icons.emoji_events,
                          label: 'Pencapaian',
                          onTap: () => context.push(AppRoutes.achievements),
                        ),
                      ],
                      _MenuItem(
                        icon: Icons.settings,
                        label: 'Pengaturan',
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                      _MenuItem(
                        icon: Icons.info_outline,
                        label: 'Tentang Aplikasi',
                        onTap: () => _showAboutDialog(context),
                      ),
                      _MenuItem(
                        icon: Icons.logout,
                        label: 'Keluar',
                        isDestructive: true,
                        onTap: () async {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          if (context.mounted) context.go(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Badge Card Widget ──

class _BadgeCard extends StatelessWidget {
  final badge_model.Badge badge;
  final Color tierColor;
  final VoidCallback? onTap;

  const _BadgeCard({
    required this.badge,
    required this.tierColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.5,
        child: Container(
          width: 110,
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: isUnlocked ? AppSurfaces.surfaceHighlight : AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppShadows.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle — larger
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? AppColors.primary50
                      : AppColors.neutral100,
                  boxShadow: isUnlocked ? AppShadows.xs : null,
                ),
                child: Icon(
                  _mapBadgeIcon(badge.iconName),
                  size: 32,
                  color: isUnlocked ? tierColor : AppColors.neutral400,
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              // Badge name
              Text(
                badge.name,
                style: AppTypography.caption.copyWith(
                  fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xs),
              // Status label
              Text(
                isUnlocked ? 'Terbuka' : 'Terkunci',
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  color: isUnlocked
                      ? AppColors.success
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sport Stat Row Widget ──

class _SportStatRow extends StatelessWidget {
  final Sport sport;
  final SportThemeExtension sportTheme;
  final GamificationThemeExtension gamification;
  final int bookingCount;
  final int hours;
  final String levelLabel;

  const _SportStatRow({
    required this.sport,
    required this.sportTheme,
    required this.gamification,
    required this.bookingCount,
    required this.hours,
    required this.levelLabel,
  });

  LevelTier _parseTier(String label) => switch (label.toLowerCase()) {
        'rookie' => LevelTier.rookie,
        'amateur' => LevelTier.amateur,
        'intermediate' => LevelTier.intermediate,
        'advanced' => LevelTier.advanced,
        'pro' => LevelTier.pro,
        _ => LevelTier.rookie,
      };

  @override
  Widget build(BuildContext context) {
    final tier = _parseTier(levelLabel);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          // Sport icon circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sportTheme.backgroundColor(sport),
            ),
            child: Icon(
              SportChipSelector.sportIcon(sport),
              size: 20,
              color: sportTheme.color(sport),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          // Center column: sport label + level pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SportChipSelector.sportLabel(sport),
                  style: AppTypography.titleSmall,
                ),
                const SizedBox(height: AppDimensions.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: gamification.levelBackgroundColor(tier),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    GamificationHelpers.tierLabel(tier),
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: gamification.levelTextColor(tier),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right column: booking count + hours
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$bookingCount booking',
                style: AppTypography.bodySmall,
              ),
              Text(
                '$hours jam',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Recent Activity Card Widget ──

class _RecentActivityCard extends StatelessWidget {
  final Booking booking;
  final BookingStatusThemeExtension statusTheme;
  final SportThemeExtension sportTheme;
  final Sport sport;

  const _RecentActivityCard({
    required this.booking,
    required this.statusTheme,
    required this.sportTheme,
    required this.sport,
  });

  String _statusLabel(BookingStatus status) => switch (status) {
        BookingStatus.pendingPayment => 'Menunggu Bayar',
        BookingStatus.waitingConfirmation => 'Menunggu Konfirmasi',
        BookingStatus.confirmed => 'Dikonfirmasi',
        BookingStatus.completed => 'Selesai',
        BookingStatus.cancelled => 'Dibatalkan',
        BookingStatus.rejected => 'Ditolak',
        BookingStatus.expired => 'Kedaluwarsa',
      };

  @override
  Widget build(BuildContext context) {
    final xpEarned = booking.totalAmount ~/ 15000;
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.xs,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Sport-colored left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: sportTheme.color(sport),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                ),
              ),
            ),
            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Date + Status badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatDate(booking.bookingDate),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusTheme.backgroundColor(
                              booking.status,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            _statusLabel(booking.status),
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: statusTheme.textColor(booking.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    // Row 2: Venue name + Court name
                    Text(
                      booking.venueName ?? 'Venue',
                      style: AppTypography.titleSmall,
                    ),
                    Text(
                      booking.courtName ?? 'Court',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    // Row 3: Time range + XP earned pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatTimeRange(
                            booking.startTime,
                            booking.endTime,
                          ),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent50,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            '+$xpEarned XP',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge Icon Mapping ──

IconData _mapBadgeIcon(String iconName) => switch (iconName) {
      'emoji_events' => Icons.emoji_events,
      'repeat' => Icons.repeat,
      'fitness_center' => Icons.fitness_center,
      'wb_sunny' => Icons.wb_sunny,
      'nightlight' => Icons.nightlight,
      'groups' => Icons.groups,
      'explore' => Icons.explore,
      'local_fire_department' => Icons.local_fire_department,
      _ => Icons.star,
    };

// ── Badge Detail Bottom Sheet ──

void _showBadgeDetail(BuildContext context, badge_model.Badge badge) {
  final isUnlocked = badge.isUnlocked;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusXl),
      ),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          // Badge icon — large
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked ? AppColors.primary50 : AppColors.neutral100,
              boxShadow: isUnlocked ? AppShadows.sm : null,
            ),
            child: Icon(
              _mapBadgeIcon(badge.iconName),
              size: 44,
              color: isUnlocked ? AppColors.primary : AppColors.neutral400,
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          // Badge name
          Text(
            badge.name,
            style: AppTypography.headingSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.sm),
          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.success.withValues(alpha: 0.1) : AppColors.neutral100,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              isUnlocked ? 'Terbuka' : 'Terkunci',
              style: AppTypography.labelSmall.copyWith(
                color: isUnlocked ? AppColors.success : AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          // Description
          Text(
            badge.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.sm),
          // XP reward
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt, size: 16, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                '+${badge.xpReward} XP',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (isUnlocked && badge.unlockedAt != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Dibuka pada ${Formatters.formatDate(badge.unlockedAt!)}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    ),
  );
}

// ── About Dialog ──

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      title: Row(
        children: [
          Icon(Icons.sports_tennis, color: AppColors.primary),
          const SizedBox(width: AppDimensions.sm),
          const Text('HyperArena'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Beta Release v0.0.1',
            style: AppTypography.titleSmall,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Platform booking lapangan olahraga untuk tenis, padel, badminton, futsal, dan lainnya.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          Text(
            '\u00a9 2026 HyperArena',
            style: AppTypography.caption,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

// ── Menu Item Widget ──

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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Container(
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusMd),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.base,
                vertical: AppDimensions.md,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isDestructive
                        ? AppColors.error
                        : AppColors.neutral600,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(
                      label,
                      style: isDestructive
                          ? AppTypography.bodyLarge
                              .copyWith(color: AppColors.error)
                          : AppTypography.bodyLarge,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.neutral400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
