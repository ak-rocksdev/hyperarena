import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_dashboard_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_dashboard_summary_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements ApiCoachDashboardRepository {}

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  test('aggregates all four sections on happy path', () async {
    when(() => repo.getPerformance(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachPerformance(
              earningsThisWeekCents: 0,
              earningsThisMonthCents: 100,
              sessionsThisWeek: 1,
              sessionsThisMonth: 4,
              activeStudentCount: 5,
            ));
    when(() => repo.getActionCounts(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachActionCounts(
              absencesUnmarked: 0,
              assessmentsUngraded: 0,
              studentsUngraded: 0,
            ));
    when(() => repo.getAttentionList(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <CoachStudentRosterItem>[]);
    when(() => repo.getSportBreakdown(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <Sport, int>{});

    final container = ProviderContainer(overrides: [
      apiCoachDashboardRepositoryProvider.overrideWithValue(repo),
      coachScheduleProvider.overrideWith((ref) => Future.value(<CoachingBooking>[])),
    ]);
    addTearDown(container.dispose);

    final summary = await container.read(coachDashboardSummaryProvider.future);
    expect(summary.performance.isSuccess, true);
    expect(summary.actions.isSuccess, true);
    expect(summary.attentionList.isSuccess, true);
    expect(summary.sportBreakdown.isSuccess, true);
  });

  test('one failing fetch does not poison the others', () async {
    when(() => repo.getPerformance(coachId: any(named: 'coachId')))
        .thenThrow(Exception('boom'));
    when(() => repo.getActionCounts(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => const CoachActionCounts(
              absencesUnmarked: 1,
              assessmentsUngraded: 2,
              studentsUngraded: 3,
            ));
    when(() => repo.getAttentionList(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <CoachStudentRosterItem>[]);
    when(() => repo.getSportBreakdown(coachId: any(named: 'coachId')))
        .thenAnswer((_) async => <Sport, int>{});

    final container = ProviderContainer(overrides: [
      apiCoachDashboardRepositoryProvider.overrideWithValue(repo),
      coachScheduleProvider.overrideWith((ref) => Future.value(<CoachingBooking>[])),
    ]);
    addTearDown(container.dispose);

    final summary = await container.read(coachDashboardSummaryProvider.future);
    expect(summary.performance.isFailure, true);
    expect(summary.actions.valueOrNull?.absencesUnmarked, 1);
  });
}
