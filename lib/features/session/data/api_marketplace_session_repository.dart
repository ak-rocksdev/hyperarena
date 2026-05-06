import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session_detail.dart';
import 'package:hyperarena/features/session/data/models/session_join_response.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceSessionRepository {
  final ApiClient _apiClient;

  ApiMarketplaceSessionRepository(this._apiClient);

  Future<MarketplaceSessionDetail> getSessionDetail(int id) async {
    try {
      final response = await _apiClient.get('/v1/marketplace/sessions/$id');
      return MarketplaceSessionDetail.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<SessionJoinResponse> joinSession(int sessionId) async {
    try {
      final response =
          await _apiClient.post('/v1/marketplace/sessions/$sessionId/join');
      return SessionJoinResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<void> uploadPaymentProof(int purchaseId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'proof': await MultipartFile.fromFile(filePath),
      });
      await _apiClient.post('/v1/marketplace/purchases/$purchaseId/proof',
          data: formData);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  Future<CursorPage<MarketplaceSession>> getSessions({
    int? sportId,
    String? search,
    String? dateFrom,
    String? dateTo,
    int? perPage,
    String? cursor,
    String? prioritizeTenantSlug,
  }) async {
    try {
      // BE constraint (Issue 17): prioritize_tenant_slug mutually exclusive
      // with cursor. Only send the slug on the first page.
      final response = await _apiClient.get('/v1/marketplace/sessions',
          queryParameters: {
            'sport_id': ?sportId,
            if (search != null && search.isNotEmpty) 'search': search,
            'date_from': ?dateFrom,
            'date_to': ?dateTo,
            'per_page': ?perPage,
            'cursor': ?cursor,
            if (cursor == null)
              'prioritize_tenant_slug': ?prioritizeTenantSlug,
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
