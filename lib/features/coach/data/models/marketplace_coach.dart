// lib/features/coach/data/models/marketplace_coach.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'marketplace_coach.freezed.dart';
part 'marketplace_coach.g.dart';

@freezed
class MarketplaceCoach with _$MarketplaceCoach {
  const factory MarketplaceCoach({
    @JsonKey(fromJson: idFromJson) required String id,
    String? bio,
    CoachUser? user,
    SportInfo? sport,
    @JsonKey(name: 'rate_per_session') int? ratePerSession,
    String? currency,
    @JsonKey(name: 'tenant_id') int? tenantId,
  }) = _MarketplaceCoach;

  factory MarketplaceCoach.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCoachFromJson(json);
}

@freezed
class CoachUser with _$CoachUser {
  const factory CoachUser({
    required String name,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  }) = _CoachUser;

  factory CoachUser.fromJson(Map<String, dynamic> json) =>
      _$CoachUserFromJson(json);
}
