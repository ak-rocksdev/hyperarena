// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayoutRequestImpl _$$PayoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$PayoutRequestImpl(
      id: (json['id'] as num).toInt(),
      period: json['period'] as String,
      totalAmountCents: (json['total_amount_cents'] as num).toInt(),
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      processedAt: json['processed_at'] == null
          ? null
          : DateTime.parse(json['processed_at'] as String),
      rejectionNote: json['rejection_note'] as String?,
      payouts:
          (json['payouts'] as List<dynamic>?)
              ?.map((e) => CoachPayout.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      processedBy: json['processed_by'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PayoutRequestImplToJson(_$PayoutRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'total_amount_cents': instance.totalAmountCents,
      'status': instance.status,
      'requested_at': instance.requestedAt.toIso8601String(),
      'processed_at': instance.processedAt?.toIso8601String(),
      'rejection_note': instance.rejectionNote,
      'payouts': instance.payouts,
      'processed_by': instance.processedBy,
    };
