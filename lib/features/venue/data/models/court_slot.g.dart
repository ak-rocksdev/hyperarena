// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourtSlotImpl _$$CourtSlotImplFromJson(Map<String, dynamic> json) =>
    _$CourtSlotImpl(
      id: json['id'] as String,
      courtId: json['court_id'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      price: (json['price'] as num).toInt(),
      isPeak: json['is_peak'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
    );

Map<String, dynamic> _$$CourtSlotImplToJson(_$CourtSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'court_id': instance.courtId,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'price': instance.price,
      'is_peak': instance.isPeak,
      'is_available': instance.isAvailable,
    };
