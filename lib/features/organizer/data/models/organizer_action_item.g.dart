// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_action_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizerActionItemImpl _$$OrganizerActionItemImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerActionItemImpl(
  id: json['id'] as String,
  type: $enumDecode(_$OrganizerActionTypeEnumMap, json['type']),
  severity:
      $enumDecodeNullable(_$OrganizerActionSeverityEnumMap, json['severity']) ??
      OrganizerActionSeverity.medium,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  sessionId: json['session_id'] as String?,
  participantId: json['participant_id'] as String?,
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
  actionableRoute: json['actionable_route'] as String?,
  amountImpact: (json['amount_impact'] as num?)?.toInt(),
  timeToStart: _durationFromJson((json['time_to_start'] as num?)?.toInt()),
);

Map<String, dynamic> _$$OrganizerActionItemImplToJson(
  _$OrganizerActionItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$OrganizerActionTypeEnumMap[instance.type]!,
  'severity': _$OrganizerActionSeverityEnumMap[instance.severity]!,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'session_id': instance.sessionId,
  'participant_id': instance.participantId,
  'due_at': instance.dueAt?.toIso8601String(),
  'actionable_route': instance.actionableRoute,
  'amount_impact': instance.amountImpact,
  'time_to_start': _durationToJson(instance.timeToStart),
};

const _$OrganizerActionTypeEnumMap = {
  OrganizerActionType.confirmPayment: 'confirmPayment',
  OrganizerActionType.waitlistDecision: 'waitlistDecision',
  OrganizerActionType.sessionRisk: 'sessionRisk',
  OrganizerActionType.refundRequest: 'refundRequest',
  OrganizerActionType.dispute: 'dispute',
  OrganizerActionType.ownerIssue: 'ownerIssue',
};

const _$OrganizerActionSeverityEnumMap = {
  OrganizerActionSeverity.low: 'low',
  OrganizerActionSeverity.medium: 'medium',
  OrganizerActionSeverity.high: 'high',
};
