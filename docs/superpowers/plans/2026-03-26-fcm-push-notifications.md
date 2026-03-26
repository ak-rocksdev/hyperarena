# FCM Push Notification Client Integration — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate Firebase Cloud Messaging into the HyperArena Flutter app so users receive push notifications from the Laravel backend, with foreground display, background tap navigation, and FCM token lifecycle tied to auth.

**Architecture:** Layered services following existing Riverpod provider patterns. `SecureStorageService` wraps encrypted storage with an in-memory cache. `ApiClient` wraps Dio with auth/tenant/locale interceptors. `PushNotificationService` manages FCM lifecycle and exposes a broadcast stream for UI. `NotificationRouteResolver` maps FCM `data.type` to GoRouter paths. Auth flow updated to register/cleanup FCM tokens on login/logout.

**Tech Stack:** Flutter, Riverpod, GoRouter, Dio, Freezed, firebase_core, firebase_messaging, flutter_local_notifications, flutter_secure_storage

**Spec:** `docs/superpowers/specs/2026-03-26-fcm-push-notifications-design.md`

---

## File Structure

### New Files

| File | Responsibility |
|---|---|
| `lib/core/storage/secure_storage_service.dart` | Encrypted token storage with in-memory cache |
| `lib/core/network/api_exceptions.dart` | Typed HTTP exception classes |
| `lib/core/network/api_interceptor.dart` | Dio interceptor for auth/tenant/locale headers |
| `lib/core/network/api_client.dart` | Dio wrapper with typed HTTP methods |
| `lib/shared/providers/network_providers.dart` | `apiClientProvider`, `tenantSlugProvider`, `localeProvider`, `pushNotificationServiceProvider` |
| `lib/features/notification/data/device_token_repository.dart` | Abstract interface for FCM token API |
| `lib/features/notification/data/api_device_token_repository.dart` | Real implementation using ApiClient |
| `lib/features/notification/data/mock_device_token_repository.dart` | No-op mock for dev mode |
| `lib/features/notification/utils/notification_route_resolver.dart` | FCM `data.type` → GoRouter path mapping |
| `lib/core/services/push_notification_service.dart` | FCM lifecycle, permissions, foreground/background handling |
| `lib/shared/widgets/in_app_notification_banner.dart` | Telegram-style overlay banner |
| `test/core/network/api_exceptions_test.dart` | Tests for exception classes |
| `test/features/notification/utils/notification_route_resolver_test.dart` | Tests for route resolver |
| `test/core/storage/secure_storage_service_test.dart` | Tests for secure storage |

### Modified Files

| File | Changes |
|---|---|
| `pubspec.yaml` | Add firebase_core, firebase_messaging, flutter_local_notifications, flutter_secure_storage |
| `lib/features/auth/data/models/auth_token.dart` | Simplify to `{ String token }` only |
| `lib/features/auth/data/auth_repository.dart` | Add optional `deviceToken` param to `logout()` |
| `lib/features/auth/data/mock_auth_repository.dart` | Update `_fakeToken()`, add `deviceToken` to `logout()` |
| `lib/features/auth/providers/auth_provider.dart` | Secure storage, FCM register on login/register, FCM cleanup on logout |
| `lib/features/notification/providers/notification_providers.dart` | Convert `unreadCountProvider` to `AsyncNotifierProvider`, add device token repo provider |
| `lib/shared/providers/app_config_provider.dart` | Add `secureStorageProvider` |
| `lib/app_bootstrap.dart` | Firebase init, background handler, secure storage warm-up |
| `lib/app.dart` | Subscribe to foreground message stream for banner display |

---

## Chunk 1: Foundation Layer

### Task 1: Add dependencies

**Files:**
- Modify: `pubspec.yaml:9-33`

- [ ] **Step 1: Add Firebase and storage dependencies to pubspec.yaml**

Add under `dependencies:` after `shared_preferences`:

```yaml
  # Firebase
  firebase_core: ^3.13.0
  firebase_messaging: ^15.2.5

  # Push Notifications
  flutter_local_notifications: ^18.0.1

  # Secure Storage
  flutter_secure_storage: ^9.2.4
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`
Expected: Dependencies resolve successfully, no version conflicts.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add firebase, push notification, and secure storage dependencies"
```

---

### Task 2: Create SecureStorageService

**Files:**
- Create: `lib/core/storage/secure_storage_service.dart`
- Create: `test/core/storage/secure_storage_service_test.dart`
- Modify: `lib/shared/providers/app_config_provider.dart:1-15`

- [ ] **Step 1: Write tests for SecureStorageService**

```dart
// test/core/storage/secure_storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

