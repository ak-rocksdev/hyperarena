// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionParticipantImpl _$$SessionParticipantImplFromJson(
  Map<String, dynamic> json,
) => _$SessionParticipantImpl(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  playerId: json['player_id'] as String,
  playerName: json['player_name'] as String,
  bookingId: json['booking_id'] as String?,
  status:
      $enumDecodeNullable(_$SessionParticipantStatusEnumMap, json['status']) ??
      SessionParticipantStatus.pendingPayment,
  paymentMethod:
      $enumDecodeNullable(_$PaymentMethodTypeEnumMap, json['payment_method']) ??
      PaymentMethodType.qris,
  paidAmount: (json['paid_amount'] as num?)?.toInt() ?? 0,
  paidAt: json['paid_at'] == null
      ? null
      : DateTime.parse(json['paid_at'] as String),
  confirmedAt: json['confirmed_at'] == null
      ? null
      : DateTime.parse(json['confirmed_at'] as String),
  note: json['note'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  refundReason: json['refund_reason'] as String?,
  disputeReason: json['dispute_reason'] as String?,
  evidenceUrl: json['evidence_url'] as String?,
  joinedAt: DateTime.parse(json['joined_at'] as String),
);

Map<String, dynamic> _$$SessionParticipantImplToJson(
  _$SessionParticipantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'player_id': instance.playerId,
  'player_name': instance.playerName,
  'booking_id': instance.bookingId,
  'status': _$SessionParticipantStatusEnumMap[instance.status]!,
  'payment_method': _$PaymentMethodTypeEnumMap[instance.paymentMethod]!,
  'paid_amount': instance.paidAmount,
  'paid_at': instance.paidAt?.toIso8601String(),
  'confirmed_at': instance.confirmedAt?.toIso8601String(),
  'note': instance.note,
  'rejection_reason': instance.rejectionReason,
  'refund_reason': instance.refundReason,
  'dispute_reason': instance.disputeReason,
  'evidence_url': instance.evidenceUrl,
  'joined_at': instance.joinedAt.toIso8601String(),
};

const _$SessionParticipantStatusEnumMap = {
  SessionParticipantStatus.pendingPayment: 'pendingPayment',
  SessionParticipantStatus.confirmed: 'confirmed',
  SessionParticipantStatus.rejected: 'rejected',
  SessionParticipantStatus.cancelledByPlayer: 'cancelledByPlayer',
  SessionParticipantStatus.refunded: 'refunded',
  SessionParticipantStatus.noShow: 'noShow',
  SessionParticipantStatus.disputed: 'disputed',
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.qris: 'qris',
  PaymentMethodType.bankTransfer: 'bankTransfer',
};
