// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_join_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionJoinResponseImpl _$$SessionJoinResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SessionJoinResponseImpl(
  status: json['status'] as String,
  usedCredit: json['used_credit'] as bool,
  creditBalanceAfter: (json['credit_balance_after'] as num?)?.toInt(),
  purchaseId: (json['purchase_id'] as num?)?.toInt(),
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  message: json['message'] as String,
  booking: JoinBookingInfo.fromJson(json['booking'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SessionJoinResponseImplToJson(
  _$SessionJoinResponseImpl instance,
) => <String, dynamic>{
  'status': instance.status,
  'used_credit': instance.usedCredit,
  'credit_balance_after': instance.creditBalanceAfter,
  'purchase_id': instance.purchaseId,
  'expires_at': instance.expiresAt?.toIso8601String(),
  'message': instance.message,
  'booking': instance.booking,
};

_$JoinBookingInfoImpl _$$JoinBookingInfoImplFromJson(
  Map<String, dynamic> json,
) => _$JoinBookingInfoImpl(
  id: idFromJson(json['id']),
  sessionId: idFromJson(json['session_id']),
  bookedAt: DateTime.parse(json['booked_at'] as String),
);

Map<String, dynamic> _$$JoinBookingInfoImplToJson(
  _$JoinBookingInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'booked_at': instance.bookedAt.toIso8601String(),
};
