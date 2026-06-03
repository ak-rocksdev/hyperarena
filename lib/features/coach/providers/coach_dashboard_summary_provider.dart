import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/club/providers/club_providers.dart';
import 'package:hyperarena/features/coach/data/api_coach_dashboard_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_dashboard_summary.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final apiCoachDashboardRepositoryProvider =
    Provider<ApiCoachDashboardRepository>((ref) => ApiCoachDashboardRepository(
          ref.watch(apiClientProvider),
          ref.watch(coachSessionRepoProvider),
          ref.watch(clubRepositoryProvider),
        ));

Future<SectionResult<T>> _safe<T>(Future<T> Function() f) async {
  try {
    return SectionResult.success(await f());
  } catch (e, st) {
    return SectionResult.failure(e, st);
  }
}

final coachDashboardSummaryProvider =
    FutureProvider.autoDispose<CoachDashboardSummary>((ref) async {
  ref.keepAlive();
  final repo = ref.watch(apiCoachDashboardRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);

  final perfFuture =
      _safe<CoachPerformance>(() => repo.getPerformance(coachId: coachId));
  final actionsFuture =
      _safe<CoachActionCounts>(() => repo.getActionCounts(coachId: coachId));
  final attentionFuture = _safe<List<CoachStudentRosterItem>>(
      () => repo.getAttentionList(coachId: coachId));
  final sportFuture =
      _safe<Map<Sport, int>>(() => repo.getSportBreakdown(coachId: coachId));

  final perf = await perfFuture;
  final actions = await actionsFuture;
  final attention = await attentionFuture;
  final sport = await sportFuture;

  int sessionsTomorrow = 0;
  try {
    final schedule = await ref.watch(coachScheduleProvider.future);
    final now = DateTime.now();
    final tomorrowDay = DateTime(now.year, now.month, now.day + 1);
    sessionsTomorrow = schedule.where((b) {
      final d = b.date;
      return d.year == tomorrowDay.year &&
          d.month == tomorrowDay.month &&
          d.day == tomorrowDay.day;
    }).length;
  } catch (_) {
    // Leave sessionsTomorrow at 0 — schedule failure must not collapse
    // the rest of the summary. The Today Schedule widget reads
    // coachScheduleProvider directly and renders its own error state.
  }

  return CoachDashboardSummary(
    performance: perf,
    actions: actions,
    attentionList: attention,
    sportBreakdown: sport,
    sessionsTomorrow: sessionsTomorrow,
  );
});
