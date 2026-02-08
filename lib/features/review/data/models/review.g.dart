// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  reviewerId: json['reviewer_id'] as String,
  reviewerName: json['reviewer_name'] as String,
  coachId: json['coach_id'] as String,
  coachName: json['coach_name'] as String,
  sessionId: json['session_id'] as String,
  sessionTitle: json['session_title'] as String,
  sport: $enumDecode(_$SportEnumMap, json['sport']),
  date: DateTime.parse(json['date'] as String),
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String?,
  isAnonymous: json['is_anonymous'] as bool? ?? false,
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewer_id': instance.reviewerId,
      'reviewer_name': instance.reviewerName,
      'coach_id': instance.coachId,
      'coach_name': instance.coachName,
      'session_id': instance.sessionId,
      'session_title': instance.sessionTitle,
      'sport': _$SportEnumMap[instance.sport]!,
      'date': instance.date.toIso8601String(),
      'rating': instance.rating,
      'comment': instance.comment,
      'is_anonymous': instance.isAnonymous,
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
