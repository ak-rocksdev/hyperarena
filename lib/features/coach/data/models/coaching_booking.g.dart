// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachingBookingImpl _$$CoachingBookingImplFromJson(
  Map<String, dynamic> json,
) => _$CoachingBookingImpl(
  id: json['id'] as String,
  coachId: json['coach_id'] as String,
  coachName: json['coach_name'] as String,
  playerId: json['player_id'] as String,
  playerName: json['player_name'] as String,
  packageId: json['package_id'] as String,
  packageName: json['package_name'] as String,
  sport: $enumDecode(_$SportEnumMap, json['sport']),
  date: DateTime.parse(json['date'] as String),
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  venueName: json['venue_name'] as String,
  amount: (json['amount'] as num).toInt(),
  status:
      $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
      BookingStatus.pendingPayment,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$CoachingBookingImplToJson(
  _$CoachingBookingImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'coach_id': instance.coachId,
  'coach_name': instance.coachName,
  'player_id': instance.playerId,
  'player_name': instance.playerName,
  'package_id': instance.packageId,
  'package_name': instance.packageName,
  'sport': _$SportEnumMap[instance.sport]!,
  'date': instance.date.toIso8601String(),
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'venue_name': instance.venueName,
  'amount': instance.amount,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$SportEnumMap = {
  Sport.tennis: 'tennis',
  Sport.padel: 'padel',
  Sport.badminton: 'badminton',
  Sport.futsal: 'futsal',
  Sport.basketball: 'basketball',
  Sport.volleyball: 'volleyball',
  Sport.tableTennis: 'tableTennis',
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
