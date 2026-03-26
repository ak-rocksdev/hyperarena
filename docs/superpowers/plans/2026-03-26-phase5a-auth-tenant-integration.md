# Phase 5A: Auth + Tenant Integration — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the mock auth flow with real Laravel API calls, persist sessions via SecureStorage, and inject tenant context into all subsequent requests.

**Architecture:** Create `ApiAuthRepository` using the existing `ApiClient`/Dio wrapper. Extract tenant slug from the login response and persist it in `SecureStorageService`. The `tenantSlugProvider` feeds the slug into `ApiInterceptor` which adds the `X-Tenant` header. Super-admins (no tenant) see a tenant picker screen before accessing the app.

**Tech Stack:** Flutter, Riverpod 2.6.1, Dio 5.7.0, GoRouter 14.8.1, Freezed 2.5.8, flutter_secure_storage 9.2.4

**Spec:** `docs/superpowers/specs/2026-03-26-phase5a-auth-tenant-integration-design.md`

---

**Note:** `lib/app_bootstrap.dart` does NOT need changes. Tenant slug restoration happens inside `AuthNotifier.build()` (Task 7), which reads from the `SecureStorageService` cache that `warmUp()` already populates during bootstrap.

---

## Chunk 1: Core Infrastructure (Tasks 1–4)

### Task 1: Role Mapper

**Files:**
- Create: `lib/features/auth/data/mappers/role_mapper.dart`
- Create: `test/features/auth/data/mappers/role_mapper_test.dart`

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/auth/data/mappers/role_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';

