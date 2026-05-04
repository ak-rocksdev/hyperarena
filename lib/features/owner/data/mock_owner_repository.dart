import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';
import 'package:hyperarena/features/owner/data/models/owner_dashboard_stats.dart';
import 'package:hyperarena/features/owner/data/owner_repository.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

class MockOwnerRepository implements OwnerRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  MockOwnerRepository();

  static const _ownerId = 'owner-001';

  List<Venue> get _venues =>
      MockData.venues.where((v) => v.ownerId == _ownerId).toList();

  List<Booking> _queueForVenues(List<String> venueIds) {
    return MockData.bookings
        .where((b) => venueIds.contains(b.venueId))
        .where(
          (b) =>
              b.status == BookingStatus.pendingPayment ||
              b.status == BookingStatus.waitingConfirmation,
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<OwnerDashboardStats> getDashboard() async {
    await Future.delayed(_delay);
    final venues = _venues;
    final venueIds = venues.map((v) => v.id).toList();
    final now = DateTime.now();
    final bookingsToday = MockData.bookings
        .where((b) => venueIds.contains(b.venueId))
        .where(
          (b) =>
              b.bookingDate.year == now.year &&
              b.bookingDate.month == now.month &&
              b.bookingDate.day == now.day,
        )
        .toList();
    final pendingQueue = _queueForVenues(venueIds);
    final completedThisMonth = MockData.bookings
        .where((b) => venueIds.contains(b.venueId))
        .where((b) => b.status == BookingStatus.completed)
        .where(
          (b) =>
              b.bookingDate.month == now.month &&
              b.bookingDate.year == now.year,
        )
        .toList();

    final monthlyRevenue = completedThisMonth.fold<int>(
      0,
      (sum, b) => sum + b.totalAmount,
    );
    final todayRevenue = bookingsToday
        .where((b) => b.status == BookingStatus.completed)
        .fold<int>(0, (sum, b) => sum + b.totalAmount);

    final occupancy = venues.isEmpty
        ? 0.0
        : (bookingsToday.length / (venues.length * 8)).clamp(0.0, 1.0);

    return OwnerDashboardStats(
      bookingsToday: bookingsToday.length,
      pendingConfirmations: pendingQueue.length,
      todayRevenue: todayRevenue,
      monthlyRevenue: monthlyRevenue,
      occupancyRate: occupancy,
    );
  }

  @override
  Future<List<Venue>> getMyVenues() async {
    await Future.delayed(_delay);
    return _venues;
  }

  @override
  Future<Venue> getVenueDetail(String venueId) async {
    await Future.delayed(_delay);
    return _venues.firstWhere((v) => v.id == venueId);
  }

  @override
  Future<Venue> updateVenueBasic({
    required String venueId,
    String? name,
    String? description,
    String? address,
  }) async {
    await Future.delayed(_delay);
    final venue = await getVenueDetail(venueId);
    final updated = venue.copyWith(
      name: name ?? venue.name,
      description: description ?? venue.description,
      address: address ?? venue.address,
    );
    MockData.upsertVenue(updated);
    return updated;
  }

  @override
  Future<List<Booking>> getBookingQueue({String? venueId}) async {
    await Future.delayed(_delay);
    final venueIds = venueId != null
        ? [venueId]
        : _venues.map((v) => v.id).toList();
    return _queueForVenues(venueIds);
  }

  @override
  Future<Booking> confirmBookingPayment(String bookingId) async {
    await Future.delayed(_delay);
    final booking = MockData.bookings.firstWhere((b) => b.id == bookingId);
    final updated = booking.copyWith(status: BookingStatus.confirmed);
    MockData.upsertBooking(updated);
    return updated;
  }

  @override
  Future<Booking> rejectBookingPayment(
    String bookingId, {
    required String reason,
  }) async {
    await Future.delayed(_delay);
    final booking = MockData.bookings.firstWhere((b) => b.id == bookingId);
    final updated = booking.copyWith(status: BookingStatus.rejected);
    MockData.upsertBooking(updated);
    return updated;
  }

  @override
  Future<Booking> markBookingSettled(String bookingId, {String? note}) async {
    await Future.delayed(_delay);
    final booking = MockData.bookings.firstWhere((b) => b.id == bookingId);
    final updated = booking.copyWith(status: BookingStatus.confirmed);
    MockData.upsertBooking(updated);
    return updated;
  }

  @override
  Future<List<CourtAvailabilityIssue>> getCourtAvailabilityIssues() async {
    await Future.delayed(_delay);
    final myVenueIds = _venues.map((v) => v.id).toSet();
    return MockData.ownerIssues
        .where((i) => myVenueIds.contains(i.venueId))
        .toList();
  }

  Court _findCourtById(String courtId) {
    return _venues
        .expand((v) => v.courts)
        .firstWhere((court) => court.id == courtId);
  }

  @override
  Future<CourtAvailabilityIssue> setCourtUnavailable(
    String courtId, {
    required DateTime from,
    required DateTime to,
    required String reason,
  }) async {
    await Future.delayed(_delay);
    final court = _findCourtById(courtId);
    final venue = _venues.firstWhere((v) => v.id == court.venueId);
    final issue = CourtAvailabilityIssue(
      id: 'issue-${DateTime.now().millisecondsSinceEpoch}',
      courtId: court.id,
      courtName: court.name,
      venueId: venue.id,
      venueName: venue.name,
      from: from,
      to: to,
      reason: reason,
      requiresOrganizerNotice: true,
    );
    MockData.upsertOwnerIssue(issue);
    return issue;
  }
}
