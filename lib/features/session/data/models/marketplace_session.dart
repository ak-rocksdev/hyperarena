// lib/features/session/data/models/marketplace_session.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';

part 'marketplace_session.freezed.dart';
part 'marketplace_session.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceSession with _$MarketplaceSession {
  const factory MarketplaceSession({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    String? type,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    required int capacity,
    @JsonKey(name: 'booked_count') @Default(0) int bookedCount,
    String? notes,
    SessionTenant? tenant,
    MarketplaceSessionVenue? venue,
    @Default([]) List<SessionCoach> coaches,
  }) = _MarketplaceSession;

  factory MarketplaceSession.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionFromJson(json);
}

@freezed
class SessionTenant with _$SessionTenant {
  const factory SessionTenant({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
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
class SessionCoach with _$SessionCoach {
  const factory SessionCoach({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    @JsonKey(name: 'photo_path') String? photoPath,
  }) = _SessionCoach;

  factory SessionCoach.fromJson(Map<String, dynamic> json) =>
      _$SessionCoachFromJson(json);
}
