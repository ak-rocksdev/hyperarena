import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/club/data/models/admin_student_summary.dart';
import 'package:hyperarena/features/club/data/models/club_summary.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

/// One repo for all club / roster / detail traffic. Issue 19.1–19.4 plus
/// the existing `/admin/students` list (until 19.5 ships).
class ApiClubRepository {
  final ApiClient _apiClient;

  ApiClubRepository(this._apiClient);

  /// 19.4 — club identity + vital stats. Drives the organizer Klub hero.
  Future<ClubSummary> getClubSummary() async {
    try {
      final res = await _apiClient.get('/v1/admin/club/summary');
      return ClubSummary.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// 19.1 — coach roster (auth coach's own students with aggregates).
  Future<CursorPage<CoachStudentRosterItem>> getCoachStudents({
    int? perPage,
    String? cursor,
    String? search,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/coach/students',
        queryParameters: {
          'per_page': ?perPage,
          'cursor': ?cursor,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      return CursorPage.fromJson<CoachStudentRosterItem>(
        res.data as Map<String, dynamic>,
        CoachStudentRosterItem.fromJson,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// 19.2 — coach-scope student detail.
  Future<StudentDetail> getCoachStudentDetail(int studentProfileId) async {
    try {
      final res =
          await _apiClient.get('/v1/coach/students/$studentProfileId');
      return StudentDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// 19.3 — admin-scope student detail with financial sections.
  Future<AdminStudentDetail> getAdminStudentDetail(int studentProfileId) async {
    try {
      final res = await _apiClient
          .get('/v1/admin/students/$studentProfileId/detail');
      return AdminStudentDetail.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Existing thin admin students list — used as the organizer Klub roster
  /// fallback until 19.5 ships with the richer aggregate shape.
  Future<List<AdminStudentSummary>> getAdminStudents({
    String? search,
    int? perPage,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/admin/students',
        queryParameters: {
          'per_page': ?perPage,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      final data = res.data as Map<String, dynamic>;
      final list = (data['data'] as List).cast<Map<String, dynamic>>();
      return list.map(AdminStudentSummary.fromJson).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