void main() {
  late SecureStorageService service;

  setUp(() {
    // Use a test-friendly instance (in-memory only, no FlutterSecureStorage)
    service = SecureStorageService.forTesting();
  });

  group('Bearer token', () {
    test('getToken returns null when empty', () {
      expect(service.getToken(), isNull);
    });

    test('saveToken updates cache synchronously', () async {
      await service.saveToken('bearer-123');
      expect(service.getToken(), equals('bearer-123'));
    });

    test('deleteToken clears cache', () async {
      await service.saveToken('bearer-123');
      await service.deleteToken();
      expect(service.getToken(), isNull);
    });
  });

  group('FCM token', () {
    test('getFcmToken returns null when empty', () {
      expect(service.getFcmToken(), isNull);
    });

    test('saveFcmToken updates cache synchronously', () async {
      await service.saveFcmToken('fcm-abc');
      expect(service.getFcmToken(), equals('fcm-abc'));
    });

    test('deleteFcmToken clears cache', () async {
      await service.saveFcmToken('fcm-abc');
      await service.deleteFcmToken();
      expect(service.getFcmToken(), isNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/storage/secure_storage_service_test.dart`
Expected: FAIL — `SecureStorageService` class does not exist.

- [ ] **Step 3: Implement SecureStorageService**

```dart
// lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _bearerTokenKey = 'bearer_token';
const _fcmTokenKey = 'fcm_token';

class SecureStorageService {
  final FlutterSecureStorage? _storage;
  String? _cachedToken;
  String? _cachedFcmToken;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  /// Test constructor — in-memory only, no encrypted storage.
  SecureStorageService.forTesting() : _storage = null;

  /// Pre-load tokens from encrypted storage into memory cache.
  /// Call once during bootstrap() before runApp().
  Future<void> warmUp() async {
    if (_storage == null) return;
    _cachedToken = await _storage.read(key: _bearerTokenKey);
    _cachedFcmToken = await _storage.read(key: _fcmTokenKey);
  }

  // ── Bearer token ──────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getToken() => _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage?.write(key: _bearerTokenKey, value: token);
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    await _storage?.delete(key: _bearerTokenKey);
  }

  // ── FCM token ─────────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getFcmToken() => _cachedFcmToken;

  Future<void> saveFcmToken(String token) async {
    _cachedFcmToken = token;
    await _storage?.write(key: _fcmTokenKey, value: token);
  }

  Future<void> deleteFcmToken() async {
    _cachedFcmToken = null;
    await _storage?.delete(key: _fcmTokenKey);
  }
}
```

- [ ] **Step 4: Add secureStorageProvider to app_config_provider.dart**

In `lib/shared/providers/app_config_provider.dart`:
- Add this import at the **top** of the file (with the other imports):

```dart
import 'package:hyperarena/core/storage/secure_storage_service.dart';
```

- Add this provider at the **end** of the file:

```dart
/// Provided via ProviderScope.overrides in bootstrap
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  throw UnimplementedError(
    'secureStorageProvider must be overridden at startup',
  );
});
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/core/storage/secure_storage_service_test.dart`
Expected: All 6 tests PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/core/storage/ lib/shared/providers/app_config_provider.dart test/core/storage/
git commit -m "feat: add SecureStorageService with in-memory cache and test constructor"
```

---

### Task 3: Create ApiExceptions

**Files:**
- Create: `lib/core/network/api_exceptions.dart`
- Create: `test/core/network/api_exceptions_test.dart`

- [ ] **Step 1: Write tests for ApiExceptions**

```dart
// test/core/network/api_exceptions_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';

void main() {
  test('UnauthorizedException has statusCode 401', () {
    final e = UnauthorizedException('Unauthenticated.');
    expect(e.statusCode, 401);
    expect(e.message, 'Unauthenticated.');
    expect(e.toString(), contains('401'));
  });

  test('ValidationException carries errors map', () {
    final e = ValidationException(
      'The email field is required.',
      errors: {'email': ['The email field is required.']},
    );
    expect(e.statusCode, 422);
    expect(e.errors['email'], isNotEmpty);
  });

  test('ForbiddenException has statusCode 403', () {
    final e = ForbiddenException('Forbidden.');
    expect(e.statusCode, 403);
  });

  test('NotFoundException has statusCode 404', () {
    final e = NotFoundException('Not found.');
    expect(e.statusCode, 404);
  });

  test('ServerException has statusCode 500', () {
    final e = ServerException('Internal server error.', statusCode: 502);
    expect(e.statusCode, 502);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/network/api_exceptions_test.dart`
Expected: FAIL — classes do not exist.

- [ ] **Step 3: Implement ApiExceptions**

```dart
// lib/core/network/api_exceptions.dart

sealed class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message) : super(message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message) : super(message, statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message) : super(message, statusCode: 404);
}

class ValidationException extends ApiException {
  final Map<String, List<dynamic>> errors;

  const ValidationException(
    String message, {
    this.errors = const {},
  }) : super(message, statusCode: 422);
}

class ServerException extends ApiException {
  const ServerException(String message, {int statusCode = 500})
      : super(message, statusCode: statusCode);
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/core/network/api_exceptions_test.dart`
Expected: All 5 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/network/api_exceptions.dart test/core/network/
git commit -m "feat: add typed API exception classes"
```

---

### Task 4: Create ApiInterceptor

**Files:**
- Create: `lib/core/network/api_interceptor.dart`

- [ ] **Step 1: Implement ApiInterceptor**

```dart
// lib/core/network/api_interceptor.dart
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/routing/app_routes.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final GoRouter _router;
  final String? _tenantSlug;
  final String _locale;

  bool _isRedirecting = false;

  ApiInterceptor({
    required SecureStorageService secureStorage,
    required GoRouter router,
    String? tenantSlug,
    String locale = 'id',
  })  : _secureStorage = secureStorage,
        _router = router,
        _tenantSlug = tenantSlug,
        _locale = locale;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Bearer token (from in-memory cache — synchronous)
    final token = _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Standard headers
    options.headers['X-Client-Type'] = 'mobile';
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = _locale;

    // Tenant slug (optional — null means skip)
    if (_tenantSlug != null) {
      options.headers['X-Tenant'] = _tenantSlug;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final message =
        data is Map<String, dynamic> ? data['message'] as String? ?? '' : '';

    switch (statusCode) {
      case 401:
        _handleUnauthorized();
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(message),
            response: err.response,
          ),
        );
      case 403:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ForbiddenException(message),
            response: err.response,
          ),
        );
      case 404:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NotFoundException(message),
            response: err.response,
          ),
        );
      case 422:
        final errors = data is Map<String, dynamic>
            ? (data['errors'] as Map<String, dynamic>?)
                    ?.map((k, v) => MapEntry(k, v as List<dynamic>)) ??
                {}
            : <String, List<dynamic>>{};
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ValidationException(message, errors: errors),
            response: err.response,
          ),
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(message, statusCode: statusCode),
              response: err.response,
            ),
          );
        } else {
          handler.next(err);
        }
    }
  }

  void _handleUnauthorized() {
    if (_isRedirecting) return;
    _isRedirecting = true;
    // Fire-and-forget — cache is cleared synchronously inside deleteToken(),
    // encrypted storage write is async but non-critical here.
    _secureStorage.deleteToken();
    _router.go(AppRoutes.login);
    // Reset after a short delay to allow navigation to complete
    Future.delayed(const Duration(seconds: 1), () => _isRedirecting = false);
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/network/api_interceptor.dart
git commit -m "feat: add Dio ApiInterceptor with auth, tenant, and locale headers"
```

---

### Task 5: Create ApiClient and network providers

**Files:**
- Create: `lib/core/network/api_client.dart`
- Create: `lib/shared/providers/network_providers.dart`

- [ ] **Step 1: Implement ApiClient**

```dart
// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/network/api_interceptor.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required AppConfig config,
    required SecureStorageService secureStorage,
    required GoRouter router,
    String? tenantSlug,
    String locale = 'id',
  }) : _dio = Dio(BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        )) {
    _dio.interceptors.add(
      ApiInterceptor(
        secureStorage: secureStorage,
        router: router,
        tenantSlug: tenantSlug,
        locale: locale,
      ),
    );
    if (config.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.post(path, data: data, queryParameters: queryParameters);

  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.put(path, data: data, queryParameters: queryParameters);

  Future<Response> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.patch(path, data: data, queryParameters: queryParameters);

  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.delete(path, data: data, queryParameters: queryParameters);
}
```

- [ ] **Step 2: Create network providers**

```dart
// lib/shared/providers/network_providers.dart
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
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/core/network/ lib/shared/providers/network_providers.dart`
Expected: No analysis errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/network/api_client.dart lib/shared/providers/network_providers.dart
git commit -m "feat: add ApiClient with Dio and network providers"
```

---

### Task 5.5: Run /simplify on Chunk 1

- [ ] **Step 1: Run /simplify**

Review all Chunk 1 files for reuse, quality, and efficiency:
- `lib/core/storage/secure_storage_service.dart`
- `lib/core/network/api_exceptions.dart`
- `lib/core/network/api_interceptor.dart`
- `lib/core/network/api_client.dart`
- `lib/shared/providers/network_providers.dart`
- `lib/shared/providers/app_config_provider.dart`

Fix any issues found.

---

## Chunk 2: Auth Refactoring

### Task 6: Simplify AuthToken model

**Files:**
- Modify: `lib/features/auth/data/models/auth_token.dart:1-16`

- [ ] **Step 1: Update AuthToken Freezed model**

Replace the entire file:

```dart
// lib/features/auth/data/models/auth_token.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String token,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}
```

- [ ] **Step 2: Regenerate Freezed files**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Build succeeds. `auth_token.freezed.dart` and `auth_token.g.dart` regenerated.

- [ ] **Step 3: Update MockAuthRepository._fakeToken()**

In `lib/features/auth/data/mock_auth_repository.dart:14-18`, replace:

```dart
  AuthToken _fakeToken() => AuthToken(
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock-refresh-token',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      );
```

With:

```dart
  AuthToken _fakeToken() => AuthToken(
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      );
```

- [ ] **Step 4: Verify compilation**

Run: `flutter analyze`
Expected: No analysis errors.

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/models/ lib/features/auth/data/mock_auth_repository.dart
git commit -m "refactor: simplify AuthToken to single token field"
```

---

### Task 7: Update AuthRepository interface

**Files:**
- Modify: `lib/features/auth/data/auth_repository.dart:12`
- Modify: `lib/features/auth/data/mock_auth_repository.dart:51-53`

- [ ] **Step 1: Add optional deviceToken param to logout()**

In `lib/features/auth/data/auth_repository.dart`, change line 12:

```dart
  Future<void> logout();
```

To:

```dart
  Future<void> logout({String? deviceToken});
```

- [ ] **Step 2: Update MockAuthRepository.logout()**

In `lib/features/auth/data/mock_auth_repository.dart`, change:

```dart
  @override
  Future<void> logout() async {
    await Future.delayed(config.mockDelay);
  }
```

To:

```dart
  @override
  Future<void> logout({String? deviceToken}) async {
    await Future.delayed(config.mockDelay);
  }
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/auth/data/auth_repository.dart lib/features/auth/data/mock_auth_repository.dart
git commit -m "feat: add optional deviceToken param to AuthRepository.logout()"
```

---

### Task 8: Update AuthNotifier for secure storage + migration

**Files:**
- Modify: `lib/features/auth/providers/auth_provider.dart:1-79`

- [ ] **Step 1: Rewrite AuthNotifier with secure storage and migration**

Replace the entire `lib/features/auth/providers/auth_provider.dart`:

```dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mock_auth_repository.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
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

  void _initializePushNotifications() {
    // Wired in Task 15 (Chunk 4) — placeholder for now.
    // Will call: pushNotificationService.initialize() + registerWithBackend()
  }
}
```

- [ ] **Step 2: Verify compilation**

Run: `flutter analyze lib/features/auth/`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/providers/auth_provider.dart
git commit -m "feat: update AuthNotifier with secure storage and legacy token migration"
```

