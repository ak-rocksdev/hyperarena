import 'dart:math';

import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/booking_repository.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:intl/intl.dart';

class MockBookingRepository implements BookingRepository {
  final AppConfig config;
  final List<Booking> _bookings = List.from(MockData.bookings);

  MockBookingRepository(this.config);

  String _generateCode() {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'BK-$date-$random';
  }

  @override
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
  }) async {
    await Future.delayed(config.mockDelay);
    final now = DateTime.now();
    final booking = Booking(
      id: 'booking-${now.millisecondsSinceEpoch}',
      bookingType: BookingType.court,
      bookingCode: _generateCode(),
      playerId: MockData.currentUser.id,
      venueId: venueId,
      courtId: courtId,
      bookingDate: date,
      startTime: startTime,
      endTime: endTime,
      totalAmount: totalAmount,
      status: BookingStatus.pendingPayment,
      paymentMethod: paymentMethod,
      expiresAt: now.add(const Duration(hours: 1)),
      createdAt: now,
      venueName: venueName,
      courtName: courtName,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<List<Booking>> getBookings({BookingStatus? status}) async {
    await Future.delayed(config.mockDelay);
    if (status != null) {
      return _bookings.where((b) => b.status == status).toList();
    }
    return List.from(_bookings);
  }

  @override
  Future<Booking> getBooking(String id) async {
    await Future.delayed(config.mockDelay);
    return _bookings.firstWhere((b) => b.id == id);
  }

  @override
  Future<Booking> uploadPaymentProof(String bookingId, String proofUrl) async {
    await Future.delayed(config.mockDelay);
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    final updated = _bookings[index].copyWith(
      status: BookingStatus.waitingConfirmation,
      paymentProofUrl: proofUrl,
    );
    _bookings[index] = updated;
    return updated;
  }

  @override
  Future<Booking> cancelBooking(String id) async {
    await Future.delayed(config.mockDelay);
    final index = _bookings.indexWhere((b) => b.id == id);
    final updated = _bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    _bookings[index] = updated;
    return updated;
  }
}
