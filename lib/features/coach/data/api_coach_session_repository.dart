import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';

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

  /// Save session-level progress (assessment) for a single student.
  ///
  /// Caller picks one mode:
  /// - Pass [score] (0-10) for numeric tenants. Status derived server-side.
  /// - Pass [status] for status tenants (`needs_work | progressing | good | excellent`).
  ///
  /// Both can be sent together; the request will pass either validation rule.
  /// Per-skill `skill_progress` is intentionally omitted — that requires
  /// fetching the curriculum (`GET /v1/coach/levels/{levelId}/skills`) which
  /// the FE doesn't yet wire up.
  Future<void> saveSessionProgress({
    required int sessionId,
    required int studentProfileId,
    int? score,
    String? status,
    String? notes,
  }) async {
    try {
      await _apiClient.post(
        '/v1/coach/sessions/$sessionId/progress',
        data: {
          'student_profile_id': studentProfileId,
          'score': ?score,
          'status': ?status,
          'notes': ?notes,
        },
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
