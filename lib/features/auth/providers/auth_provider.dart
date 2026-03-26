import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mock_auth_repository.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userKey = 'auth_user';
const _legacyTokenKey = 'auth_token';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMockData) {
    return MockAuthRepository(config);
  }
  // Phase 5+: return real API implementation (ApiAuthRepository)
  return MockAuthRepository(config);
});

final authNotifierProvider =
    NotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
        // Fire-and-forget: migrate legacy token + init FCM
        _initializeAsyncServices();
        return user;
      } catch (_) {
        prefs.remove(_userKey);
        prefs.remove(_legacyTokenKey);
      }
    }
    return null;
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorageService get _secureStorage =>
      ref.read(secureStorageProvider);

  Future<void> login(String email, String password) async {
    final (user, token) = await _repo.login(email, password);
    await _secureStorage.saveToken(token.token);
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
    // Fire-and-forget: init FCM after login
    _initializePushNotifications();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final (user, token) = await _repo.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await _secureStorage.saveToken(token.token);
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
    // Fire-and-forget: init FCM after register
    _initializePushNotifications();
  }

  Future<void> logout() async {
    final fcmToken = _secureStorage.getFcmToken();
    try {
      await _repo.logout(deviceToken: fcmToken);
    } catch (_) {
      // Best-effort — proceed with local cleanup
    }
    await _secureStorage.deleteToken();
    await _secureStorage.deleteFcmToken();
    _prefs.remove(_userKey);
    _prefs.remove(_legacyTokenKey);
    state = null;
  }

  /// Migrate legacy SharedPreferences token → SecureStorage (one-time).
  Future<void> _migrateTokenIfNeeded() async {
    final legacyJson = _prefs.getString(_legacyTokenKey);
    if (legacyJson == null) return;

    try {
      final decoded = jsonDecode(legacyJson) as Map<String, dynamic>;
      final token = decoded['token'] as String?;
      if (token != null && _secureStorage.getToken() == null) {
        await _secureStorage.saveToken(token);
      }
    } catch (_) {
      // Corrupt data — treat as logged out
    }
    _prefs.remove(_legacyTokenKey);
  }

  Future<void> _initializeAsyncServices() async {
    await _migrateTokenIfNeeded();
    _initializePushNotifications();
  }

  Future<void> _initializePushNotifications() async {
    final config = ref.read(appConfigProvider);
    if (config.useMockData) return; // No Firebase in mock mode

    try {
      final pushService = ref.read(pushNotificationServiceProvider);
      await pushService.initialize();
      pushService.registerWithBackend(); // fire-and-forget
    } catch (_) {
      // Firebase not available — graceful degradation
    }
  }
}
