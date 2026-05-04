import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/owner/data/mock_owner_repository.dart';
import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';
import 'package:hyperarena/features/owner/data/models/owner_dashboard_stats.dart';
import 'package:hyperarena/features/owner/data/owner_repository.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  return MockOwnerRepository();
});

final ownerDashboardProvider = FutureProvider<OwnerDashboardStats>((ref) {
  return ref.watch(ownerRepositoryProvider).getDashboard();
});

final ownerVenuesProvider = FutureProvider<List<Venue>>((ref) {
  return ref.watch(ownerRepositoryProvider).getMyVenues();
});

final ownerVenueDetailProvider = FutureProvider.family<Venue, String>((
  ref,
  id,
) {
  return ref.watch(ownerRepositoryProvider).getVenueDetail(id);
});

final ownerQueueVenueFilterProvider = StateProvider<String?>((ref) => null);

final ownerBookingQueueProvider = FutureProvider<List<Booking>>((ref) {
  final venueId = ref.watch(ownerQueueVenueFilterProvider);
  return ref.watch(ownerRepositoryProvider).getBookingQueue(venueId: venueId);
});

final ownerAvailabilityIssuesProvider =
    FutureProvider<List<CourtAvailabilityIssue>>((ref) {
      return ref.watch(ownerRepositoryProvider).getCourtAvailabilityIssues();
    });

final ownerBoundarySignalsProvider = Provider<List<String>>((ref) {
  return const [
    'Owner confirmation required: pembayaran booking lapangan',
    'Organizer managed payment: booking open session dibayar ke organizer',
    'Jika court unavailable, organizer harus diberi notifikasi segera',
  ];
});

final ownerActionsProvider = Provider<OwnerActionsController>((ref) {
  return OwnerActionsController(ref);
});

class OwnerActionsController {
  OwnerActionsController(this.ref);

  final Ref ref;

  Future<void> confirmBooking(String bookingId) async {
    await ref.read(ownerRepositoryProvider).confirmBookingPayment(bookingId);
    _invalidateAll();
  }

  Future<void> rejectBooking(String bookingId, {required String reason}) async {
    await ref
        .read(ownerRepositoryProvider)
        .rejectBookingPayment(bookingId, reason: reason);
    _invalidateAll();
  }

  Future<void> updateVenue({
    required String venueId,
    String? name,
    String? description,
    String? address,
  }) async {
    await ref
        .read(ownerRepositoryProvider)
        .updateVenueBasic(
          venueId: venueId,
          name: name,
          description: description,
          address: address,
        );
    _invalidateAll();
    ref.invalidate(ownerVenueDetailProvider(venueId));
  }

  Future<void> setCourtUnavailable({
    required String courtId,
    required DateTime from,
    required DateTime to,
    required String reason,
  }) async {
    await ref
        .read(ownerRepositoryProvider)
        .setCourtUnavailable(courtId, from: from, to: to, reason: reason);
    _invalidateAll();
  }

  void _invalidateAll() {
    ref.invalidate(ownerDashboardProvider);
    ref.invalidate(ownerVenuesProvider);
    ref.invalidate(ownerBookingQueueProvider);
    ref.invalidate(ownerAvailabilityIssuesProvider);
  }
}
