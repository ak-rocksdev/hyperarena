# Phase 5A: Auth + Tenant Integration — Design Spec

## Goal

Replace the mock auth flow with real API calls so users can log in against the Laravel backend, persist their session, and have the correct tenant context for subsequent API requests.

## Scope

**In scope:**
- `ApiAuthRepository` — login, logout, getCurrentUser (register deferred)
- `User` model extensions — tenant fields, role mapping from backend to Flutter enums
- Tenant slug persistence — extract from login response, store in SecureStorage, inject into `X-Tenant` header
- Super-admin tenant picker — minimal searchable list using `GET /api/v1/platform/tenants`
- Login screen adjustments — hide mock buttons in real mode, display API error messages
- Register link — disabled in real mode (deferred to marketplace sub-project)

**Out of scope:**
- Registration flow (requires marketplace/tenant discovery — separate sub-project)
- Full User model rewrite (roles array, permissions, student_account, guardians)
- Role switching (`PUT /api/v1/auth/switch-role`)
- Profile editing, password change, locale change
- Court owner tenant type (not a real tenant on backend yet)

## Architecture

### Backend Facts

- `POST /api/v1/auth/login` requires only email + password — no `X-Tenant` header needed
- Login returns HTTP 201 (not 200) for mobile clients — Dio treats all 2xx as success, no special handling needed
- Email is globally unique — backend resolves the user and their tenant automatically
- Response includes `user.tenant.slug` which the app stores for subsequent requests
- Response includes `user.tenant.sport` nested object — ignore for now, parser must not break on it
- A user belongs to exactly one tenant (`users.tenant_id` foreign key, nullable)
- Super-admins have `tenant_id = NULL` and the `super-admin` role
- `GET /api/v1/platform/tenants` lists tenants with search (super-admin only)
- Invalid credentials throw Laravel `ValidationException` (HTTP 422 with `errors.email`), NOT HTTP 401
- The backend `X-Device-Name` header is used to name the Sanctum token — send device model info for multi-device identification

### Role Mapping

The backend `active_role` field determines the Flutter role. The backend `tenants` table has no `type` column, so mapping is based solely on `active_role`:

| Backend `active_role` | Flutter `UserRole` |
|---|---|
| `member` | `player` |
| `coach` | `coach` |
| `admin` | `organizer` |
| `super-admin` | `organizer` (after tenant selection) |
| unknown / null | `player` (safe default) |

Notes:
- All `admin` users map to `organizer`. Court owner is not a functional role on the backend yet.
- Super-admin is treated as `organizer` after selecting a tenant. This is a debugging/inspection tool for now.

### Tenant Resolution Flow

```
Login (email + password)
  ↓
Backend returns user + tenant object
  ↓
user.tenant != null?
  ├─ YES → store tenant.slug → navigate by role
  └─ NO (super-admin) → redirect to TenantPickerScreen
                           ↓
                         User selects tenant → store slug → navigate as organizer
```

## Components

### 1. ApiAuthRepository

**File:** `lib/features/auth/data/api_auth_repository.dart`

Implements `AuthRepository` using `ApiClient`. Follows the same pattern as `ApiDeviceTokenRepository`.

**Methods:**
- `login(email, password)` → `POST /api/v1/auth/login` — parses `user` and `token` from response, extracts tenant slug
- `register(...)` → throws `UnimplementedError` for now (deferred)
- `logout({deviceToken})` → `POST /api/v1/auth/logout` — sends device token in body
- `getCurrentUser()` → `GET /api/v1/auth/me` — parses user from response

**Response parsing:**
- `user.id` is `int` on backend, `String` in Flutter → convert with `toString()`
- `user.active_role` is a raw string → map to `UserRole` via a pure function
- `user.tenant` may be null (super-admin) → handle gracefully
- `token` is a string like `"1|abc123..."` → wrap in `AuthToken`

**Tenant slug extraction:**
- The tenant slug is embedded in the `User` model (via `tenantSlug` field) — no need to change the `AuthRepository` interface return type
- The `AuthNotifier` (caller) reads `user.tenantSlug` after login and handles persisting it

### 2. User Model Extensions

**File:** `lib/features/auth/data/models/user.dart`

Add fields to the existing Freezed model:

```dart
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
    // New fields for Phase 5A:
    int? tenantId,
    String? tenantSlug,
    String? tenantName,
    String? activeRole,    // raw backend role string
    String? locale,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

All new fields are nullable with no default, so existing mock code continues to work unchanged.

### 3. Role Mapping Function

**File:** `lib/features/auth/data/mappers/role_mapper.dart`

Pure function based solely on `active_role` (no tenant type — the backend has no `type` column on tenants):

```dart
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

### 4. API Response Parser

**File:** `lib/features/auth/data/mappers/auth_response_mapper.dart`

Parses the raw JSON response from login/register/me into `User` + `AuthToken`. Keeps parsing logic out of the repository, making both testable independently.

```dart
(User, AuthToken) parseLoginResponse(Map<String, dynamic> json) {
  // Parses user (with tenantSlug embedded) + token
  // Tenant slug lives on User.tenantSlug — no separate return value needed
  // Must handle: user.tenant.sport nested object (ignore it)
}

User parseUserResponse(Map<String, dynamic> json) {
  // For GET /api/v1/auth/me — same user structure
}
```

### 5. SecureStorageService — Tenant Slug

**File:** `lib/core/storage/secure_storage_service.dart`

Add three methods + cached field (same pattern as FCM token):

- `saveTenantSlug(String slug)` → write to secure storage + update cache
- `getTenantSlug()` → return from cache (synchronous)
- `deleteTenantSlug()` → clear both

Update `warmUp()` to also load the tenant slug.

