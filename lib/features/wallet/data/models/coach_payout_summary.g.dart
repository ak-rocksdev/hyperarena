// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_payout_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachPayoutSummaryImpl _$$CoachPayoutSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$CoachPayoutSummaryImpl(
  period: json['period'] as String,
  totalEarnedCents: (json['total_earned_cents'] as num?)?.toInt() ?? 0,
  sessionCount: (json['session_count'] as num?)?.toInt() ?? 0,
  studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
  pendingCents: (json['pending_cents'] as num?)?.toInt() ?? 0,
  requestedCents: (json['requested_cents'] as num?)?.toInt() ?? 0,
  approvedCents: (json['approved_cents'] as num?)?.toInt() ?? 0,
  paidCents: (json['paid_cents'] as num?)?.toInt() ?? 0,
  activeRequestId: (json['active_request_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CoachPayoutSummaryImplToJson(
  _$CoachPayoutSummaryImpl instance,
) => <String, dynamic>{
  'period': instance.period,
  'total_earned_cents': instance.totalEarnedCents,
  'session_count': instance.sessionCount,
  'student_count': instance.studentCount,
  'pending_cents': instance.pendingCents,
  'requested_cents': instance.requestedCents,
  'approved_cents': instance.approvedCents,
  'paid_cents': instance.paidCents,
  'active_request_id': instance.activeRequestId,
};
