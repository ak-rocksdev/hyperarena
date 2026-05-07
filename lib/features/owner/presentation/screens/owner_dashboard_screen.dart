import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(ownerDashboardProvider);
    final venuesAsync = ref.watch(ownerVenuesProvider);
    final issuesAsync = ref.watch(ownerAvailabilityIssuesProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(ownerDashboardProvider);
            ref.invalidate(ownerVenuesProvider);
            ref.invalidate(ownerAvailabilityIssuesProvider);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.screenTop,
            ),
            children: [
              // ── 1. Greeting ──────────────────────────────────────
              _GreetingSection(venuesAsync: venuesAsync),
              const SizedBox(height: AppDimensions.lg),

              // ── 2. Pending confirmations banner ──────────────────
              AsyncValueWidget(
                value: statsAsync,
                loading: () => const SizedBox.shrink(),
                data: (stats) => stats.pendingConfirmations > 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.lg,
                        ),
                        child: _PendingBanner(
                          count: stats.pendingConfirmations,
                          onTap: () =>
                              context.push(AppRoutes.ownerBookingQueue),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // ── 3. Today's overview row ──────────────────────────
              AsyncValueWidget(
                value: statsAsync,
                data: (stats) => _TodayOverviewRow(stats: stats),
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── 4. Venue quick cards ─────────────────────────────
              Text('Venue Saya', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              AsyncValueWidget(
                value: venuesAsync,
                data: (venues) => AsyncValueWidget(
                  value: issuesAsync,
                  loading: () => const SizedBox.shrink(),
                  data: (issues) {
                    final issueVenueIds =
                        issues.map((i) => i.venueId).toSet();
                    return Column(
                      children: venues
                          .map(
                            (venue) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.md,
                              ),
                              child: _VenueQuickCard(
                                name: venue.name,
                                city: venue.city,
                                courtCount: venue.courts.length,
                                hasIssues: issueVenueIds.contains(venue.id),
                                onTap: () => context.push(
                                  AppRoutes.ownerVenueDetail(venue.id),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),

              // ── 5. Court issues section ──────────────────────────
              AsyncValueWidget(
                value: issuesAsync,
                loading: () => const SizedBox.shrink(),
                data: (issues) => issues.isEmpty
                    ? const SizedBox.shrink()
                    : _CourtIssuesSection(issues: issues),
              ),
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.venuesAsync});

  final AsyncValue venuesAsync;

  @override
  Widget build(BuildContext context) {
    final venueCount = venuesAsync.whenOrNull<int>(
      data: (venues) => (venues as List).length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Halo, Hendra', style: AppTypography.headingLarge),
        const SizedBox(height: AppDimensions.xs),
        Text(
          venueCount != null ? '$venueCount venue aktif' : 'Memuat...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Pending Banner ────────────────────────────────────────────────────────────

class _PendingBanner extends StatelessWidget {
  const _PendingBanner({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.payment_outlined,
            color: AppColors.warning,
            size: AppDimensions.iconMd,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              '$count pembayaran menunggu konfirmasi',
              style: AppTypography.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              'Lihat',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Today's Overview Row ──────────────────────────────────────────────────────

class _TodayOverviewRow extends ConsumerWidget {
  const _TodayOverviewRow({required this.stats});

  final dynamic stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    return Row(
      children: [
        Expanded(
          child: _OverviewStatCard(
            icon: Icons.calendar_today_outlined,
            value: '${stats.bookingsToday}',
            label: 'Booking Hari Ini',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _OverviewStatCard(
            icon: Icons.pie_chart_outline,
            value: '${(stats.occupancyRate * 100).toStringAsFixed(0)}%',
            label: 'Okupansi',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _OverviewStatCard(
            icon: Icons.account_balance_wallet_outlined,
            value: Formatters.formatCurrency(
                stats.todayRevenue as int, currency),
            label: 'Pendapatan Hari Ini',
          ),
        ),
      ],
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  const _OverviewStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconSm, color: AppColors.neutral400),
          const SizedBox(height: AppDimensions.sm),
          Text(
            value,
            style: AppTypography.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

// ── Venue Quick Card ──────────────────────────────────────────────────────────

class _VenueQuickCard extends StatelessWidget {
  const _VenueQuickCard({
    required this.name,
    required this.city,
    required this.courtCount,
    required this.hasIssues,
    required this.onTap,
  });

  final String name;
  final String city;
  final int courtCount;
  final bool hasIssues;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: AppTypography.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        city,
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      '$courtCount lapangan',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            // Status dot
            Container(
              width: AppDimensions.badgeDot,
              height: AppDimensions.badgeDot,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasIssues ? AppColors.warning : AppColors.success,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            const Icon(
              Icons.chevron_right,
              color: AppColors.neutral400,
              size: AppDimensions.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Court Issues Section ──────────────────────────────────────────────────────

class _CourtIssuesSection extends StatelessWidget {
  const _CourtIssuesSection({required this.issues});

  final List issues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.lg),
        Text('Masalah Ketersediaan', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Column(
            children: issues
                .map<Widget>(
                  (issue) => Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          issue == issues.last ? 0 : AppDimensions.md,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                issue.courtName as String,
                                style: AppTypography.titleSmall,
                              ),
                              const SizedBox(height: AppDimensions.xxs),
                              Text(
                                issue.reason as String,
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Pengaturan ${issue.courtName} akan tersedia segera',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Atur',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
