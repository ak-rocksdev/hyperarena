// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_payout_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachPayoutBalanceImpl _$$CoachPayoutBalanceImplFromJson(
  Map<String, dynamic> json,
) => _$CoachPayoutBalanceImpl(
  outstandingCents: (json['outstanding_cents'] as num?)?.toInt() ?? 0,
  requestedCents: (json['requested_cents'] as num?)?.toInt() ?? 0,
  approvedCents: (json['approved_cents'] as num?)?.toInt() ?? 0,
  paidCents: (json['paid_cents'] as num?)?.toInt() ?? 0,
  outstandingSessionCount:
      (json['outstanding_session_count'] as num?)?.toInt() ?? 0,
  outstandingPeriods:
      (json['outstanding_periods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$$CoachPayoutBalanceImplToJson(
  _$CoachPayoutBalanceImpl instance,
) => <String, dynamic>{
  'outstanding_cents': instance.outstandingCents,
  'requested_cents': instance.requestedCents,
  'approved_cents': instance.approvedCents,
  'paid_cents': instance.paidCents,
  'outstanding_session_count': instance.outstandingSessionCount,
  'outstanding_periods': instance.outstandingPeriods,
};
