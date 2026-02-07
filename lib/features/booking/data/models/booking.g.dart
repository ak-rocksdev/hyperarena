// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      bookingType: $enumDecode(_$BookingTypeEnumMap, json['booking_type']),
      bookingCode: json['booking_code'] as String,
      playerId: json['player_id'] as String,
      venueId: json['venue_id'] as String?,
      courtId: json['court_id'] as String?,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      totalAmount: (json['total_amount'] as num).toInt(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      paymentMethod: $enumDecode(
        _$PaymentMethodTypeEnumMap,
        json['payment_method'],
      ),
      paymentProofUrl: json['payment_proof_url'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      venueName: json['venue_name'] as String?,
      courtName: json['court_name'] as String?,
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_type': _$BookingTypeEnumMap[instance.bookingType]!,
      'booking_code': instance.bookingCode,
      'player_id': instance.playerId,
      'venue_id': instance.venueId,
      'court_id': instance.courtId,
      'booking_date': instance.bookingDate.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'total_amount': instance.totalAmount,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'payment_method': _$PaymentMethodTypeEnumMap[instance.paymentMethod]!,
      'payment_proof_url': instance.paymentProofUrl,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'venue_name': instance.venueName,
      'court_name': instance.courtName,
    };

const _$BookingTypeEnumMap = {
  BookingType.court: 'court',
  BookingType.coaching: 'coaching',
  BookingType.openSession: 'openSession',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pendingPayment: 'pendingPayment',
  BookingStatus.waitingConfirmation: 'waitingConfirmation',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.rejected: 'rejected',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
  BookingStatus.expired: 'expired',
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.qris: 'qris',
  PaymentMethodType.bankTransfer: 'bankTransfer',
};