---

### Task 8.5: Run /simplify on Chunk 2

- [ ] **Step 1: Run /simplify**

Review all Chunk 2 files:
- `lib/features/auth/data/models/auth_token.dart`
- `lib/features/auth/data/auth_repository.dart`
- `lib/features/auth/data/mock_auth_repository.dart`
- `lib/features/auth/providers/auth_provider.dart`

Fix any issues found.

---

## Chunk 3: FCM Services

### Task 9: Create DeviceTokenRepository

**Files:**
- Create: `lib/features/notification/data/device_token_repository.dart`
- Create: `lib/features/notification/data/api_device_token_repository.dart`
- Create: `lib/features/notification/data/mock_device_token_repository.dart`
- Modify: `lib/features/notification/providers/notification_providers.dart`

- [ ] **Step 1: Create DeviceTokenRepository interface**

```dart
// lib/features/notification/data/device_token_repository.dart

abstract class DeviceTokenRepository {
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  });

  Future<void> removeToken(String fcmToken);
}
```

- [ ] **Step 2: Create ApiDeviceTokenRepository**

```dart
// lib/features/notification/data/api_device_token_repository.dart
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';

class ApiDeviceTokenRepository implements DeviceTokenRepository {
  final ApiClient _apiClient;

  ApiDeviceTokenRepository(this._apiClient);

  @override
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await _apiClient.post('/v1/auth/device-token', data: {
      'token': fcmToken,
      'platform': platform,
      if (deviceName != null) 'device_name': deviceName,
    });
  }

  @override
  Future<void> removeToken(String fcmToken) async {
    await _apiClient.delete('/v1/auth/device-token', data: {
      'token': fcmToken,
    });
  }
}
```

