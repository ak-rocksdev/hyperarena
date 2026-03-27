import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceSessionRepository {
  final ApiClient _apiClient;

  ApiMarketplaceSessionRepository(this._apiClient);

  Future<CursorPage<MarketplaceSession>> getSessions({
    int? sportId,
    String? search,
    String? dateFrom,
    String? dateTo,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/sessions',
          queryParameters: {
            'sport_id': ?sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            'date_from': ?dateFrom,
            'date_to': ?dateTo,
            'per_page': ?perPage,
            'cursor': ?cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceSession.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
