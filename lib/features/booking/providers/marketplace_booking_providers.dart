import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/booking/data/api_marketplace_booking_repository.dart';
import 'package:hyperarena/features/booking/data/models/marketplace_booking.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

enum BookingTab { upcoming, past }

extension on BookingTab {
  String get wire => name;
}

final marketplaceBookingRepoProvider =
    Provider<ApiMarketplaceBookingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceBookingRepository(apiClient);
});

/// Per-tab booking list. Family keyed by [BookingTab].
/// Returns the first page only — pagination is handled by the screen.
final myBookingsProvider =
    FutureProvider.family<List<MarketplaceBooking>, BookingTab>(
        (ref, tab) async {
  final repo = ref.watch(marketplaceBookingRepoProvider);
  final page = await repo.getMyBookings(tab: tab.wire);
  return page.items;
});
