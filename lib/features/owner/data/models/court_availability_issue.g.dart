// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_availability_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourtAvailabilityIssueImpl _$$CourtAvailabilityIssueImplFromJson(
  Map<String, dynamic> json,
) => _$CourtAvailabilityIssueImpl(
  id: json['id'] as String,
  courtId: json['court_id'] as String,
  courtName: json['court_name'] as String,
  venueId: json['venue_id'] as String,
  venueName: json['venue_name'] as String,
  from: DateTime.parse(json['from'] as String),
  to: DateTime.parse(json['to'] as String),
  reason: json['reason'] as String,
  requiresOrganizerNotice: json['requires_organizer_notice'] as bool? ?? false,
);

Map<String, dynamic> _$$CourtAvailabilityIssueImplToJson(
  _$CourtAvailabilityIssueImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'court_id': instance.courtId,
  'court_name': instance.courtName,
  'venue_id': instance.venueId,
  'venue_name': instance.venueName,
  'from': instance.from.toIso8601String(),
  'to': instance.to.toIso8601String(),
  'reason': instance.reason,
  'requires_organizer_notice': instance.requiresOrganizerNotice,
};
