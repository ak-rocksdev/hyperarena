// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachPackageImpl _$$CoachPackageImplFromJson(Map<String, dynamic> json) =>
    _$CoachPackageImpl(
      id: json['id'] as String,
      coachId: json['coach_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      sport: $enumDecode(_$SportEnumMap, json['sport']),
      sessions: (json['sessions'] as num).toInt(),
      pricePerSession: (json['price_per_session'] as num).toInt(),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$CoachPackageImplToJson(_$CoachPackageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coach_id': instance.coachId,
      'name': instance.name,
      'description': instance.description,
      'sport': _$SportEnumMap[instance.sport]!,
      'sessions': instance.sessions,
      'price_per_session': instance.pricePerSession,
      'duration_minutes': instance.durationMinutes,
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
