import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_env.dart';
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

/// Defaults to `AppEnv.defaultTenantSlug` for the single-tenant world.
/// On login, `auth_provider` overwrites with the user's actual tenant
/// from the API response. When multi-tenant lands, default to `null` and
/// surface the tenant picker before `apiClientProvider` builds.
final tenantSlugProvider =
    StateProvider<String?>((ref) => AppEnv.defaultTenantSlug);

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
    onUnreadCountIncrement: () {
      // Bell badge updates optimistically; also invalidate the list so the
      // next open shows the freshly-arrived item instead of stale cache.
      ref.read(unreadCountProvider.notifier).increment();
      ref.invalidate(notificationListProvider);
    },
  );
  ref.onDispose(() => service.dispose());
  return service;
});