void main() {
  group('mapBackendRole', () {
    test('maps "member" to player', () {
      expect(mapBackendRole('member'), UserRole.player);
    });

    test('maps "coach" to coach', () {
      expect(mapBackendRole('coach'), UserRole.coach);
    });

    test('maps "admin" to organizer', () {
      expect(mapBackendRole('admin'), UserRole.organizer);
    });

    test('maps "super-admin" to organizer', () {
      expect(mapBackendRole('super-admin'), UserRole.organizer);
    });

    test('maps null to player (safe default)', () {
      expect(mapBackendRole(null), UserRole.player);
    });

    test('maps unknown string to player (safe default)', () {
      expect(mapBackendRole('unknown-role'), UserRole.player);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/auth/data/mappers/role_mapper_test.dart`
Expected: FAIL — cannot find `role_mapper.dart`

- [ ] **Step 3: Write the implementation**

```dart
// lib/features/auth/data/mappers/role_mapper.dart
import 'package:hyperarena/core/theme/app_enums.dart';

/// Maps the backend `active_role` string to the Flutter [UserRole] enum.
///
/// The backend has no `tenant.type` column, so mapping is based
/// solely on the role string.
UserRole mapBackendRole(String? activeRole) {
  return switch (activeRole) {
    'member' => UserRole.player,
    'coach' => UserRole.coach,
    'admin' => UserRole.organizer,
    'super-admin' => UserRole.organizer,
    _ => UserRole.player,
  };
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/auth/data/mappers/role_mapper_test.dart`
Expected: All 6 tests PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/mappers/role_mapper.dart test/features/auth/data/mappers/role_mapper_test.dart
git commit -m "feat: add role mapper for backend active_role → Flutter UserRole"
```

---

### Task 2: User Model Extensions

**Files:**
- Modify: `lib/features/auth/data/models/user.dart`
- Regenerate: `lib/features/auth/data/models/user.freezed.dart`
- Regenerate: `lib/features/auth/data/models/user.g.dart`

- [ ] **Step 1: Update the User model**

Edit `lib/features/auth/data/models/user.dart` to add tenant fields. The full file should be:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    required UserRole role,
    @Default(false) bool isVerified,
    int? tenantId,
    String? tenantSlug,
    String? tenantName,
    String? activeRole,
    String? locale,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

- [ ] **Step 2: Regenerate Freezed files**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Regenerates `user.freezed.dart` and `user.g.dart` successfully

- [ ] **Step 3: Run role mapper tests to verify nothing broke**

Run: `flutter test test/features/auth/data/mappers/role_mapper_test.dart`
Expected: All 6 tests still PASS

- [ ] **Step 4: Run full test suite to check nothing broke**

Run: `flutter test`
Expected: All existing tests still pass (mock code doesn't use the new nullable fields)

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/models/user.dart lib/features/auth/data/models/user.freezed.dart lib/features/auth/data/models/user.g.dart
git commit -m "feat: extend User model with tenant and role fields"
```

---

### Task 3: Auth Response Mapper

**Files:**
- Create: `lib/features/auth/data/mappers/auth_response_mapper.dart`
- Create: `test/features/auth/data/mappers/auth_response_mapper_test.dart`

**Context:** The login response from `POST /v1/auth/login` looks like:
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "+628123456789",
    "locale": "en",
    "active_role": "member",
    "tenant_id": 1,
    "photo_path": "users/1/photo.jpg",
    "roles": [...],
    "permissions": [...],
    "tenant": {
      "id": 1,
      "name": "Joseph Skate School",
      "slug": "josephskate",
      "sport": { "id": 1, "name": "Skating" }
    },
    "student_account": null,
    "student_guardians": [...]
  },
  "token": "1|abc123def456..."
}
```

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/auth/data/mappers/auth_response_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';

void main() {
  group('parseLoginResponse', () {
    test('parses user and token from login response', () {
      final json = {
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '+628123456789',
          'locale': 'en',
          'active_role': 'member',
          'tenant_id': 1,
          'photo_path': 'users/1/photo.jpg',
          'roles': [{'name': 'member'}],
          'permissions': [{'name': 'view-sessions'}],
          'tenant': {
            'id': 1,
            'name': 'Skate School',
            'slug': 'skateschool',
            'sport': {'id': 1, 'name': 'Skating'},
          },
          'student_account': null,
          'student_guardians': [],
        },
        'token': '1|abc123',
      };

      final (user, token) = parseLoginResponse(json);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '+628123456789');
      expect(user.role, UserRole.player);
      expect(user.activeRole, 'member');
      expect(user.tenantId, 1);
      expect(user.tenantSlug, 'skateschool');
      expect(user.tenantName, 'Skate School');
      expect(user.locale, 'en');
      expect(token.token, '1|abc123');
    });

    test('handles super-admin with null tenant', () {
      final json = {
        'user': {
          'id': 99,
          'name': 'Super Admin',
          'email': 'admin@hypercoach.com',
          'phone': null,
          'locale': 'en',
          'active_role': 'super-admin',
          'tenant_id': null,
          'photo_path': null,
          'roles': [{'name': 'super-admin'}],
          'permissions': [],
          'tenant': null,
          'student_account': null,
          'student_guardians': [],
        },
        'token': '2|xyz789',
      };

      final (user, token) = parseLoginResponse(json);

      expect(user.id, '99');
      expect(user.role, UserRole.organizer);
      expect(user.activeRole, 'super-admin');
      expect(user.tenantId, isNull);
      expect(user.tenantSlug, isNull);
      expect(user.tenantName, isNull);
      expect(token.token, '2|xyz789');
    });
  });

  group('parseUserResponse', () {
    test('parses user from /auth/me response', () {
      final json = {
        'id': 5,
        'name': 'Coach Mike',
        'email': 'mike@example.com',
        'phone': '+628111222333',
        'locale': 'id',
        'active_role': 'coach',
        'tenant_id': 2,
        'photo_path': null,
        'roles': [{'name': 'coach'}],
        'permissions': [],
        'tenant': {
          'id': 2,
          'name': 'Tennis Club',
          'slug': 'tennisclub',
          'sport': {'id': 2, 'name': 'Tennis'},
        },
        'student_account': null,
        'student_guardians': [],
      };

      final user = parseUserResponse(json);

      expect(user.id, '5');
      expect(user.name, 'Coach Mike');
      expect(user.role, UserRole.coach);
      expect(user.activeRole, 'coach');
      expect(user.tenantSlug, 'tennisclub');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/auth/data/mappers/auth_response_mapper_test.dart`
Expected: FAIL — cannot find `auth_response_mapper.dart`

- [ ] **Step 3: Write the implementation**

```dart
// lib/features/auth/data/mappers/auth_response_mapper.dart
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

/// Parses the login/register response JSON into a [User] and [AuthToken].
///
/// Expected JSON shape:
/// ```json
/// { "user": { ... }, "token": "1|abc..." }
/// ```
(User, AuthToken) parseLoginResponse(Map<String, dynamic> json) {
  final userJson = json['user'] as Map<String, dynamic>;
  final tokenStr = json['token'] as String;

  return (
    _parseUser(userJson),
    AuthToken(token: tokenStr),
  );
}

/// Parses the user object from `GET /v1/auth/me`.
///
/// The /me endpoint returns the user object directly (not wrapped).
User parseUserResponse(Map<String, dynamic> json) {
  return _parseUser(json);
}

User _parseUser(Map<String, dynamic> json) {
  final tenant = json['tenant'] as Map<String, dynamic>?;
  final activeRole = json['active_role'] as String?;

  return User(
    id: json['id'].toString(),
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String?,
    avatarUrl: json['photo_path'] as String?,
    role: mapBackendRole(activeRole),
    activeRole: activeRole,
    tenantId: json['tenant_id'] as int?,
    tenantSlug: tenant?['slug'] as String?,
    tenantName: tenant?['name'] as String?,
    locale: json['locale'] as String?,
  );
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/auth/data/mappers/`
Expected: All 9 tests PASS (6 role mapper + 3 auth response mapper)

- [ ] **Step 5: Commit**

```bash
git add lib/features/auth/data/mappers/auth_response_mapper.dart test/features/auth/data/mappers/auth_response_mapper_test.dart
git commit -m "feat: add auth response mapper for login/me API parsing"
```

---

### Task 4: SecureStorageService — Tenant Slug

**Files:**
- Modify: `lib/core/storage/secure_storage_service.dart`
- Modify: `test/core/storage/secure_storage_service_test.dart`

- [ ] **Step 1: Add tenant slug tests to existing test file**

Append this group to the end of `test/core/storage/secure_storage_service_test.dart`, inside `main()`:

```dart
  group('Tenant slug', () {
    test('getTenantSlug returns null when empty', () {
      expect(service.getTenantSlug(), isNull);
    });

    test('saveTenantSlug updates cache synchronously', () async {
      await service.saveTenantSlug('skateschool');
      expect(service.getTenantSlug(), equals('skateschool'));
    });

    test('deleteTenantSlug clears cache', () async {
      await service.saveTenantSlug('skateschool');
      await service.deleteTenantSlug();
      expect(service.getTenantSlug(), isNull);
    });
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/core/storage/secure_storage_service_test.dart`
Expected: FAIL — `getTenantSlug` method not found

- [ ] **Step 3: Add tenant slug methods to SecureStorageService**

Edit `lib/core/storage/secure_storage_service.dart`. Add after the `_fcmTokenKey` constant:

```dart
const _tenantSlugKey = 'tenant_slug';
```

Add a field after `_cachedFcmToken`:

```dart
  String? _cachedTenantSlug;
```

Update `warmUp()` to load tenant slug in parallel:

```dart
  Future<void> warmUp() async {
    if (_storage == null) return;
    final results = await Future.wait([
      _storage.read(key: _bearerTokenKey),
      _storage.read(key: _fcmTokenKey),
      _storage.read(key: _tenantSlugKey),
    ]);
    _cachedToken = results[0];
    _cachedFcmToken = results[1];
    _cachedTenantSlug = results[2];
  }
```

Add a new section after the FCM token section:

```dart
  // ── Tenant slug ─────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getTenantSlug() => _cachedTenantSlug;

  Future<void> saveTenantSlug(String slug) async {
    _cachedTenantSlug = slug;
    await _storage?.write(key: _tenantSlugKey, value: slug);
  }

  Future<void> deleteTenantSlug() async {
    _cachedTenantSlug = null;
    await _storage?.delete(key: _tenantSlugKey);
  }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/core/storage/secure_storage_service_test.dart`
Expected: All 9 tests PASS (6 existing + 3 new)

- [ ] **Step 5: Commit**

```bash
git add lib/core/storage/secure_storage_service.dart test/core/storage/secure_storage_service_test.dart
git commit -m "feat: add tenant slug persistence to SecureStorageService"
```

---

## Chunk 2: ApiAuthRepository + Provider Wiring (Tasks 5–7)

### Task 5: ApiAuthRepository

**Files:**
- Create: `lib/features/auth/data/api_auth_repository.dart`

**Context:**
- Follows the same pattern as `lib/features/notification/data/api_device_token_repository.dart`
- `ApiClient` base URL already includes `/api` (e.g., `https://dev-api.hyperarena.id/api`), so paths are `/v1/...`
- Login does NOT require `X-Tenant` header
- Invalid credentials return HTTP 422 (`ValidationException`), not 401

**Prerequisite:** The `X-Device-Name` header (used by Laravel Sanctum to name tokens) should be added as a static header on `ApiClient`'s `BaseOptions`. In `lib/core/network/api_client.dart`, add to the headers map in the constructor:

```dart
          headers: {
            'X-Client-Type': 'mobile',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Device-Name': 'HyperArena Mobile',
          },
```

This is a one-line change. A more detailed device name (via `device_info_plus`) can be added later.

- [ ] **Step 1: Add X-Device-Name header to ApiClient**

Edit `lib/core/network/api_client.dart`, add `'X-Device-Name': 'HyperArena Mobile'` to the `headers` map in `BaseOptions` (after line 23).

- [ ] **Step 2: Create ApiAuthRepository**

```dart
// lib/features/auth/data/api_auth_repository.dart
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  ApiAuthRepository(this._apiClient);

  @override
  Future<(User, AuthToken)> login(String email, String password) async {
    final response = await _apiClient.post('/v1/auth/login', data: {
      'email': email,
      'password': password,
    });
    return parseLoginResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    // Deferred — registration requires tenant context (marketplace sub-project)
    throw UnimplementedError(
      'Registration is not yet available. Coming soon.',
    );
  }

  @override
  Future<void> logout({String? deviceToken}) async {
    await _apiClient.post('/v1/auth/logout', data: {
      if (deviceToken != null) 'device_token': deviceToken,
    });
  }

  @override
  Future<User?> getCurrentUser() async {
    final response = await _apiClient.get('/v1/auth/me');
    final data = response.data as Map<String, dynamic>;
    // The /me endpoint may wrap user in a 'user' key or return directly
    final userJson = data.containsKey('user')
        ? data['user'] as Map<String, dynamic>
        : data;
    return parseUserResponse(userJson);
  }
}
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/features/auth/data/api_auth_repository.dart lib/core/network/api_client.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/auth/data/api_auth_repository.dart lib/core/network/api_client.dart
git commit -m "feat: add ApiAuthRepository with login/logout/me and X-Device-Name header"
```

---

### Task 6: Provider Wiring — Auth Repository Switch

**Files:**
- Modify: `lib/features/auth/providers/auth_provider.dart`

- [ ] **Step 1: Update authRepositoryProvider to switch on config**

In `lib/features/auth/providers/auth_provider.dart`, add the import:

```dart
import 'package:hyperarena/features/auth/data/api_auth_repository.dart';
```

Replace the `authRepositoryProvider` definition (lines 15–22):

```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.useMockData) {
    return MockAuthRepository(config);
  }
  final apiClient = ref.watch(apiClientProvider);
  return ApiAuthRepository(apiClient);
});
```

- [ ] **Step 2: Verify compilation**

Run: `flutter analyze lib/features/auth/providers/auth_provider.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/providers/auth_provider.dart
git commit -m "feat: wire authRepositoryProvider to ApiAuthRepository in non-mock mode"
```

---

### Task 7: AuthNotifier — Tenant Slug Persistence

**Files:**
- Modify: `lib/features/auth/providers/auth_provider.dart`

- [ ] **Step 1: Update login() to persist tenant slug**

In the `AuthNotifier` class, update the `login` method. Replace the existing method (lines 53–60):

```dart
  Future<void> login(String email, String password) async {
    final (user, token) = await _repo.login(email, password);
    await _secureStorage.saveToken(token.token);
    // Persist tenant slug for X-Tenant header
    if (user.tenantSlug != null) {
      await _secureStorage.saveTenantSlug(user.tenantSlug!);
      ref.read(tenantSlugProvider.notifier).state = user.tenantSlug;
    }
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
    _initializePushNotifications();
  }
```

- [ ] **Step 2: Update logout() to clear tenant slug**

Replace the existing `logout` method (lines 81–93):

```dart
  Future<void> logout() async {
    final fcmToken = _secureStorage.getFcmToken();
    try {
      await _repo.logout(deviceToken: fcmToken);
    } catch (_) {
      // Best-effort — proceed with local cleanup
    }
    await _secureStorage.deleteToken();
    await _secureStorage.deleteFcmToken();
    await _secureStorage.deleteTenantSlug();
    ref.read(tenantSlugProvider.notifier).state = null;
    _prefs.remove(_userKey);
    _prefs.remove(_legacyTokenKey);
    state = null;
  }
```

- [ ] **Step 3: Update build() to restore tenant slug on app restart**

In the `build()` method, after the user is restored from SharedPreferences (inside the `try` block, after `final user = User.fromJson(...)`), add tenant slug restoration:

```dart
        final user = User.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
        // Restore tenant slug from secure storage cache
        final slug = _secureStorage.getTenantSlug();
        if (slug != null) {
          ref.read(tenantSlugProvider.notifier).state = slug;
        }
        _initializeAsyncServices();
        return user;
```

- [ ] **Step 4: Verify compilation**

Run: `flutter analyze lib/features/auth/providers/auth_provider.dart`
Expected: No errors

- [ ] **Step 5: Run existing tests**

Run: `flutter test`
Expected: All tests pass (mock mode still works, new fields are nullable)

- [ ] **Step 6: Commit**

```bash
git add lib/features/auth/providers/auth_provider.dart
git commit -m "feat: persist and restore tenant slug in AuthNotifier"
```

---

## Chunk 3: Super-Admin Tenant Picker (Tasks 8–10)

### Task 8: TenantSummary Model + TenantRepository

**Files:**
- Create: `lib/features/auth/data/models/tenant_summary.dart`
- Create: `lib/features/auth/data/tenant_repository.dart`
- Create: `lib/features/auth/data/api_tenant_repository.dart`

- [ ] **Step 1: Create TenantSummary Freezed model**

```dart
// lib/features/auth/data/models/tenant_summary.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_summary.freezed.dart';
part 'tenant_summary.g.dart';

@freezed
class TenantSummary with _$TenantSummary {
  const factory TenantSummary({
    required int id,
    required String name,
    required String slug,
    String? logoUrl,
  }) = _TenantSummary;

  factory TenantSummary.fromJson(Map<String, dynamic> json) =>
      _$TenantSummaryFromJson(json);
}
```

- [ ] **Step 2: Create TenantRepository interface**

```dart
// lib/features/auth/data/tenant_repository.dart
import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';

abstract class TenantRepository {
  Future<List<TenantSummary>> getTenants({String? search});
}
```

- [ ] **Step 3: Create ApiTenantRepository**

```dart
// lib/features/auth/data/api_tenant_repository.dart
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';
import 'package:hyperarena/features/auth/data/tenant_repository.dart';

class ApiTenantRepository implements TenantRepository {
  final ApiClient _apiClient;

  ApiTenantRepository(this._apiClient);

  @override
  Future<List<TenantSummary>> getTenants({String? search}) async {
    final response = await _apiClient.get('/v1/platform/tenants',
        queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
    });
    final data = response.data as Map<String, dynamic>;
    final items = data['data'] as List<dynamic>;
    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final logoUrls = json['logo_urls'] as Map<String, dynamic>?;
      return TenantSummary(
        id: json['id'] as int,
        name: json['name'] as String,
        slug: json['slug'] as String,
        logoUrl: logoUrls?['md'] as String?,
      );
    }).toList();
  }
}
```

- [ ] **Step 4: Run code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generates `tenant_summary.freezed.dart` and `tenant_summary.g.dart`

- [ ] **Step 5: Verify compilation**

Run: `flutter analyze lib/features/auth/data/`
Expected: No errors

- [ ] **Step 6: Commit**

```bash
git add lib/features/auth/data/models/tenant_summary.dart lib/features/auth/data/models/tenant_summary.freezed.dart lib/features/auth/data/models/tenant_summary.g.dart lib/features/auth/data/tenant_repository.dart lib/features/auth/data/api_tenant_repository.dart
git commit -m "feat: add TenantSummary model and ApiTenantRepository"
```

---

### Task 9: Tenant Picker Screen

**Files:**
- Create: `lib/features/auth/presentation/screens/tenant_picker_screen.dart`

**Context:**
- This screen is shown to super-admins who have no tenant
- Calls `GET /v1/platform/tenants` with optional search
- On selection: saves tenant slug → updates provider → navigates to organizer dashboard
- Design: simple searchable list matching existing app style (AppColors, AppTypography, AppDimensions)

- [ ] **Step 1: Add tenant provider to auth_provider.dart**

In `lib/features/auth/providers/auth_provider.dart`, add these imports and providers at the top level:

```dart
import 'package:hyperarena/features/auth/data/api_tenant_repository.dart';
import 'package:hyperarena/features/auth/data/tenant_repository.dart';
```

Add after `authRepositoryProvider`:

```dart
final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiTenantRepository(apiClient);
});
```

- [ ] **Step 2: Create TenantPickerScreen**

```dart
// lib/features/auth/presentation/screens/tenant_picker_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/data/models/tenant_summary.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

class TenantPickerScreen extends ConsumerStatefulWidget {
  const TenantPickerScreen({super.key});

  @override
  ConsumerState<TenantPickerScreen> createState() => _TenantPickerScreenState();
}

class _TenantPickerScreenState extends ConsumerState<TenantPickerScreen> {
  final _searchController = TextEditingController();
  List<TenantSummary> _tenants = [];
  bool _isLoading = true;
  String? _error;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadTenants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadTenants({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final repo = ref.read(tenantRepositoryProvider);
      final tenants = await repo.getTenants(search: search);
      if (mounted) {
        setState(() {
          _tenants = tenants;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat daftar tenant';
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadTenants(search: query.isEmpty ? null : query);
    });
  }

  Future<void> _selectTenant(TenantSummary tenant) async {
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.saveTenantSlug(tenant.slug);
    ref.read(tenantSlugProvider.notifier).state = tenant.slug;
    if (mounted) {
      context.go(AppRoutes.organizerDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Tenant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.base),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari tenant...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: AppTypography.bodyMedium),
                            const SizedBox(height: AppDimensions.sm),
                            TextButton(
                              onPressed: () => _loadTenants(),
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                      )
                    : _tenants.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada tenant ditemukan',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding:
                                const EdgeInsets.all(AppDimensions.base),
                            itemCount: _tenants.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppDimensions.sm),
                            itemBuilder: (_, index) {
                              final tenant = _tenants[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary50,
                                  backgroundImage: tenant.logoUrl != null
                                      ? NetworkImage(tenant.logoUrl!)
                                      : null,
                                  child: tenant.logoUrl == null
                                      ? Text(
                                          tenant.name[0].toUpperCase(),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(tenant.name,
                                    style: AppTypography.bodyMedium
                                        .copyWith(
                                            fontWeight: FontWeight.w600)),
                                subtitle: Text(tenant.slug,
                                    style: AppTypography.caption.copyWith(
                                        color: AppColors.textSecondary)),
                                trailing:
                                    const Icon(Icons.chevron_right),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusSm),
                                  side: BorderSide(
                                      color: AppColors.neutral200),
                                ),
                                onTap: () => _selectTenant(tenant),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/features/auth/presentation/screens/tenant_picker_screen.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/auth/presentation/screens/tenant_picker_screen.dart lib/features/auth/providers/auth_provider.dart
git commit -m "feat: add TenantPickerScreen for super-admin tenant selection"
```

---

### Task 10: Router Guard — Super-Admin Redirect

**Files:**
- Modify: `lib/routing/app_routes.dart`
- Modify: `lib/routing/app_router.dart`

- [ ] **Step 1: Add tenant picker route to AppRoutes**

In `lib/routing/app_routes.dart`, add after the `forgotPassword` line:

```dart
  static const tenantPicker = '/auth/tenant-picker';
```

- [ ] **Step 2: Update router with tenant picker route and redirect guard**

In `lib/routing/app_router.dart`, add the import:

```dart
import 'package:hyperarena/features/auth/presentation/screens/tenant_picker_screen.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
```

Add `AppRoutes.tenantPicker` to the `_publicPaths` set. Note: tenant picker is for authenticated super-admins, but it's included here so the auth redirect doesn't loop (authenticated + public route = allowed to stay).

```dart
const _publicPaths = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.sportSelection,
  AppRoutes.forgotPassword,
  AppRoutes.tenantPicker, // Included so super-admin redirect doesn't loop
};
```

Update the `redirect` function to handle super-admin. Note: `ref` is captured from the outer `Provider<GoRouter>((ref) { ... })` closure — it's available inside the redirect callback.

```dart
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isPublicRoute = _publicPaths.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isPublicRoute) {
        // Super-admin without tenant slug → tenant picker
        if (authState.activeRole == 'super-admin') {
          final slug = ref.read(tenantSlugProvider);
          if (slug == null && state.matchedLocation != AppRoutes.tenantPicker) {
            return AppRoutes.tenantPicker;
          }
        }
        if (state.matchedLocation == AppRoutes.tenantPicker) {
          return null; // Allow super-admin to stay on picker
        }
        return AppRoutes.home(authState.role);
      }

      // Authenticated, non-public route: check super-admin needs tenant
      if (isAuthenticated && authState.activeRole == 'super-admin') {
        final slug = ref.read(tenantSlugProvider);
        if (slug == null && state.matchedLocation != AppRoutes.tenantPicker) {
          return AppRoutes.tenantPicker;
        }
      }

      return null;
    },
```

Add the route definition after the `forgotPassword` route:

```dart
      GoRoute(
        path: AppRoutes.tenantPicker,
        builder: (_, _) => const TenantPickerScreen(),
      ),
```

- [ ] **Step 3: Verify compilation**

Run: `flutter analyze lib/routing/`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/routing/app_routes.dart lib/routing/app_router.dart
git commit -m "feat: add super-admin tenant picker route and redirect guard"
```

---

## Chunk 4: UI Changes + Final Verification (Tasks 11–13)

### Task 11: Login Screen — Hide Mock, Show API Errors

**Files:**
- Modify: `lib/features/auth/presentation/screens/login_screen.dart`

- [ ] **Step 1: Add API exception import**

Add at top of file:

```dart
import 'package:hyperarena/core/network/api_exceptions.dart';
```

- [ ] **Step 2: Update initState to not pre-fill in real mode**

The existing `initState` already checks `useMock` — no change needed (line 33–41 already conditional).

- [ ] **Step 3: Update _submit() error handling**

Replace the `catch (e)` block in `_submit()` (lines 60–65):

```dart
    } on ValidationException catch (e) {
      if (mounted) {
        // Backend returns 422 for invalid credentials with errors.email
        final emailError = e.errors['email']?.firstOrNull as String?;
        final message = emailError ?? e.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } on UnauthorizedException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi kadaluarsa, silakan login ulang')),
        );
      }
    } on ServerException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server sedang bermasalah, coba lagi')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message.isNotEmpty ? e.message : 'Login gagal')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: $e')),
        );
      }
    }
```

- [ ] **Step 4: Mock buttons are already conditional**

The existing code at line 222 already checks `if (ref.read(appConfigProvider).useMockData)` — mock buttons are automatically hidden in real mode. No change needed.

- [ ] **Step 5: Verify compilation**

Run: `flutter analyze lib/features/auth/presentation/screens/login_screen.dart`
Expected: No errors

- [ ] **Step 6: Commit**

```bash
git add lib/features/auth/presentation/screens/login_screen.dart
git commit -m "feat: add API error handling to login screen"
```

---

### Task 12: Register Screen — Disable in Real Mode

**Files:**
- Modify: `lib/features/auth/presentation/screens/register_screen.dart`

- [ ] **Step 1: Add real-mode guard**

Add this import:

```dart
import 'package:hyperarena/shared/providers/app_config_provider.dart';
```

In the `build` method, at the very beginning (before the `Scaffold`), add a guard that shows a "coming soon" message when not in mock mode:

```dart
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    if (!config.useMockData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.construction, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: AppDimensions.base),
                Text(
                  'Pendaftaran akan tersedia segera',
                  style: AppTypography.headingSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Fitur pendaftaran sedang dalam pengembangan.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xl),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Kembali ke Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // ... existing mock-mode Scaffold below ...
```

- [ ] **Step 2: Verify compilation**

Run: `flutter analyze lib/features/auth/presentation/screens/register_screen.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/presentation/screens/register_screen.dart
git commit -m "feat: show coming-soon message for registration in real mode"
```

---

### Task 13: Final Verification

- [ ] **Step 1: Run full test suite**

Run: `flutter test`
Expected: All tests pass

- [ ] **Step 2: Run flutter analyze**

Run: `flutter analyze`
Expected: No errors, no warnings (info-level lints are acceptable)

- [ ] **Step 3: Verify the app compiles for chrome (dev mode)**

Run: `flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true`
Or simpler: `flutter analyze` already verifies compilation

- [ ] **Step 4: Commit any remaining fixes**

If any fixes were needed, commit them:

```bash
git add -A
git commit -m "chore: fix lint issues from Phase 5A implementation"
```

---

## Deferred Items

- **Profile tenant indicator for super-admins:** The spec mentions showing the current tenant in the profile/app bar with a switch option. This is deferred because it requires understanding the profile screen's current structure and is a UX enhancement, not a blocker. It will be addressed when the super-admin flow is refined in a future iteration.
- **Detailed device name via `device_info_plus`:** Currently using a static `'HyperArena Mobile'` string. Can be improved later with actual device model info.

---

## /simplify Review

After all tasks are complete, run `/simplify` to review the entire implementation for code reuse, quality, and efficiency issues. Fix any findings.
