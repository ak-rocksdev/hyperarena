import 'package:hyperarena/features/notification/data/models/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications({int limit = 50});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}
