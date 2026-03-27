import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceCoachRepository {
  final ApiClient _apiClient;

  ApiMarketplaceCoachRepository(this._apiClient);

  Future<CursorPage<MarketplaceCoach>> getCoaches({
    int? sportId,
    String? search,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/coaches',
          queryParameters: {
            'sport_id': ?sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            'per_page': ?perPage,
            'cursor': ?cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceCoach.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
