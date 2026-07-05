// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateSessionDraftImpl _$$CreateSessionDraftImplFromJson(
  Map<String, dynamic> json,
) => _$CreateSessionDraftImpl(
  coachIds:
      (json['coach_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  type:
      $enumDecodeNullable(_$SessionTypeEnumMap, json['type']) ??
      SessionType.group,
  title: json['title'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  startTime: json['start_time'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 60,
  capacity: (json['capacity'] as num?)?.toInt(),
  venueId: json['venue_id'] as String?,
  venueName: json['venue_name'] as String?,
  price: (json['price'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$CreateSessionDraftImplToJson(
  _$CreateSessionDraftImpl instance,
) => <String, dynamic>{
  'coach_ids': instance.coachIds,
  'type': _$SessionTypeEnumMap[instance.type]!,
  'title': instance.title,
  'date': instance.date?.toIso8601String(),
  'start_time': instance.startTime,
  'duration_minutes': instance.durationMinutes,
  'capacity': instance.capacity,
  'venue_id': instance.venueId,
  'venue_name': instance.venueName,
  'price': instance.price,
  'notes': instance.notes,
};

const _$SessionTypeEnumMap = {
  SessionType.trial: 'trial',
  SessionType.group: 'group',
  SessionType.private: 'private',
};
