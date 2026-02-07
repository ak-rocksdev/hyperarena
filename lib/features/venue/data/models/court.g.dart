// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourtImpl _$$CourtImplFromJson(Map<String, dynamic> json) => _$CourtImpl(
  id: json['id'] as String,
  venueId: json['venue_id'] as String,
  name: json['name'] as String,
  sportType: $enumDecode(_$SportEnumMap, json['sport_type']),
  surfaceType: json['surface_type'] as String?,
  environment: json['environment'] as String,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$$CourtImplToJson(_$CourtImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venue_id': instance.venueId,
      'name': instance.name,
      'sport_type': _$SportEnumMap[instance.sportType]!,
      'surface_type': instance.surfaceType,
      'environment': instance.environment,
      'photos': instance.photos,
      'is_active': instance.isActive,
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
