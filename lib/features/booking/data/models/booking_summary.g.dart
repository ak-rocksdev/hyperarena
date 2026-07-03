// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingSummaryImpl _$$BookingSummaryImplFromJson(Map<String, dynamic> json) =>
    _$BookingSummaryImpl(
      court: json['court'] == null
          ? null
          : Court.fromJson(json['court'] as Map<String, dynamic>),
      venue: json['venue'] == null
          ? null
          : Venue.fromJson(json['venue'] as Map<String, dynamic>),
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => CourtSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
      paymentMethod: $enumDecodeNullable(
        _$PaymentMethodTypeEnumMap,
        json['payment_method'],
      ),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$BookingSummaryImplToJson(
  _$BookingSummaryImpl instance,
) => <String, dynamic>{
  'court': instance.court,
  'venue': instance.venue,
  'date': instance.date?.toIso8601String(),
  'slots': instance.slots,
  'total_amount': instance.totalAmount,
  'payment_method': _$PaymentMethodTypeEnumMap[instance.paymentMethod],
  'expires_at': instance.expiresAt?.toIso8601String(),
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.qris: 'qris',
  PaymentMethodType.bankTransfer: 'bankTransfer',
};
