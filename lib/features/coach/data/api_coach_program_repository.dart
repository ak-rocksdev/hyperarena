import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/program.dart';

class ApiCoachProgramRepository {
  final ApiClient _apiClient;

  ApiCoachProgramRepository(this._apiClient);

  Future<List<Program>> getPrograms() async {
    try {
      final res = await _apiClient.get('/v1/coach/programs');
      final list =
          (res.data['data'] as List?)?.cast<Map<String, dynamic>>() ??
              (res.data['programs'] as List?)?.cast<Map<String, dynamic>>() ??
              const [];
      return list.map(Program.fromJson).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<List<ProgramLevel>> getLevels(int programId) async {
    try {
      final res = await _apiClient.get('/v1/coach/programs/$programId/levels');
      final list =
          (res.data['data'] as List?)?.cast<Map<String, dynamic>>() ??
              (res.data['levels'] as List?)?.cast<Map<String, dynamic>>() ??
              const [];
      return list.map(ProgramLevel.fromJson).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
