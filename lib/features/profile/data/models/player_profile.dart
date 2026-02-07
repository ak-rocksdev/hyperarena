import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'player_profile.freezed.dart';
part 'player_profile.g.dart';

@freezed
class PlayerProfile with _$PlayerProfile {
  const factory PlayerProfile({
    required String userId,
    String? bio,
    required String city,
    @Default([]) List<Sport> sports,
    @Default({}) Map<String, String> selfAssessedLevels,
    @Default(0) int totalXp,
    @Default(LevelTier.rookie) LevelTier levelTier,
    @Default(0) int profileCompletionPct,
  }) = _PlayerProfile;

  factory PlayerProfile.fromJson(Map<String, dynamic> json) =>
      _$PlayerProfileFromJson(json);
}
