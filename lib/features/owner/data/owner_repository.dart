import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';
import 'package:hyperarena/features/owner/data/models/owner_dashboard_stats.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

abstract class OwnerRepository {
  Future<OwnerDashboardStats> getDashboard();
  Future<List<Venue>> getMyVenues();
  Future<Venue> getVenueDetail(String venueId);
  Future<Venue> updateVenueBasic({
    required String venueId,
    String? name,
    String? description,
    String? address,
  });

  Future<List<Booking>> getBookingQueue({String? venueId});
  Future<Booking> confirmBookingPayment(String bookingId);
  Future<Booking> rejectBookingPayment(
    String bookingId, {
    required String reason,
  });

  Future<Booking> markBookingSettled(String bookingId, {String? note});

  Future<List<CourtAvailabilityIssue>> getCourtAvailabilityIssues();
  Future<CourtAvailabilityIssue> setCourtUnavailable(
    String courtId, {
    required DateTime from,
    required DateTime to,
    required String reason,
  });
}
