import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'coaching_booking.freezed.dart';
part 'coaching_booking.g.dart';

@freezed
class CoachingBooking with _$CoachingBooking {
  const factory CoachingBooking({
    required String id,
    required String coachId,
    required String coachName,
    required String playerId,
    required String playerName,
    required String packageId,
    required String packageName,
    required Sport sport,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String venueName,
    required int amount,
    @Default(BookingStatus.pendingPayment) BookingStatus status,
    required DateTime createdAt,
  }) = _CoachingBooking;

  factory CoachingBooking.fromJson(Map<String, dynamic> json) =>
      _$CoachingBookingFromJson(json);
}
