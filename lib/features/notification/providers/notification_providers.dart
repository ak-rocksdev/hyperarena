import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/notification/data/api_device_token_repository.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';
import 'package:hyperarena/features/notification/data/mock_notification_repository.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/data/notification_repository.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return MockNotificationRepository(config);
});

final notificationListProvider =
    FutureProvider<List<NotificationItem>>((ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getNotifications();
});

// ── Unread count (AsyncNotifier for optimistic increment) ──

final unreadCountProvider =
    AsyncNotifierProvider<UnreadCountNotifier, int>(UnreadCountNotifier.new);

class UnreadCountNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() {
    final repo = ref.watch(notificationRepositoryProvider);
    return repo.getUnreadCount();
  }

  void increment() {
    final current = state.valueOrNull ?? 0;
    state = AsyncData(current + 1);
  }

  void refresh() => ref.invalidateSelf();
}

// ── Device token repository ──

final deviceTokenRepositoryProvider = Provider<DeviceTokenRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiDeviceTokenRepository(apiClient);
});

final notificationRouteResolverProvider =
    Provider<NotificationRouteResolver>((ref) {
  return NotificationRouteResolver();
});
