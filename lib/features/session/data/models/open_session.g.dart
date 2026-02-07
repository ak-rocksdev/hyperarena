// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenSessionImpl _$$OpenSessionImplFromJson(Map<String, dynamic> json) =>
    _$OpenSessionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      sport: $enumDecode(_$SportEnumMap, json['sport']),
      hostId: json['host_id'] as String,
      hostName: json['host_name'] as String,
      venueName: json['venue_name'] as String,
      venueId: json['venue_id'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      currentPlayers: (json['current_players'] as num?)?.toInt() ?? 0,
      maxPlayers: (json['max_players'] as num).toInt(),
      minLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['min_level']),
      maxLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['max_level']),
      pricePerPerson: (json['price_per_person'] as num).toInt(),
      description: json['description'] as String?,
      participantNames:
          (json['participant_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OpenSessionImplToJson(_$OpenSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sport': _$SportEnumMap[instance.sport]!,
      'host_id': instance.hostId,
      'host_name': instance.hostName,
      'venue_name': instance.venueName,
      'venue_id': instance.venueId,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'current_players': instance.currentPlayers,
      'max_players': instance.maxPlayers,
      'min_level': _$LevelTierEnumMap[instance.minLevel],
      'max_level': _$LevelTierEnumMap[instance.maxLevel],
      'price_per_person': instance.pricePerPerson,
      'description': instance.description,
      'participant_names': instance.participantNames,
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