- [ ] **Step 3: Create MockDeviceTokenRepository**

```dart
// lib/features/notification/data/mock_device_token_repository.dart
import 'dart:developer';

import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';

class MockDeviceTokenRepository implements DeviceTokenRepository {
  final AppConfig config;

  MockDeviceTokenRepository(this.config);

  @override
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await Future.delayed(config.mockDelay);
    log('MockDeviceTokenRepository.registerToken: $fcmToken ($platform)');
  }

  @override
  Future<void> removeToken(String fcmToken) async {
    await Future.delayed(config.mockDelay);
    log('MockDeviceTokenRepository.removeToken: $fcmToken');
  }
}
```

- [ ] **Step 4: Add device token provider + update unread count to AsyncNotifier**

Replace `lib/features/notification/providers/notification_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/notification/data/api_device_token_repository.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';
import 'package:hyperarena/features/notification/data/mock_device_token_repository.dart';
import 'package:hyperarena/features/notification/data/mock_notification_repository.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/data/notification_repository.dart';
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
  final config = ref.watch(appConfigProvider);
  if (config.useMockData) {
    return MockDeviceTokenRepository(config);
  }
  final apiClient = ref.watch(apiClientProvider);
  return ApiDeviceTokenRepository(apiClient);
});
```

- [ ] **Step 5: Fix any references to old unreadCountProvider type**

