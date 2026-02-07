import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String courtId,
    required String venueId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int totalAmount,
    required PaymentMethodType paymentMethod,
    String? venueName,
    String? courtName,
  });
  Future<List<Booking>> getBookings({BookingStatus? status});
  Future<Booking> getBooking(String id);
  Future<Booking> uploadPaymentProof(String bookingId, String proofUrl);
  Future<Booking> cancelBooking(String id);
}
