// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'marketplace_booking.freezed.dart';
part 'marketplace_booking.g.dart';

/// One enrolled session in the student's bookings list. Cross-tenant —
/// includes sessions from any tenant the student has joined.
///
/// From `GET /v1/marketplace/me/bookings?tab=upcoming|past` (Issue 14).
@freezed
class MarketplaceBooking with _$MarketplaceBooking {
  const factory MarketplaceBooking({
    @JsonKey(name: 'booking_id', fromJson: idFromJson)
    required String bookingId,
    @JsonKey(name: 'booked_at', fromJson: tenantWallClockFromJson)
    required DateTime bookedAt,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    required BookingSession session,
    @JsonKey(name: 'can_review') @Default(false) bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
  }) = _MarketplaceBooking;

  factory MarketplaceBooking.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceBookingFromJson(json);
}

@freezed
class BookingSession with _$BookingSession {
  const factory BookingSession({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required DateTime startAt,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    BookingTenant? tenant,
    BookingVenue? venue,
    @Default(<BookingCoach>[]) List<BookingCoach> coaches,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  }) = _BookingSession;

  factory BookingSession.fromJson(Map<String, dynamic> json) =>
      _$BookingSessionFromJson(json);
}

extension BookingSessionTitleX on BookingSession {
  String get safeTitle =>
      (displayTitle != null && displayTitle!.isNotEmpty)
          ? displayTitle!
          : name;
}

@freezed
class BookingTenant with _$BookingTenant {
  const factory BookingTenant({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? slug,
    @JsonKey(name: 'brand_color') String? brandColor,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
  }) = _BookingTenant;

  factory BookingTenant.fromJson(Map<String, dynamic> json) =>
      _$BookingTenantFromJson(json);
}

@freezed
class BookingVenue with _$BookingVenue {
  const factory BookingVenue({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    BookingVenueLocation? location,
  }) = _BookingVenue;

  factory BookingVenue.fromJson(Map<String, dynamic> json) =>
      _$BookingVenueFromJson(json);
}

@freezed
class BookingVenueLocation with _$BookingVenueLocation {
  const factory BookingVenueLocation({
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  }) = _BookingVenueLocation;

  factory BookingVenueLocation.fromJson(Map<String, dynamic> json) =>
      _$BookingVenueLocationFromJson(json);
}

@freezed
class BookingCoach with _$BookingCoach {
  const factory BookingCoach({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    @JsonKey(name: 'photo_url') String? photoUrl,
  }) = _BookingCoach;

  factory BookingCoach.fromJson(Map<String, dynamic> json) =>
      _$BookingCoachFromJson(json);
}
