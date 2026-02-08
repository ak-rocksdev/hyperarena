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
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/features/booking/presentation/widgets/booking_card.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/gamification/providers/gamification_providers.dart';
import 'package:hyperarena/features/notification/presentation/widgets/notification_bell.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final bookingsAsync = ref.watch(bookingListProvider);
    final profile = MockData.currentProfile;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    final stats = ref.watch(playerStatsProvider);
    final badgesAsync = ref.watch(badgeListProvider);

    final tierColor = gamification.levelColor(profile.levelTier);
    final nextThreshold = GamificationHelpers.threshold(profile.levelTier);
    final progress = GamificationHelpers.xpProgress(
      profile.totalXp,
      profile.levelTier,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),

              // Greeting + Notification bell
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting()},',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user?.name ?? 'Player',
                          style: AppTypography.headingLarge,
                        ),
                      ],
                    ),
                  ),
                  const NotificationBell(),
                ],
              ),
              const SizedBox(height: AppDimensions.base),

              // ── Gamification Card ─────────────────────────────────
              _GamificationCard(
                tierLabel: GamificationHelpers.tierLabel(profile.levelTier),
                tierColor: tierColor,
                totalXp: profile.totalXp,
                nextThreshold: nextThreshold,
                progress: progress,
                onTap: () => context.go(AppRoutes.profile(ref.read(authNotifierProvider)!.role)),
              ),
              const SizedBox(height: AppDimensions.xl),

              // Hero CTA card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: AppShadows.colored,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLg),
                    onTap: () => context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 48,
                            color: AppColors.textOnPrimary,
                          ),
                          const SizedBox(width: AppDimensions.base),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cari Lapangan',
                                  style: AppTypography.titleMedium
                                      .copyWith(
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                                const SizedBox(
                                    height: AppDimensions.xxs),
                                Text(
                                  'Temukan venue terdekat',
                                  style: AppTypography.bodySmall
                                      .copyWith(
                                    color: AppColors.textOnPrimary
                                        .withValues(alpha: 0.80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.textOnPrimary
                                .withValues(alpha: 0.60),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Quick Stats Row ───────────────────────────────────
              Row(
                children: [
                  _QuickStatCard(
                    icon: Icons.calendar_today,
                    value: '${stats.totalBookings}',
                    label: 'Total Booking',
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  _QuickStatCard(
                    icon: Icons.sports,
                    value: '${stats.sportsCount}',
                    label: 'Olahraga',
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  _QuickStatCard(
                    icon: Icons.timer,
                    value: '${stats.hoursPlayed}j',
                    label: 'Jam Bermain',
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xl),

              // Sport quick-access
              Text('Olahraga', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                height: AppDimensions.chipHeight + 8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: Sport.values.map((sport) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: AppDimensions.sm),
                      child: SportChipSelector(
                        sport: sport,
                        isSelected: false,
                        onToggle: (_) {
                          ref
                              .read(venueFilterProvider.notifier)
                              .setSport(sport);
                          context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // Upcoming booking
              Text('Booking Mendatang', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              bookingsAsync.when(
                loading: () => ShimmerLoading.card(),
                error: (_, _) => const SizedBox.shrink(),
                data: (bookings) {
                  final upcoming = bookings
                      .where((b) =>
                          b.status == BookingStatus.pendingPayment ||
                          b.status == BookingStatus.waitingConfirmation ||
                          b.status == BookingStatus.confirmed)
                      .toList();
                  if (upcoming.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(AppDimensions.xl),
                      decoration: BoxDecoration(
                        color: AppSurfaces.surfaceHighlight,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLg),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary300,
                            size: 32,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            'Belum ada booking mendatang',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg),
                      boxShadow: AppShadows.sm,
                    ),
                    child: BookingCard(booking: upcoming.first),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Achievement Badges Preview ────────────────────────
              _SectionHeader(title: 'Pencapaian', actionLabel: 'Lihat Semua'),
              const SizedBox(height: AppDimensions.md),
              badgesAsync.when(
                loading: () => ShimmerLoading.card(),
                error: (_, _) => const SizedBox.shrink(),
                data: (badges) => SizedBox(
                  height: 72,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: badges.length,
                    itemBuilder: (_, i) {
                      final badge = badges[i];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: i < badges.length - 1 ? AppDimensions.md : 0,
                        ),
                        child: _BadgeCircle(
                          iconName: badge.iconName,
                          label: badge.name,
                          isUnlocked: badge.isUnlocked,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Popular Venues ────────────────────────────────────
              _SectionHeader(title: 'Venue Populer'),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sortedVenues.length,
                  itemBuilder: (_, i) {
                    final venue = _sortedVenues[i];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: i < _sortedVenues.length - 1
                            ? AppDimensions.md
                            : 0,
                      ),
                      child: _PopularVenueCard(
                        name: venue.name,
                        city: venue.city,
                        rating: venue.avgRating,
                        photoUrl: venue.photos.isNotEmpty
                            ? venue.photos.first
                            : null,
                        onTap: () => context.push(AppRoutes.venue(venue.id)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── Recent Activity ───────────────────────────────────
              _SectionHeader(title: 'Aktivitas Terkini'),
              const SizedBox(height: AppDimensions.md),
              bookingsAsync.when(
                loading: () => ShimmerLoading.card(),
                error: (_, _) => const SizedBox.shrink(),
                data: (bookings) {
                  final recent = ([...bookings]
                        ..sort((a, b) =>
                            b.createdAt.compareTo(a.createdAt)))
                      .take(3)
                      .toList();
                  if (recent.isEmpty) return const SizedBox.shrink();

                  final statusExt = Theme.of(context)
                      .extension<BookingStatusThemeExtension>()!;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppSurfaces.surface,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg),
                      boxShadow: AppShadows.sm,
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < recent.length; i++) ...[
                          _ActivityRow(
                            venueName: recent[i].venueName ?? 'Venue',
                            date: Formatters.formatDate(
                                recent[i].bookingDate),
                            statusColor:
                                statusExt.color(recent[i].status),
                            onTap: () => context.push(
                                AppRoutes.booking(recent[i].id)),
                          ),
                          if (i < recent.length - 1)
                            const Divider(height: 1, indent: 16, endIndent: 16),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
    );
  }

  static final _sortedVenues = [...MockData.venues]
    ..sort((a, b) => b.avgRating.compareTo(a.avgRating));
}

// ── Private Widgets ─────────────────────────────────────────────────

class _GamificationCard extends StatelessWidget {
  final String tierLabel;
  final Color tierColor;
  final int totalXp;
  final int nextThreshold;
  final double progress;
  final VoidCallback onTap;

  const _GamificationCard({
    required this.tierLabel,
    required this.tierColor,
    required this.totalXp,
    required this.nextThreshold,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surfaceHighlight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: Column(
              children: [
                Row(
                  children: [
                    // Tier badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: tierColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    // Tier label
                    Text(
                      tierLabel,
                      style: AppTypography.titleSmall.copyWith(
                        color: tierColor,
                      ),
                    ),
                    const Spacer(),
                    // XP text
                    Text(
                      '$totalXp/$nextThreshold XP',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                // XP progress bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: tierColor,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _QuickStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.md,
          horizontal: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: AppDimensions.xs),
            Text(value, style: AppTypography.numberSmall),
            Text(
              label,
              style: AppTypography.caption,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const _SectionHeader({required this.title, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.titleMedium),
        if (actionLabel != null)
          Text(
            '$actionLabel \u2192',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}

class _BadgeCircle extends StatelessWidget {
  final String iconName;
  final String label;
  final bool isUnlocked;

  const _BadgeCircle({
    required this.iconName,
    required this.label,
    required this.isUnlocked,
  });

  IconData _mapIcon() => switch (iconName) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isUnlocked ? AppColors.primary50 : AppColors.neutral100,
            shape: BoxShape.circle,
            boxShadow: isUnlocked ? AppShadows.xs : null,
          ),
          child: Opacity(
            opacity: isUnlocked ? 1.0 : 0.5,
            child: Icon(
              _mapIcon(),
              size: 24,
              color: isUnlocked ? AppColors.primary : AppColors.neutral500,
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularVenueCard extends StatelessWidget {
  final String name;
  final String city;
  final double rating;
  final String? photoUrl;
  final VoidCallback onTap;

  const _PopularVenueCard({
    required this.name,
    required this.city,
    required this.rating,
    this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: photoUrl != null
                      ? Image.network(
                          photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _photoPlaceholder(),
                        )
                      : _photoPlaceholder(),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Expanded(
                            child: Text(
                              city,
                              style: AppTypography.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      color: AppColors.neutral100,
      child: Center(
        child: Icon(
          Icons.sports_tennis,
          color: AppColors.neutral500,
          size: 32,
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String venueName;
  final String date;
  final Color statusColor;
  final VoidCallback onTap;

  const _ActivityRow({
    required this.venueName,
    required this.date,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  venueName,
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                date,
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
