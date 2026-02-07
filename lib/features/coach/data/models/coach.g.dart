// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachImpl _$$CoachImplFromJson(Map<String, dynamic> json) => _$CoachImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  bio: json['bio'] as String,
  avatarUrl: json['avatar_url'] as String?,
  sports:
      (json['sports'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$SportEnumMap, e))
          .toList() ??
      const [],
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
  hourlyRate: (json['hourly_rate'] as num).toInt(),
  city: json['city'] as String,
  isVerified: json['is_verified'] as bool? ?? false,
  level:
      $enumDecodeNullable(_$LevelTierEnumMap, json['level']) ??
      LevelTier.amateur,
  totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
  certifications:
      (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CoachImplToJson(_$CoachImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'avatar_url': instance.avatarUrl,
      'sports': instance.sports.map((e) => _$SportEnumMap[e]!).toList(),
      'rating': instance.rating,
      'total_reviews': instance.totalReviews,
      'hourly_rate': instance.hourlyRate,
      'city': instance.city,
      'is_verified': instance.isVerified,
      'level': _$LevelTierEnumMap[instance.level]!,
      'total_students': instance.totalStudents,
      'certifications': instance.certifications,
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
