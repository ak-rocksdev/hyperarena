import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/action_queue_widget.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/earnings_snapshot_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/kpi_strip_widget.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/organizer_session_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/session_filter_bar.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(organizerDashboardProvider);
    final inboxAsync = ref.watch(organizerActionInboxProvider);
    final agendaAsync = ref.watch(organizerAgendaProvider);
    final earningsAsync = ref.watch(organizerEarningsProvider);
    final dateRange = ref.watch(dashboardDateRangeProvider);
    final filter = ref.watch(dashboardFilterProvider);

    Future<void> refreshAll() async {
      ref.invalidate(organizerDashboardProvider);
      ref.invalidate(organizerActionInboxProvider);
      ref.invalidate(organizerAgendaProvider);
      ref.invalidate(organizerEarningsProvider);
      await Future.wait([
        ref.read(organizerDashboardProvider.future),
        ref.read(organizerActionInboxProvider.future),
        ref.read(organizerAgendaProvider.future),
        ref.read(organizerEarningsProvider.future),
      ]);
    }

    return Scaffold(
      // ── 7. FAB — "Buat Sesi" ───────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'dashboardCreateSession',
        onPressed: () => context.push(AppRoutes.organizerCreateSession),
        icon: const Icon(Icons.add),
        label: const Text('Buat Sesi'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Greeting ──────────────────────────────────
                Text(
                  '${_greeting()}, Sari!',
                  style: AppTypography.headingLarge,
                ),
                const SizedBox(height: AppDimensions.base),

                // ── 2. KPI Strip ─────────────────────────────────
                AsyncValueWidget(
                  value: statsAsync,
                  data: (stats) => KpiStripWidget(stats: stats),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 3. Action Queue ──────────────────────────────
                AsyncValueWidget(
                  value: inboxAsync,
                  data: (items) => ActionQueueWidget(items: items),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 4. Date toggle + filter chips ────────────────
                const SessionFilterBar(),
                const SizedBox(height: AppDimensions.base),

                // ── 5. Session list (filtered) ───────────────────
                Row(
                  children: [
                    Text(
                      'Sesi Mendatang',
                      style: AppTypography.titleMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          context.go(AppRoutes.organizerSessions),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                AsyncValueWidget(
                  value: agendaAsync,
                  data: (sessions) {
                    final filtered = _applyFilters(
                      sessions,
                      dateRange,
                      filter,
                    );
                    if (filtered.isEmpty) {
                      return const EmptyState(
                        message: 'Tidak ada sesi yang cocok',
                        icon: Icons.event_available_outlined,
                      );
                    }
                    return Column(
                      children: [
                        for (var i = 0; i < filtered.length; i++) ...[
                          OrganizerSessionCard(session: filtered[i]),
                          if (i < filtered.length - 1)
                            const SizedBox(height: AppDimensions.sm),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 6. Earnings card ─────────────────────────────
                AsyncValueWidget(
                  value: earningsAsync,
                  data: (earnings) =>
                      EarningsSnapshotCard(earnings: earnings),
                ),
                // Extra bottom padding for FAB clearance
                const SizedBox(height: AppDimensions.massive + AppDimensions.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Client-side filtering based on date range and status filter.
  List<OpenSession> _applyFilters(
    List<OpenSession> sessions,
    DashboardDateRange dateRange,
    DashboardFilter filter,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Date filter
    var filtered = sessions.where((s) {
      final sessionDay = DateTime(s.date.year, s.date.month, s.date.day);
      return switch (dateRange) {
        DashboardDateRange.today => sessionDay == today,
        DashboardDateRange.tomorrow =>
          sessionDay == today.add(const Duration(days: 1)),
        DashboardDateRange.thisWeek =>
          !sessionDay.isBefore(today) &&
              sessionDay.isBefore(today.add(const Duration(days: 7))),
      };
    }).toList();

    // Status filter
    if (filter != DashboardFilter.none) {
      filtered = filtered.where((s) {
        return switch (filter) {
          DashboardFilter.none => true,
          DashboardFilter.pendingPayment => s.health.pendingPayments > 0,
          DashboardFilter.lowQuota => s.health.isLowSignupRisk,
          DashboardFilter.dispute => false, // would need dispute field on session
          DashboardFilter.confirmed =>
            s.status == OpenSessionStatus.confirmed,
        };
      }).toList();
    }

    return filtered;
  }
}
