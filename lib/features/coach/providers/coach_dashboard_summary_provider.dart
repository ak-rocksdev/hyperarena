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

  final results = await Future.wait([
    _safe<CoachPerformance>(() => repo.getPerformance(coachId: coachId)),
    _safe<CoachActionCounts>(() => repo.getActionCounts(coachId: coachId)),
    _safe<List<CoachStudentRosterItem>>(
        () => repo.getAttentionList(coachId: coachId)),
    _safe<Map<Sport, int>>(() => repo.getSportBreakdown(coachId: coachId)),
  ]);

  final schedule = await ref.watch(coachScheduleProvider.future);
  final now = DateTime.now();
  final tomorrow = now.add(const Duration(days: 1));
  final sessionsTomorrow = schedule
      .where((b) =>
          b.date.year == tomorrow.year &&
          b.date.month == tomorrow.month &&
          b.date.day == tomorrow.day)
      .length;

  return CoachDashboardSummary(
    performance: results[0] as SectionResult<CoachPerformance>,
    actions: results[1] as SectionResult<CoachActionCounts>,
    attentionList: results[2] as SectionResult<List<CoachStudentRosterItem>>,
    sportBreakdown: results[3] as SectionResult<Map<Sport, int>>,
    sessionsTomorrow: sessionsTomorrow,
  );
});