### 6. AuthNotifier Changes

**File:** `lib/features/auth/providers/auth_provider.dart`

**Login flow update:**
1. Call `_repo.login(email, password)` → get `(user, token)`
2. Save token to SecureStorage
3. Extract `user.tenantSlug` → save to SecureStorage + update `tenantSlugProvider`
4. Save user JSON to SharedPreferences
5. Set state → router redirects by role

**Logout flow update:**
1. Existing FCM cleanup
2. Clear tenant slug from SecureStorage + provider
3. Existing token + user cleanup

**App restart flow:**
- `build()` restores user from SharedPreferences (existing)
- Also restore tenant slug: read from `SecureStorageService` cache (already loaded by `warmUp()`) → update `tenantSlugProvider`
- Note: `tenantSlugProvider` update happens inside `AuthNotifier.build()`, not in `app_bootstrap.dart`, since ProviderScope is needed

### 7. Provider Wiring

**File:** `lib/features/auth/providers/auth_provider.dart`

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

### 8. Super-Admin Tenant Picker

**New files:**
- `lib/features/auth/data/models/tenant_summary.dart` — simple Freezed model: `{id, name, slug, logoUrl}` (logoUrl from backend's `logo_urls.md` variant)
- `lib/features/auth/data/tenant_repository.dart` — abstract interface with `getTenants({String? search})`
- `lib/features/auth/data/api_tenant_repository.dart` — calls `GET /v1/platform/tenants`
- `lib/features/auth/presentation/screens/tenant_picker_screen.dart` — searchable list

Tenant listing is a separate `TenantRepository`, not on `ApiAuthRepository`, since it's a platform-admin concern separate from authentication.

**Flow:**
- Router guard: if user is logged in, `user.activeRole == "super-admin"` (check raw string, not mapped `UserRole` enum since super-admin maps to `organizer`), and no tenant slug → redirect to tenant picker
- On tenant selection → store slug, update provider, navigate to organizer dashboard
- Profile screen or app bar shows current tenant with option to switch (tap → back to picker)

### 9. Login Screen Changes

**File:** `lib/features/auth/presentation/screens/login_screen.dart`

- Hide "Quick Login (Mock)" section when `!config.useMockData`
- Don't pre-fill email/password when not in mock mode
- Error handling: catch `ApiException` subtypes and show meaningful messages:
  - `ValidationException` with `errors.email` → "Email atau password salah" (backend throws 422 for invalid credentials, not 401)
  - `ValidationException` with other field errors → show field-level error messages
  - `UnauthorizedException` (401) → "Sesi kadaluarsa, silakan login ulang" (only for authenticated endpoints, not login itself)
  - `ServerException` → "Server sedang bermasalah, coba lagi"

### 10. Register Screen Changes

**File:** `lib/features/auth/presentation/screens/register_screen.dart`

- When `!config.useMockData`: show a message like "Pendaftaran akan tersedia segera" (Registration coming soon) and disable the form, OR redirect back to login
- Keep the mock registration working for development

## Testing Strategy

- **Unit tests:** Role mapper function, auth response parser, SecureStorageService tenant slug methods
- **Integration verification:** Login with real backend via `main_dev.dart`, verify token stored, tenant slug injected, redirect works

## Data Flow Summary

```
LoginScreen._submit()
  → AuthNotifier.login(email, password)
    → ApiAuthRepository.login(email, password)
      → POST /api/v1/auth/login (with X-Device-Name header)
      → parse response → (User, AuthToken)
      → User.tenantSlug extracted from user.tenant.slug
    ← save token to SecureStorage
    ← save user.tenantSlug to SecureStorage
    ← update tenantSlugProvider
    ← save user to SharedPreferences
    ← state = user
  → GoRouter redirect fires
    → user.activeRole == "super-admin" && no slug? → TenantPickerScreen
    → otherwise → role-based home screen
```

### Known Limitation

`ApiInterceptor._handleUnauthorized()` (auto-logout on 401) does not clear the tenant slug. This is acceptable because the next login will overwrite it with the correct slug. If this causes issues, add slug cleanup to `_handleUnauthorized()` in a follow-up.

## Files Changed/Created

| Action | File |
|---|---|
| Create | `lib/features/auth/data/api_auth_repository.dart` |
| Create | `lib/features/auth/data/mappers/role_mapper.dart` |
| Create | `lib/features/auth/data/mappers/auth_response_mapper.dart` |
| Create | `lib/features/auth/data/models/tenant_summary.dart` |
| Create | `lib/features/auth/data/tenant_repository.dart` |
| Create | `lib/features/auth/data/api_tenant_repository.dart` |
| Create | `lib/features/auth/presentation/screens/tenant_picker_screen.dart` |
| Create | `test/features/auth/data/mappers/role_mapper_test.dart` |
| Create | `test/features/auth/data/mappers/auth_response_mapper_test.dart` |
| Create | `test/core/storage/secure_storage_service_test.dart` (extend existing) |
| Modify | `lib/features/auth/data/models/user.dart` (add tenant fields) |
| Modify | `lib/core/storage/secure_storage_service.dart` (add tenant slug) |
| Modify | `lib/features/auth/providers/auth_provider.dart` (provider switch + notifier) |
| Modify | `lib/features/auth/presentation/screens/login_screen.dart` (hide mock, errors) |
| Modify | `lib/features/auth/presentation/screens/register_screen.dart` (disable in real mode) |
| Modify | `lib/routing/app_router.dart` (super-admin redirect guard) |
| Modify | `lib/core/network/api_client.dart` (add X-Device-Name header) |
| Regenerate | `lib/features/auth/data/models/user.freezed.dart` |
| Regenerate | `lib/features/auth/data/models/user.g.dart` |
