import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required BookingType bookingType,
    required String bookingCode,
    required String playerId,
    String? venueId,
    String? courtId,
    required DateTime bookingDate,
    required String startTime,
    required String endTime,
    required int totalAmount,
    required BookingStatus status,
    required PaymentMethodType paymentMethod,
    String? paymentProofUrl,
    DateTime? expiresAt,
    required DateTime createdAt,
    String? venueName,
    String? courtName,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
