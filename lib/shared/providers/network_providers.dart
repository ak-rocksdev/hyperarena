import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/routing/app_router.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

final tenantSlugProvider = StateProvider<String?>((ref) => null);

final localeProvider = StateProvider<String>((ref) => 'id');

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final router = ref.watch(appRouterProvider);
  final tenantSlug = ref.watch(tenantSlugProvider);
  final locale = ref.watch(localeProvider);
  return ApiClient(
    config: config,
    secureStorage: secureStorage,
    router: router,
    tenantSlug: tenantSlug,
    locale: locale,
  );
});
