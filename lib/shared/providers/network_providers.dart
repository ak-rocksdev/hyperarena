import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/services/push_notification_service.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
import 'package:hyperarena/routing/app_router.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Provided via ProviderScope.overrides in bootstrap
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at startup',
  );
});

/// Provided via ProviderScope.overrides in bootstrap
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  throw UnimplementedError(
    'secureStorageProvider must be overridden at startup',
  );
});

final tenantSlugProvider = StateProvider<String?>((ref) => null);

final localeProvider = StateProvider<String>((ref) => 'id');

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final tenantSlug = ref.watch(tenantSlugProvider);
  final locale = ref.watch(localeProvider);
  return ApiClient(
    secureStorage: secureStorage,
    onUnauthorized: () => ref.read(appRouterProvider).go(AppRoutes.login),
    tenantSlug: tenantSlug,
    locale: locale,
  );
});

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  final deviceTokenRepo = ref.watch(deviceTokenRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final routeResolver = ref.watch(notificationRouteResolverProvider);
  final service = PushNotificationService(
    deviceTokenRepository: deviceTokenRepo,
    secureStorage: secureStorage,
    routeResolver: routeResolver,
    onNavigate: (route) => ref.read(appRouterProvider).go(route),
    onUnreadCountIncrement: () =>
        ref.read(unreadCountProvider.notifier).increment(),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
