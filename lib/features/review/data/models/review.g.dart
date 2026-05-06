// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: idFromJson(json['id']),
  coachId: idFromJson(json['coach_id']),
  sessionId: idFromJson(json['session_id']),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  coachName: json['coach_name'] as String?,
  sessionTitle: json['session_title'] as String?,
  sessionDate: json['session_date'] == null
      ? null
      : DateTime.parse(json['session_date'] as String),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coach_id': instance.coachId,
      'session_id': instance.sessionId,
      'rating': instance.rating,
      'comment': instance.comment,
      'created_at': instance.createdAt.toIso8601String(),
      'coach_name': instance.coachName,
      'session_title': instance.sessionTitle,
      'session_date': instance.sessionDate?.toIso8601String(),
    };
