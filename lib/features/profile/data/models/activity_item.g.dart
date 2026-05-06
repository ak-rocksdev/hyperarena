// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivitySubjectImpl _$$ActivitySubjectImplFromJson(
  Map<String, dynamic> json,
) => _$ActivitySubjectImpl(
  type: json['type'] as String,
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$$ActivitySubjectImplToJson(
  _$ActivitySubjectImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'name': instance.name,
};

_$ActivityItemImpl _$$ActivityItemImplFromJson(Map<String, dynamic> json) =>
    _$ActivityItemImpl(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      description: json['description'] as String,
      subject: json['subject'] == null
          ? null
          : ActivitySubject.fromJson(json['subject'] as Map<String, dynamic>),
      occurredAt: json['occurred_at'] == null
          ? null
          : DateTime.parse(json['occurred_at'] as String),
    );

Map<String, dynamic> _$$ActivityItemImplToJson(_$ActivityItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'description': instance.description,
      'subject': instance.subject,
      'occurred_at': instance.occurredAt?.toIso8601String(),
    };

const _$ActivityTypeEnumMap = {
  ActivityType.sessionCompleted: 'session_completed',
  ActivityType.attendanceFilled: 'attendance_filled',
  ActivityType.assessmentSubmitted: 'assessment_submitted',
  ActivityType.profileUpdated: 'profile_updated',
  ActivityType.reviewSent: 'review_sent',
  ActivityType.unknown: 'unknown',
};
