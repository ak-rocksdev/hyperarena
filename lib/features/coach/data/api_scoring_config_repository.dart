import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/scoring_config.dart';

class ApiScoringConfigRepository {
  final ApiClient _apiClient;

  ApiScoringConfigRepository(this._apiClient);

  Future<ScoringConfig> getConfig() async {
    try {
      final res = await _apiClient.get('/v1/coach/settings/scoring');
      final data = res.data as Map<String, dynamic>;
      final config = data['scoring_config'] as Map<String, dynamic>;
      return ScoringConfig.fromJson(config);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