Search for `unreadCountProvider` across the codebase. Any widget reading `ref.watch(unreadCountProvider)` was already getting `AsyncValue<int>` from the `FutureProvider`, so the type is the same — `AsyncValue<int>`. No widget changes needed.

Run: `flutter analyze`
Expected: No errors.

- [ ] **Step 6: Commit**

```bash
git add lib/features/notification/data/device_token_repository.dart lib/features/notification/data/api_device_token_repository.dart lib/features/notification/data/mock_device_token_repository.dart lib/features/notification/providers/notification_providers.dart
git commit -m "feat: add DeviceTokenRepository and convert unreadCount to AsyncNotifier"
```

---

### Task 10: Create NotificationRouteResolver

**Files:**
- Create: `lib/features/notification/utils/notification_route_resolver.dart`
- Create: `test/features/notification/utils/notification_route_resolver_test.dart`

- [ ] **Step 1: Write tests for NotificationRouteResolver**

```dart
// test/features/notification/utils/notification_route_resolver_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';

void main() {
  late NotificationRouteResolver resolver;

  setUp(() => resolver = NotificationRouteResolver());

  test('booking_confirmed resolves to session route', () {
    final route = resolver.resolve('booking_confirmed', {'session_id': '42'});
    expect(route, '/session/42');
  });

  test('session_reminder resolves to session route', () {
    final route = resolver.resolve('session_reminder', {'session_id': '7'});
    expect(route, '/session/7');
  });

  test('progress_updated resolves to session route', () {
    final route = resolver.resolve('progress_updated', {'session_id': '15'});
    expect(route, '/session/15');
  });

  test('purchase_confirmed resolves to notifications', () {
    final route = resolver.resolve('purchase_confirmed', {});
    expect(route, '/notifications');
  });

  test('payout_approved resolves to organizer earnings', () {
    final route = resolver.resolve('payout_approved', {});
    expect(route, '/organizer/earnings');
  });

  test('payment_rejected resolves to notifications', () {
    final route = resolver.resolve('payment_rejected', {});
    expect(route, '/notifications');
  });

  test('unknown type returns null', () {
    final route = resolver.resolve('some_unknown_type', {});
    expect(route, isNull);
  });

  test('null type returns null', () {
    final route = resolver.resolve(null, {});
    expect(route, isNull);
  });

  test('session type with missing session_id returns null', () {
    final route = resolver.resolve('booking_confirmed', {});
    expect(route, isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/notification/utils/notification_route_resolver_test.dart`
Expected: FAIL — class does not exist.

- [ ] **Step 3: Implement NotificationRouteResolver**

```dart
// lib/features/notification/utils/notification_route_resolver.dart
import 'package:hyperarena/routing/app_routes.dart';

class NotificationRouteResolver {
  /// Resolves an FCM data.type + payload data to a GoRouter path.
  /// Returns null for unknown types or missing required data.
  String? resolve(String? type, Map<String, dynamic> data) {
    return switch (type) {
      'booking_confirmed' ||
      'session_reminder' ||
      'progress_updated' =>
        _sessionRoute(data),
      'purchase_confirmed' => AppRoutes.notifications,
      'payout_approved' => AppRoutes.organizerEarnings,
      'payment_rejected' => AppRoutes.notifications,
      _ => null,
    };
  }

  String? _sessionRoute(Map<String, dynamic> data) {
    final sessionId = data['session_id']?.toString();
    if (sessionId == null) return null;
    return AppRoutes.session(sessionId);
  }
}
```

