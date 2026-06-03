import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/api_club_repository.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

/// Backs the dashboard's aggregate summary. Each method maps to one
/// SectionResult slot in CoachDashboardSummary. When a BE summary endpoint
/// does not yet exist, the implementation derives the value from existing
/// list endpoints.
///
/// The `coachId` parameter on each public method is accepted for API
/// symmetry but is currently unused — the underlying `ApiCoachSessionRepository`
/// and `ApiClubRepository` calls identify the coach from the bearer token.
/// The parameter will become load-bearing when impersonation or multi-tenant
/// coach filtering ships.
class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._apiClient, this._sessions, this._students);
  // ignore: unused_field
  final ApiClient _apiClient;
  final ApiCoachSessionRepository _sessions;
  final ApiClubRepository _students;

  // Memoize the sessions page so getPerformance + getActionCounts +
  // getSportBreakdown share one HTTP call per dashboard load. The
  // provider that creates this repo is autoDispose, so the cache
  // naturally invalidates on pull-to-refresh / role switch / logout.
  Future<PageResult<CoachSession>>? _sessionsPage;
  Future<PageResult<CoachSession>> _getSessionsOnce() =>
      _sessionsPage ??= _sessions.getSessions();

  // Memoize the roster page so getActionCounts + getAttentionList share one
  // HTTP call per dashboard load. Mirrors the _getSessionsOnce pattern.
  Future<CursorPage<CoachStudentRosterItem>>? _studentsPage;
  Future<CursorPage<CoachStudentRosterItem>> _getStudentsOnce() =>
      _studentsPage ??= _students.getCoachStudents();

  /// Derives performance metrics client-side from the first page of
  /// `ApiCoachSessionRepository.getSessions()`.
  ///
  /// **Earnings:** `CoachSession` does not expose a per-session payout field,
  /// so `earningsThisWeekCents` and `earningsThisMonthCents` always return 0.
  /// Accurate earnings require either a dedicated BE summary endpoint or a
  /// `coach_payout_cents` field added to the session list response.
  ///
  /// **Active students:** `activeStudentCount` is an approximation — it sums
  /// `bookedStudentsCount` across completed sessions in the last 30 days.
  /// True unique-student count requires per-session detail fetches (expensive)
  /// or a dedicated BE summary field.
  ///
  /// **Scope:** Only the first page of sessions is considered. A BE summary
  /// endpoint should replace this client-side aggregation once available.
  Future<CoachPerformance> getPerformance({required String coachId}) async {
    final page = await _getSessionsOnce();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Week starts on Monday (weekday == 1).
    final weekStart = today.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final last30 = today.subtract(const Duration(days: 30));

    int sessionsWeek = 0;
    int sessionsMonth = 0;
    // Earnings stay 0 — no payout field on CoachSession (see doc comment above).
    const int earningsWeekCents = 0;
    const int earningsMonthCents = 0;
    int activeStudents30dayApprox = 0;

    for (final s in page.items) {
      // 'complete' is the only completionState that means the session is both
      // past AND fully graded. Values: not_yet | needs_attendance |
      // needs_grading | complete (from CoachSession model doc comment).
      final isCompleted = s.completionState == 'complete';
      if (!isCompleted) continue;

      final startTime = s.startAt;

      if (!startTime.isBefore(weekStart)) {
        sessionsWeek += 1;
      }
      if (!startTime.isBefore(monthStart)) {
        sessionsMonth += 1;
      }
      if (!startTime.isBefore(last30)) {
        // Sum bookedStudentsCount as a proxy for unique active students — see
        // doc comment above for limitations.
        activeStudents30dayApprox += s.bookedStudentsCount;
      }
    }

    return CoachPerformance(
      earningsThisWeekCents: earningsWeekCents,
      earningsThisMonthCents: earningsMonthCents,
      sessionsThisWeek: sessionsWeek,
      sessionsThisMonth: sessionsMonth,
      activeStudentCount: activeStudents30dayApprox,
    );
  }

  Future<CoachActionCounts> getActionCounts({required String coachId}) async {
    // Pull the first page of the coach's recent sessions. For session-level
    // counts we accept first-page approximation — backlog beyond page 1 is
    // rare in practice and a BE summary endpoint will replace this
    // client-side aggregation once available.
    final page = await _getSessionsOnce();

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

    // STUDENTS UNGRADED: count of unique students with no recorded progress,
    // derived from the same roster source as getAttentionList. This ensures
    // the count matches the destination list ("26 murid belum dinilai" means
    // exactly 26 unique students, not 26 student-session instances).
    final roster = await _getStudentsOnce();
    final studentsUngraded =
        roster.items.where((s) => s.latestProgress == null).length;

    return CoachActionCounts(
      absencesUnmarked: absences,
      assessmentsUngraded: ungraded,
      studentsUngraded: studentsUngraded,
    );
  }

  Future<List<CoachStudentRosterItem>> getAttentionList({required String coachId}) async {
    final page = await _getStudentsOnce();
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
