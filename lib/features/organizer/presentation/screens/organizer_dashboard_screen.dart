import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/dashboard_action_list.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/day_timeline.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/organizer_hero_band.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/today_activity_strip.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Organizer dashboard v2 — redesigned per
/// `docs/PRD-organizer-ui-improvement.md` (Direction B "Brand teal").
///
/// Composition (top → bottom):
///   1. [OrganizerHeroBand] — teal gradient band with header, monthly
///      revenue hero, and Belum/Siap-cair glass tiles.
///   2. [TodayActivityStrip] — "Hari ini" 3 mini KPIs.
///   3. [DayTimeline] — "Jadwal" vertical timeline of today's sessions.
///   4. [DashboardActionList] — "Perlu tindakan" top-3 flat rows.
///   5. FAB "Buat Sesi" — brand teal pill bottom-right.
class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(organizerDashboardProvider);
    final inboxAsync = ref.watch(organizerActionInboxProvider);
    final agendaAsync = ref.watch(organizerAgendaProvider);
    final earningsAsync = ref.watch(organizerEarningsProvider);
    final clubAsync = ref.watch(clubProfileProvider);

    final stats = statsAsync.valueOrNull;
    final earnings = earningsAsync.valueOrNull;
    final club = clubAsync.valueOrNull;
    final agenda = agendaAsync.valueOrNull ?? const <OpenSession>[];
    final inbox = inboxAsync.valueOrNull ?? [];

    Future<void> refreshAll() async {
      ref.invalidate(organizerDashboardProvider);
      ref.invalidate(organizerActionInboxProvider);
      ref.invalidate(organizerAgendaProvider);
      ref.invalidate(organizerEarningsProvider);
      ref.invalidate(clubProfileProvider);
      await Future.wait([
        ref.read(organizerDashboardProvider.future),
        ref.read(organizerActionInboxProvider.future),
        ref.read(organizerAgendaProvider.future),
        ref.read(organizerEarningsProvider.future),
      ]);
    }

    final today = DateTime.now();
    final todaySessions = agenda.where((s) {
      return s.date.year == today.year &&
          s.date.month == today.month &&
          s.date.day == today.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Hero band is teal — force light status-bar icons so signal/wifi/
      // battery stay legible against the dark teal gradient.
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // iOS — flips text white
      ),
      child: Scaffold(
        // Edge-to-edge: hero band extends behind the status bar; the FAB
        // floats over the scrolling content.
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'dashboardCreateSession',
          onPressed: () => context.push(AppRoutes.organizerCreateSession),
          icon: const Icon(Icons.add),
          label: const Text('Buat Sesi'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const StadiumBorder(),
        ),
        body: RefreshIndicator(
          onRefresh: refreshAll,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OrganizerHeroBand(
                  stats: stats,
                  earnings: earnings,
                  club: club,
                ),
                TodayActivityStrip(stats: stats),
                DayTimeline(
                  sessions: todaySessions,
                  hoursOnCourt: stats?.hoursOnCourtToday,
                ),
                DashboardActionList(items: inbox),
                // FAB clearance — keeps the last action row from sliding
                // under the floating "Buat Sesi" pill.
                const SizedBox(
                  height: AppDimensions.massive + AppDimensions.xl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
