// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_item.freezed.dart';
part 'notification_item.g.dart';

enum NotificationType {
  paymentReminder,
  sessionReminder,
  reviewRequest,
  assessmentReceived,
  bookingConfirmed,
  sessionFull,
  sessionCancelled,
  paymentConfirmed,
  paymentRejected,
  badge,
  general,
  // New (coach context)
  coachAssignedToSession,
  sessionScheduleChange,
  assessmentReminder,
}

@freezed
class NotificationItem with _$NotificationItem {
  const factory NotificationItem({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(false) bool isRead,
    String? actionRoute,
    String? relatedId,
    // Informational only — BE has already filtered the list by activeRole.
    // Defensive default 'all' so older clients survive missing field.
    @JsonKey(name: 'target_role') @Default('all') String targetRole,
  }) = _NotificationItem;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationItemFromJson(json);
}
