import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

/// Backs the dashboard's aggregate summary. Each method maps to one
/// SectionResult slot in CoachDashboardSummary. When a BE summary endpoint
/// does not yet exist, the implementation derives the value from existing
/// list endpoints.
class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._apiClient, this._sessions);
  // ignore: unused_field
  final ApiClient _apiClient;
  final ApiCoachSessionRepository _sessions;

  Future<CoachPerformance> getPerformance({required String coachId}) async {
    throw UnimplementedError('Phase 8: getPerformance');
  }

  Future<CoachActionCounts> getActionCounts({required String coachId}) async {
    // Pull the first page of the coach's recent sessions. For counts we
    // accept first-page approximation — backlog beyond page 1 is rare in
    // practice and the BE summary endpoint (out-of-scope follow-up) will
    // replace this client-side aggregation with an authoritative count.
    final page = await _sessions.getSessions();

    // ATTENDANCE UNMARKED: completionState == 'needs_attendance' means the
    // session's start time has passed but attendance has not been recorded.
    final absences = page.items
        .where((s) => s.completionState == 'needs_attendance')
        .length;

    // ASSESSMENT UNGRADED: completionState == 'needs_grading' means the
    // session is complete but no session-progress/assessment was recorded.
    final ungraded = page.items
        .where((s) => s.completionState == 'needs_grading')
        .length;

    // STUDENTS UNGRADED: sum of booked student counts across ungraded
    // sessions. The list endpoint does not include individual student IDs
    // (those are detail-only); bookedStudentsCount is the best available
    // proxy from a single-page fetch.
    final studentsUngraded = page.items
        .where((s) => s.completionState == 'needs_grading')
        .fold(0, (sum, s) => sum + s.bookedStudentsCount);

    return CoachActionCounts(
      absencesUnmarked: absences,
      assessmentsUngraded: ungraded,
      studentsUngraded: studentsUngraded,
    );
  }

  Future<List<CoachStudentRosterItem>> getAttentionList({required String coachId}) async {
    throw UnimplementedError('Phase 6: getAttentionList');
  }

  Future<Map<Sport, int>> getSportBreakdown({required String coachId}) async {
    throw UnimplementedError('Phase 7: getSportBreakdown');
  }
}
