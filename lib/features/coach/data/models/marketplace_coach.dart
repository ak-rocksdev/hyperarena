// lib/features/coach/data/models/marketplace_coach.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';

part 'marketplace_coach.freezed.dart';
part 'marketplace_coach.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceCoach with _$MarketplaceCoach {
  const factory MarketplaceCoach({
    @JsonKey(fromJson: _idFromJson) required String id,
    String? bio,
    CoachUser? user,
    SportInfo? sport,
    @JsonKey(name: 'rate_per_session') int? ratePerSession,
    String? currency,
  }) = _MarketplaceCoach;

  factory MarketplaceCoach.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCoachFromJson(json);
}

@freezed
class CoachUser with _$CoachUser {
  const factory CoachUser({
    required String name,
    @JsonKey(name: 'photo_path') String? photoPath,
  }) = _CoachUser;

  factory CoachUser.fromJson(Map<String, dynamic> json) =>
      _$CoachUserFromJson(json);
}
