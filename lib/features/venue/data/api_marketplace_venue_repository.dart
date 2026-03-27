import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceVenueRepository {
  final ApiClient _apiClient;

  ApiMarketplaceVenueRepository(this._apiClient);

  Future<CursorPage<MarketplaceVenue>> getVenues({
    int? sportId,
    String? search,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/venues',
          queryParameters: {
            'sport_id': ?sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            'per_page': ?perPage,
            'cursor': ?cursor,
          });
      return CursorPage.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MarketplaceVenue.fromJson(json),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<MarketplaceVenue> getVenueDetail(int id) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/venues/$id');
      final data = response.data as Map<String, dynamic>;
      return MarketplaceVenue.fromJson(
        data.containsKey('data')
            ? data['data'] as Map<String, dynamic>
            : data,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
