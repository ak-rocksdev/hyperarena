import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/api_club_repository.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

/// Backs the dashboard's aggregate summary. Each method maps to one
/// SectionResult slot in CoachDashboardSummary. When a BE summary endpoint
/// does not yet exist, the implementation derives the value from existing
/// list endpoints.
class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._apiClient, this._sessions, this._students);
  // ignore: unused_field
  final ApiClient _apiClient;
  final ApiCoachSessionRepository _sessions;
  final ApiClubRepository _students;

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
    final page = await _students.getCoachStudents();
    return page.items.where((s) => s.latestProgress == null).take(5).toList();
  }

  /// Returns sessions-per-sport in the last 90 days as a best-effort
  /// approximation. The coach-sessions list endpoint does not include a
  /// `sport` field per session, so a true sport breakdown requires a dedicated
  /// BE summary endpoint (planned follow-up). Until then this method returns
  /// an empty map, which causes the widget to hide itself gracefully rather
  /// than throw.
  ///
  /// Replace this implementation with the authoritative BE call once
  /// `GET /v1/coach/dashboard/sport-breakdown` (or equivalent) ships.
  Future<Map<Sport, int>> getSportBreakdown({required String coachId}) async {
    // The coach-sessions list endpoint (`GET /v1/coach/sessions`) does not
    // include a per-session sport field; CoachSession only carries `type`
    // (a nullable string unrelated to the Sport enum). Without sport-keyed
    // data a client-side tally is not possible from a single fetch.
    // Returning an empty map keeps the dashboard intact and hides the
    // SportBreakdown section until the BE endpoint is available.
    return const <Sport, int>{};
  }
}
