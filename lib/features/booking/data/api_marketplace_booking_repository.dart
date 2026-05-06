import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/booking/data/models/marketplace_booking.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiMarketplaceBookingRepository {
  final ApiClient _apiClient;

  ApiMarketplaceBookingRepository(this._apiClient);

  /// [tab] is `'upcoming'` or `'past'`. See Issue 14 spec for time semantics.
  Future<CursorPage<MarketplaceBooking>> getMyBookings({
    required String tab,
    int? perPage,
    String? cursor,
  }) async {
    try {
      final res = await _apiClient.get(
        '/v1/marketplace/me/bookings',
        queryParameters: {
          'tab': tab,
          'per_page': ?perPage,
          'cursor': ?cursor,
        },
      );
      return CursorPage.fromJson(
        res.data as Map<String, dynamic>,
        MarketplaceBooking.fromJson,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
