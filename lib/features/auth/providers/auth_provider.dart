import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mock_auth_repository.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userKey = 'auth_user';
const _tokenKey = 'auth_token';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMockData) {
    return MockAuthRepository(config);
  }
  // TODO: return real API implementation
  return MockAuthRepository(config);
});

final authNotifierProvider =
    NotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    _restoreSession();
    return null;
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  void _restoreSession() {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
        state = user;
      } catch (_) {
        _prefs.remove(_userKey);
        _prefs.remove(_tokenKey);
      }
    }
  }

  Future<void> login(String email, String password) async {
    final (user, token) = await _repo.login(email, password);
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    _prefs.setString(_tokenKey, jsonEncode(token.toJson()));
    state = user;
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
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    _prefs.setString(_tokenKey, jsonEncode(token.toJson()));
    state = user;
  }

  Future<void> logout() async {
    await _repo.logout();
    _prefs.remove(_userKey);
    _prefs.remove(_tokenKey);
    state = null;
  }

  Future<void> checkAuth() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        state = User.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      } catch (_) {
        state = null;
      }
    }
  }
}