- [ ] **Step 4: Add provider**

In `lib/features/notification/providers/notification_providers.dart`:
- Add this import at the **top** of the file (with the other imports):

```dart
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';
```

- Add this provider at the **bottom** of the file:

```dart
final notificationRouteResolverProvider =
    Provider<NotificationRouteResolver>((ref) {
  return NotificationRouteResolver();
});
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/notification/utils/notification_route_resolver_test.dart`
Expected: All 9 tests PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/features/notification/utils/ lib/features/notification/providers/notification_providers.dart test/features/notification/
git commit -m "feat: add NotificationRouteResolver with FCM type-to-route mapping"
```

---

### Task 11: Create PushNotificationService

**Files:**
- Create: `lib/core/services/push_notification_service.dart`

- [ ] **Step 1: Implement PushNotificationService**

```dart
// lib/core/services/push_notification_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:ui' show VoidCallback;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';

class PushNotificationService {
  final DeviceTokenRepository _deviceTokenRepository;
  final SecureStorageService _secureStorage;
  final NotificationRouteResolver _routeResolver;
  final GoRouter _router;
  final VoidCallback _onUnreadCountIncrement;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<RemoteMessage> _foregroundController =
      StreamController<RemoteMessage>.broadcast();

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;
  StreamSubscription<String>? _onTokenRefreshSub;

  bool _initialized = false;

  PushNotificationService({
    required DeviceTokenRepository deviceTokenRepository,
    required SecureStorageService secureStorage,
    required NotificationRouteResolver routeResolver,
    required GoRouter router,
    required VoidCallback onUnreadCountIncrement,
  })  : _deviceTokenRepository = deviceTokenRepository,
        _secureStorage = secureStorage,
        _routeResolver = routeResolver,
        _router = router,
        _onUnreadCountIncrement = onUnreadCountIncrement;

  /// Broadcast stream for foreground messages — UI subscribes for banners.
  Stream<RemoteMessage> get foregroundMessageStream =>
      _foregroundController.stream;

  /// Initialize FCM: request permission, setup channels and listeners.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Android notification channel
    await _setupLocalNotifications();

