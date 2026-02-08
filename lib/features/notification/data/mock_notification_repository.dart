import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/data/notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  final AppConfig config;

  MockNotificationRepository(this.config);

  @override
  Future<List<NotificationItem>> getNotifications({int limit = 50}) async {
    await Future.delayed(config.mockDelay);
    final items = MockData.notifications;
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items.take(limit).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(config.mockDelay);
    return MockData.notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(config.mockDelay);
    MockData.markNotificationRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(config.mockDelay);
    MockData.markAllNotificationsRead();
  }
}
