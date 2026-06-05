// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_payout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachPayoutImpl _$$CoachPayoutImplFromJson(Map<String, dynamic> json) =>
    _$CoachPayoutImpl(
      id: (json['id'] as num).toInt(),
      sessionId: (json['session_id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      period: json['period'] as String,
      status: json['status'] as String,
      requestId: (json['request_id'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      sessionMeta: json['session'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CoachPayoutImplToJson(_$CoachPayoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'amount': instance.amount,
      'currency': instance.currency,
      'period': instance.period,
      'status': instance.status,
      'request_id': instance.requestId,
      'created_at': instance.createdAt.toIso8601String(),
      'session': instance.sessionMeta,
    };