    // Request permission
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return; // Graceful degradation — app works without push
    }

    // Foreground message listener
    _onMessageSub = FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background tap listener
    _onMessageOpenedSub =
        FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    // Cold-start tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Delay slightly to ensure router is ready
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _onNotificationTap(initialMessage),
      );
    }
  }

  /// Register FCM token with backend and listen for refreshes.
  Future<void> registerWithBackend() async {
    try {
      final fcmToken = await _messaging.getToken();
      if (fcmToken == null) return;

      await _secureStorage.saveFcmToken(fcmToken);

      final platform = Platform.isIOS ? 'ios' : 'android';
      await _deviceTokenRepository.registerToken(
        fcmToken: fcmToken,
        platform: platform,
      );
    } catch (e) {
      // Fire-and-forget — log but don't block
    }

    // Cancel-and-replace token refresh listener
    await _onTokenRefreshSub?.cancel();
    _onTokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) async {
      try {
        await _secureStorage.saveFcmToken(newToken);
        final platform = Platform.isIOS ? 'ios' : 'android';
        await _deviceTokenRepository.registerToken(
          fcmToken: newToken,
          platform: platform,
        );
      } catch (_) {
        // Fire-and-forget
      }
    });
  }

  /// Remove FCM token from backend (called during logout).
  Future<void> removeFromBackend() async {
    final fcmToken = _secureStorage.getFcmToken();
    if (fcmToken != null) {
      try {
        await _deviceTokenRepository.removeToken(fcmToken);
      } catch (_) {
        // Best-effort
      }
    }
    await _onTokenRefreshSub?.cancel();
    _onTokenRefreshSub = null;
  }

  /// Clean up all subscriptions.
  void dispose() {
    _onMessageSub?.cancel();
    _onMessageOpenedSub?.cancel();
    _onTokenRefreshSub?.cancel();
    _foregroundController.close();
    _initialized = false;
  }

  // ── Private ───────────────────────────────────────────

  Future<void> _setupLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'hyperarena_notifications',
      'HyperArena Notifications',
      description: 'Push notifications from HyperArena',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        // Handle tap on local notification — payload contains the data.type info
        // This is for foreground notifications shown via flutter_local_notifications
      },
    );
  }

  void _onForegroundMessage(RemoteMessage message) {
    // 1. Show system notification
    _showSystemNotification(message);

    // 2. Push to broadcast stream (for in-app banner)
    _foregroundController.add(message);

    // 3. Increment unread count
    _onUnreadCountIncrement();
  }

  void _showSystemNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hyperarena_notifications',
          'HyperArena Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  void _onNotificationTap(RemoteMessage message) {
    final type = message.data['type'] as String?;
    final route = _routeResolver.resolve(type, message.data);
    if (route != null) {
      _router.go(route);
    }
  }
}
```

- [ ] **Step 2: Add push notification service provider**

Add to `lib/shared/providers/network_providers.dart`.

Note: The `onUnreadCountIncrement` callback uses `ref.read` (not `ref.watch`) inside a closure to avoid capturing a stale notifier reference. When `unreadCountProvider` is invalidated/rebuilt, the closure always reads the current notifier at call time.

```dart
import 'package:hyperarena/core/services/push_notification_service.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  final deviceTokenRepo = ref.watch(deviceTokenRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final routeResolver = ref.watch(notificationRouteResolverProvider);
  final router = ref.watch(appRouterProvider);
  final service = PushNotificationService(
    deviceTokenRepository: deviceTokenRepo,
    secureStorage: secureStorage,
    routeResolver: routeResolver,
    router: router,
    onUnreadCountIncrement: () =>
        ref.read(unreadCountProvider.notifier).increment(),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
```

**Note on imports:** `network_providers.dart` imports from `notification_providers.dart` for `deviceTokenRepositoryProvider`, `unreadCountProvider`, and `notificationRouteResolverProvider`. `notification_providers.dart` imports from `network_providers.dart` for `apiClientProvider`. Dart resolves circular file imports without error. The providers themselves have no circular runtime dependency — `apiClientProvider` does not depend on any notification provider, and notification providers depend on `apiClientProvider` only at construction time. This is acceptable for a shared provider layer.

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/core/services/ lib/shared/providers/network_providers.dart`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/services/push_notification_service.dart lib/shared/providers/network_providers.dart
git commit -m "feat: add PushNotificationService with FCM lifecycle management"
```

---

### Task 11.5: Run /simplify on Chunk 3

- [ ] **Step 1: Run /simplify**

Review all Chunk 3 files:
- `lib/features/notification/data/device_token_repository.dart`
- `lib/features/notification/data/api_device_token_repository.dart`
- `lib/features/notification/data/mock_device_token_repository.dart`
- `lib/features/notification/utils/notification_route_resolver.dart`
- `lib/features/notification/providers/notification_providers.dart`
- `lib/core/services/push_notification_service.dart`
- `lib/shared/providers/network_providers.dart`

Fix any issues found.

---

## Chunk 4: Firebase Init, Auth Wiring, and UI

### Task 12: Firebase initialization in bootstrap

**Files:**
- Modify: `lib/app_bootstrap.dart:1-28`

- [ ] **Step 1: Update bootstrap with Firebase init and secure storage warm-up**

Replace `lib/app_bootstrap.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/firebase_options.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/app.dart';

/// Top-level background message handler (Firebase requirement).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Firebase init (skip in mock mode — no Firebase config available)
  if (!config.useMockData) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  }

  final sharedPrefs = await SharedPreferences.getInstance();
  final secureStorage = SecureStorageService();
  await secureStorage.warmUp();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        secureStorageProvider.overrideWithValue(secureStorage),
      ],
      child: const HyperArenaApp(),
    ),
  );
}
```

- [ ] **Step 2: Verify compilation**

Run: `flutter analyze lib/app_bootstrap.dart`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/app_bootstrap.dart
git commit -m "feat: add Firebase init and secure storage warm-up to bootstrap"
```

---

### Task 13: Wire FCM into AuthNotifier

**Files:**
- Modify: `lib/features/auth/providers/auth_provider.dart`

- [ ] **Step 1: Update _initializePushNotifications() to call real service**

In `lib/features/auth/providers/auth_provider.dart`, replace the placeholder `_initializePushNotifications()`:

```dart
  void _initializePushNotifications() {
    // Wired in Task 15 (Chunk 4) — placeholder for now.
    // Will call: pushNotificationService.initialize() + registerWithBackend()
  }
```

With:

```dart
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
```

- [ ] **Step 2: Add imports**

Add at top of `lib/features/auth/providers/auth_provider.dart`:

```dart
import 'package:hyperarena/shared/providers/network_providers.dart';
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/features/auth/providers/auth_provider.dart`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/features/auth/providers/auth_provider.dart
git commit -m "feat: wire PushNotificationService into AuthNotifier login/register/logout"
```

---

### Task 14: Create In-App Notification Banner

**Files:**
- Create: `lib/shared/widgets/in_app_notification_banner.dart`

- [ ] **Step 1: Implement the banner widget**

```dart
// lib/shared/widgets/in_app_notification_banner.dart
import 'package:flutter/material.dart';

