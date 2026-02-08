import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/notification/data/mock_notification_repository.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/data/notification_repository.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return MockNotificationRepository(config);
});

final notificationListProvider =
    FutureProvider<List<NotificationItem>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount();
});
