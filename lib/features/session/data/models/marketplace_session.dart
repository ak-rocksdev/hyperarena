// lib/features/session/data/models/marketplace_session.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'marketplace_session.freezed.dart';
part 'marketplace_session.g.dart';

@freezed
class MarketplaceSession with _$MarketplaceSession {
  const factory MarketplaceSession({
    @JsonKey(fromJson: idFromJson) required String id,
    @Default('Sesi Latihan') String name,
    String? type,
    @JsonKey(name: 'start_at', fromJson: tenantWallClockFromJson)
    required DateTime startAt,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    // Default 0 so a legacy row with null capacity (one historical row
    // surfaced after dropping the end-time filter) doesn't crash the
    // whole list. Card renders "0/N peserta" — visually wrong but
    // recoverable; whole-screen failure is not.
    @Default(0) int capacity,
    @JsonKey(name: 'booked_count') @Default(0) int bookedCount,
    String? notes,
    SessionTenant? tenant,
    MarketplaceSessionVenue? venue,
    @Default([]) List<SessionCoach> coaches,
    @Default([]) List<SessionParticipant> participants,
    @Default(false) bool isEnrolled,
    String? title,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  }) = _MarketplaceSession;

  factory MarketplaceSession.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionFromJson(json);
}

extension MarketplaceSessionTitleX on MarketplaceSession {
  /// User-facing heading. Prefers [displayTitle] (post-feature BE),
  /// falls back to [name] (pre-feature BE auto-name). Always non-null.
  String get safeTitle =>
      (displayTitle != null && displayTitle!.isNotEmpty)
          ? displayTitle!
          : name;
}

@freezed
class SessionTenant with _$SessionTenant {
  const factory SessionTenant({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? slug,
    /// Hex color (`#RRGGBB`) for fallback hero rendering when the session
    /// has no photo and falls back to the tenant logo (logo is square,
    /// rendered centered on this color to fill the 16:9 box).
    @JsonKey(name: 'brand_color') String? brandColor,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
  }) = _SessionTenant;

  factory SessionTenant.fromJson(Map<String, dynamic> json) =>
      _$SessionTenantFromJson(json);
}

@freezed
class MarketplaceSessionVenue with _$MarketplaceSessionVenue {
  const factory MarketplaceSessionVenue({
    required String name,
    VenueLocation? location,
  }) = _MarketplaceSessionVenue;

  factory MarketplaceSessionVenue.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionVenueFromJson(json);
}

@freezed
class SessionParticipant with _$SessionParticipant {
  const factory SessionParticipant({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? photoUrl,
    @JsonKey(name: 'booked_at') DateTime? bookedAt,
  }) = _SessionParticipant;

  factory SessionParticipant.fromJson(Map<String, dynamic> json) =>
      _$SessionParticipantFromJson(json);
}

@freezed
class SessionCoach with _$SessionCoach {
  const factory SessionCoach({
    @JsonKey(fromJson: idFromJson) required String id,
    CoachUser? user,
  }) = _SessionCoach;

  factory SessionCoach.fromJson(Map<String, dynamic> json) =>
      _$SessionCoachFromJson(json);
}
