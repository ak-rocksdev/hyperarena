// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerProfileImpl _$$PlayerProfileImplFromJson(Map<String, dynamic> json) =>
    _$PlayerProfileImpl(
      userId: json['user_id'] as String,
      bio: json['bio'] as String?,
      city: json['city'] as String,
      sports:
          (json['sports'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SportEnumMap, e))
              .toList() ??
          const [],
      selfAssessedLevels:
          (json['self_assessed_levels'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      levelTier:
          $enumDecodeNullable(_$LevelTierEnumMap, json['level_tier']) ??
          LevelTier.rookie,
      profileCompletionPct:
          (json['profile_completion_pct'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlayerProfileImplToJson(_$PlayerProfileImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'bio': instance.bio,
      'city': instance.city,
      'sports': instance.sports.map((e) => _$SportEnumMap[e]!).toList(),
      'self_assessed_levels': instance.selfAssessedLevels,
      'total_xp': instance.totalXp,
      'level_tier': _$LevelTierEnumMap[instance.levelTier]!,
      'profile_completion_pct': instance.profileCompletionPct,
    };

const _$SportEnumMap = {
  Sport.tennis: 'tennis',
  Sport.padel: 'padel',
  Sport.badminton: 'badminton',
  Sport.futsal: 'futsal',
  Sport.basketball: 'basketball',
  Sport.volleyball: 'volleyball',
  Sport.tableTennis: 'tableTennis',
};

const _$LevelTierEnumMap = {
  LevelTier.rookie: 'rookie',
  LevelTier.amateur: 'amateur',
  LevelTier.intermediate: 'intermediate',
  LevelTier.advanced: 'advanced',
  LevelTier.pro: 'pro',
};
