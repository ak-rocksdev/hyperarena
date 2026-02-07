import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

part 'booking_summary.freezed.dart';
part 'booking_summary.g.dart';

@freezed
class BookingSummary with _$BookingSummary {
  const factory BookingSummary({
    Court? court,
    Venue? venue,
    DateTime? date,
    @Default([]) List<CourtSlot> slots,
    @Default(0) int totalAmount,
    PaymentMethodType? paymentMethod,
  }) = _BookingSummary;

  factory BookingSummary.empty() => const BookingSummary();

  factory BookingSummary.fromJson(Map<String, dynamic> json) =>
      _$BookingSummaryFromJson(json);
}
