import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/enrollment.dart';
import 'package:hyperarena/features/coach/data/models/level_skill.dart';

class ApiCoachEnrollmentRepository {
  final ApiClient _apiClient;

  ApiCoachEnrollmentRepository(this._apiClient);

  /// Fetch the active enrollment for a student. Returns `null` if the student
  /// is not enrolled in any program.
  Future<Enrollment?> getActiveForStudent(int studentProfileId) async {
    try {
      final res = await _apiClient.get('/v1/coach/enrollments',
          queryParameters: {
            'student_profile_id': studentProfileId,
            'status': 'active',
          });
      final list = (res.data['data'] as List?) ?? const [];
      if (list.isEmpty) return null;
      return Enrollment.fromJson(list.first as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Standard skills for a level (no per-student override filter).
  Future<List<LevelSkill>> getLevelSkills(int levelId) async {
    try {
      final res =
          await _apiClient.get('/v1/coach/levels/$levelId/skills');
      final list =
          (res.data['level_skills'] as List?)?.cast<Map<String, dynamic>>() ??
              const [];
      return list.map(LevelSkill.fromJson).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Per-student skill overrides for a level. The endpoint is on a different
  /// route group (`coach/students/{id}/skill-overrides`); each item gets
  /// `isOverride: true` so the UI can label the row distinctly.
  Future<List<LevelSkill>> getStudentOverrides({
    required int studentProfileId,
    required int levelId,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/coach/students/$studentProfileId/skill-overrides',
        queryParameters: {'level_id': levelId},
      );
      final list = (res.data['overrides'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const [];
      return list
          .map(LevelSkill.fromJson)
          .map((s) => s.copyWith(isOverride: true))
          .toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<Enrollment> enroll({
    required int studentProfileId,
    required int programId,
    int? currentLevelId,
  }) async {
    try {
      final res = await _apiClient.post('/v1/coach/enrollments', data: {
        'student_profile_id': studentProfileId,
        'program_id': programId,
        'current_level_id': ?currentLevelId,
      });
      return Enrollment.fromJson(
          res.data['enrollment'] as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<Enrollment> updateEnrollment({
    required int enrollmentId,
    int? programId,
    int? currentLevelId,
  }) async {
    try {
      final res =
          await _apiClient.put('/v1/coach/enrollments/$enrollmentId', data: {
        'program_id': ?programId,
        'current_level_id': ?currentLevelId,
      });
      return Enrollment.fromJson(
          res.data['enrollment'] as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<void> withdraw(int enrollmentId) async {
    try {
      await _apiClient.put('/v1/coach/enrollments/$enrollmentId/withdraw');
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
