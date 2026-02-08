// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationItemImpl(
  id: json['id'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  isRead: json['is_read'] as bool? ?? false,
  actionRoute: json['action_route'] as String?,
  relatedId: json['related_id'] as String?,
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
  'is_read': instance.isRead,
  'action_route': instance.actionRoute,
  'related_id': instance.relatedId,
};

const _$NotificationTypeEnumMap = {
  NotificationType.paymentReminder: 'paymentReminder',
  NotificationType.sessionReminder: 'sessionReminder',
  NotificationType.reviewRequest: 'reviewRequest',
  NotificationType.assessmentReceived: 'assessmentReceived',
  NotificationType.bookingConfirmed: 'bookingConfirmed',
  NotificationType.sessionFull: 'sessionFull',
  NotificationType.badge: 'badge',
  NotificationType.general: 'general',
};