class InAppNotificationBanner extends StatefulWidget {
  final String title;
  final String body;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const InAppNotificationBanner({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<InAppNotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _dismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
          _dismiss();
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < 0) {
            _dismiss(); // Swipe up to dismiss
          }
        },
        child: SafeArea(
          bottom: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inverseSurface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.body,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onInverseSurface
                              .withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/shared/widgets/in_app_notification_banner.dart
git commit -m "feat: add Telegram-style in-app notification banner widget"
```

---

### Task 15: Subscribe to foreground messages in app shell

**Files:**
- Modify: `lib/app.dart:1-33`

- [ ] **Step 1: Replace app.dart with foreground message subscription**

Replace the entire `lib/app.dart`.

**Key design:** The banner subscription lives inside a `_ForegroundNotificationListener` widget placed via `MaterialApp.router`'s `builder` parameter. This ensures `Overlay.of(context)` works — the widget's context is inside the `MaterialApp`'s `Navigator`/`Overlay` tree. `HyperArenaApp` itself stays a `ConsumerWidget`.

```dart
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_theme.dart';
import 'package:hyperarena/core/theme/app_theme_dark.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';
import 'package:hyperarena/routing/app_router.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
import 'package:hyperarena/shared/widgets/in_app_notification_banner.dart';

class HyperArenaApp extends ConsumerWidget {
  const HyperArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'HyperArena',
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: AppTheme.light(),
      darkTheme: AppThemeDark.dark(),
      themeMode: ThemeMode.system,
      locale: const Locale('id'),
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return _ForegroundNotificationListener(
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
    );
  }
}

/// Subscribes to FCM foreground messages and displays in-app banners.
/// Lives inside the MaterialApp tree so Overlay.of(context) works.
class _ForegroundNotificationListener extends ConsumerStatefulWidget {
  final Widget child;

  const _ForegroundNotificationListener({required this.child});

  @override
  ConsumerState<_ForegroundNotificationListener> createState() =>
      _ForegroundNotificationListenerState();
}

class _ForegroundNotificationListenerState
    extends ConsumerState<_ForegroundNotificationListener> {
  StreamSubscription<RemoteMessage>? _foregroundSub;
  OverlayEntry? _currentBanner;
  final _routeResolver = NotificationRouteResolver();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _subscribe();
    });
  }

  void _subscribe() {
    final config = ref.read(appConfigProvider);
    if (config.useMockData) return;

    final pushService = ref.read(pushNotificationServiceProvider);
    _foregroundSub = pushService.foregroundMessageStream.listen(_showBanner);
  }

  void _showBanner(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _currentBanner?.remove();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: InAppNotificationBanner(
          title: notification.title ?? '',
          body: notification.body ?? '',
          onTap: () {
            final route =
                _routeResolver.resolve(message.data['type'], message.data);
            if (route != null) {
              ref.read(appRouterProvider).go(route);
            }
          },
          onDismiss: () {
            entry.remove();
            if (_currentBanner == entry) _currentBanner = null;
          },
        ),
      ),
    );

    _currentBanner = entry;
    Overlay.of(context).insert(entry);
  }

  @override
  void dispose() {
    _foregroundSub?.cancel();
    _currentBanner?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

- [ ] **Step 2: Verify app builds**

Run: `flutter analyze`
Expected: No errors.

Run: `flutter build apk --debug`
Expected: Build succeeds.

- [ ] **Step 3: Commit**

```bash
git add lib/app.dart
git commit -m "feat: subscribe to FCM foreground stream and display in-app banners"
```

---

### Task 15.5: Run /simplify on Chunk 4

- [ ] **Step 1: Run /simplify**

Review all Chunk 4 files:
- `lib/app_bootstrap.dart`
- `lib/features/auth/providers/auth_provider.dart`
- `lib/shared/widgets/in_app_notification_banner.dart`
- `lib/app.dart`

Fix any issues found.

---

### Task 16: Final verification

- [ ] **Step 1: Run all tests**

Run: `flutter test`
Expected: All tests pass.

- [ ] **Step 2: Run full static analysis**

Run: `flutter analyze`
Expected: No errors.

- [ ] **Step 3: Verify app builds**

Run: `flutter build apk --debug`
Expected: Build succeeds.

- [ ] **Step 4: Final commit (if any remaining changes)**

```bash
git add -A
git commit -m "chore: final cleanup for FCM push notification integration"
```
