import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/features/coach/data/models/session_progress_detail.dart';
import 'package:hyperarena/features/coach/data/models/session_recommendation.dart';

/// Page-based paginated response from Laravel's `paginate()`.
class PageResult<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const PageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;
}

class ApiCoachSessionRepository {
  final ApiClient _apiClient;

  ApiCoachSessionRepository(this._apiClient);

  /// Fetch paginated coach sessions.
  Future<PageResult<CoachSession>> getSessions({
    int page = 1,
    int perPage = 15,
    String? status,
    String? from,
    String? to,
  }) async {
    try {
      final response = await _apiClient.get(
        '/v1/coach/sessions',
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'status': ?status,
          'from': ?from,
          'to': ?to,
        },
      );
      final json = response.data as Map<String, dynamic>;
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return PageResult(
        items: data.map(CoachSession.fromJson).toList(),
        currentPage: json['current_page'] as int? ?? 1,
        lastPage: json['last_page'] as int? ?? 1,
        total: json['total'] as int? ?? 0,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Fetch a single session with students and attendance.
  Future<CoachSession> getSessionDetail(int id) async {
    try {
      final response = await _apiClient.get('/v1/coach/sessions/$id');
      final json = response.data as Map<String, dynamic>;
      return CoachSession.fromJson(json['session'] as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Bulk-save attendance for a session.
  Future<void> bulkSaveAttendance(
    int sessionId,
    List<Map<String, dynamic>> attendances,
  ) async {
    try {
      await _apiClient.post(
        '/v1/coach/sessions/$sessionId/attendance/bulk',
        data: {'attendances': attendances},
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Existing progress for a session (session_progress + skill_progress
  /// rows for every student). Empty arrays when no one has been graded yet.
  Future<SessionProgressDetail> getSessionProgress(int sessionId) async {
    try {
      final res =
          await _apiClient.get('/v1/coach/sessions/$sessionId/progress');
      return SessionProgressDetail.fromJson(
          res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// "Fokus yang Disarankan" panel data. Non-critical; callers should treat
  /// errors as silent (the recommendations card just won't render).
  ///
  /// Backend may return either a bare list or `{recommendations: [...]}`; we
  /// accept both shapes so the FE doesn't break when the envelope changes.
  Future<List<SessionRecommendation>> getRecommendations(int sessionId) async {
    try {
      final res = await _apiClient
          .get('/v1/coach/sessions/$sessionId/recommendations');
      final raw = res.data;
      final List rawList;
      if (raw is List) {
        rawList = raw;
      } else if (raw is Map<String, dynamic> && raw['recommendations'] is List) {
        rawList = raw['recommendations'] as List;
      } else {
        rawList = const [];
      }
      return rawList
          .cast<Map<String, dynamic>>()
          .map(SessionRecommendation.fromJson)
          .toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// One-tap reuse of the previous session's grade for the same student.
  /// Returns `null` when there's no previous grade to copy.
  Future<SessionProgressDetail?> copyFromLast({
    required int sessionId,
    required int studentProfileId,
  }) async {
    try {
      final res = await _apiClient.post(
        '/v1/coach/sessions/$sessionId/progress/copy-from-last',
        data: {'student_profile_id': studentProfileId},
      );
      final data = res.data as Map<String, dynamic>?;
      if (data == null || data['session_progress'] == null) return null;
      // Endpoint returns single objects; wrap into the list-shaped detail
      // model so consumers share one rendering path.
      return SessionProgressDetail(
        sessionProgress: [
          SessionProgressEntry.fromJson(
              data['session_progress'] as Map<String, dynamic>),
        ],
        skillProgress:
            ((data['skill_progress'] as List?)?.cast<Map<String, dynamic>>() ??
                    const [])
                .map(SkillProgressEntry.fromJson)
                .toList(),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Save grading for one student. Caller picks one or both score modes:
  /// - [score] (0-10) for numeric tenants — status derived server-side.
  /// - [status] for status tenants (`needs_work | progressing | good | excellent`).
  /// - [skillProgress] is optional; skipped entirely when null/empty.
  ///
  /// Each [skillProgress] entry must include `level_skill_id` plus either
  /// `status` (status mode) or `score` (numeric mode); both are accepted so
  /// the same payload passes either tenant config.
  Future<void> saveSessionProgress({
    required int sessionId,
    required int studentProfileId,
    int? score,
    String? status,
    String? notes,
    List<Map<String, dynamic>>? skillProgress,
  }) async {
    try {
      await _apiClient.post(
        '/v1/coach/sessions/$sessionId/progress',
        data: {
          'student_profile_id': studentProfileId,
          'score': ?score,
          'status': ?status,
          'notes': ?notes,
          if (skillProgress != null && skillProgress.isNotEmpty)
            'skill_progress': skillProgress,
        },
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
