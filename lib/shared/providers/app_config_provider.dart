import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

/// Provided via ProviderScope.overrides in bootstrap
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

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
