import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/club/data/models/admin_student_roster_item.dart';
import 'package:hyperarena/features/club/data/models/club_summary.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

/// One repo for all club / roster / detail traffic. Issue 19.1–19.5.
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

  /// 19.5 — tenant-wide roster (organizer Klub list) with assigned-coach
  /// + outstanding-payment aggregates. Cursor-paginated; 50 max per page.
  Future<CursorPage<AdminStudentRosterItem>> getAdminRoster({
    int? perPage,
    String? cursor,
    String? search,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/admin/students/roster',
        queryParameters: {
          'per_page': ?perPage,
          'cursor': ?cursor,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );
      return CursorPage.fromJson<AdminStudentRosterItem>(
        res.data as Map<String, dynamic>,
        AdminStudentRosterItem.fromJson,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
