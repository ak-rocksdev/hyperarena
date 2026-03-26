# FCM Push Notification Client Integration — Design Spec

## Overview

Integrate Firebase Cloud Messaging (FCM) into the HyperArena Flutter app to receive push notifications from the Laravel backend. This supplements the existing polling-based notification system — it does not replace it.

The backend (branch `009-fcm-push-notifications`) already implements device token registration, logout cleanup, and FCM dispatch. This spec covers the Flutter client side only.

**Platform scope:** Both Android and iOS are in scope. Firebase is already configured for both platforms via FlutterFire CLI (`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`). iOS APNs is configured as part of the Firebase project setup. iOS-specific `Info.plist` entries for background modes and push notifications are handled by the `firebase_messaging` package automatically.

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| HTTP client | Build foundational `ApiClient` with Dio interceptors | FCM is the first consumer; avoids throwaway code |
| Notification tap routing | Dedicated `NotificationRouteResolver` class | Single source of truth, testable, extensible |
| Foreground display | System notification + in-app banner + unread badge | All three for complete UX |
| Unread count update | Optimistic local increment (+1 on FCM receive) | Instant UI feedback, reconciles on next fetch |
| AuthToken model | Simplify to `{ String token }` | Backend has no refresh token; YAGNI |
| Token storage | Migrate Bearer token to `flutter_secure_storage` | Auth flow already being modified; natural time |

## Architecture

Layered services with clear responsibilities, following existing Riverpod provider patterns:

```
lib/
  core/
    network/
      api_client.dart              — Dio instance + typed methods
      api_interceptor.dart         — Bearer, X-Tenant, X-Client-Type headers
      api_exceptions.dart          — Typed exception classes
    services/
      push_notification_service.dart — FCM lifecycle, foreground/background handling
    storage/
      secure_storage_service.dart  — Encrypted token storage wrapper
  features/
    auth/
      data/
        models/auth_token.dart     — Simplified to { String token }
      providers/
        auth_provider.dart         — Updated: secure storage + FCM register/cleanup
    notification/
      data/
        device_token_repository.dart       — Abstract interface
        api_device_token_repository.dart   — POST/DELETE /api/v1/auth/device-token
        mock_device_token_repository.dart  — No-op mock for dev
      utils/
        notification_route_resolver.dart   — data.type + IDs → GoRouter path
  shared/
    widgets/
      in_app_notification_banner.dart      — Telegram-style overlay banner
```

## Dependencies

Add to `pubspec.yaml`:

- `firebase_core` — Firebase initialization
- `firebase_messaging` — FCM push notifications
- `flutter_local_notifications` — System notification display in foreground
- `flutter_secure_storage` — Encrypted Bearer token storage

## Component Specifications

### 1. Firebase Initialization

**File:** `lib/app_bootstrap.dart`

Add `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` after `WidgetsFlutterBinding.ensureInitialized()`, before `runApp()`.

Skip Firebase initialization when `AppConfig.useMockData` is true to avoid errors in environments without Firebase configuration.

Also call `await secureStorage.warmUp()` during bootstrap to pre-load the token cache before the widget tree builds (see Section 3). The updated bootstrap sequence:

```
WidgetsFlutterBinding.ensureInitialized()
  → Firebase.initializeApp() (if !useMockData)
  → FirebaseMessaging.onBackgroundMessage() (if !useMockData)
  → SharedPreferences.getInstance()
  → SecureStorageService().warmUp()
  → runApp(ProviderScope(overrides: [appConfig, sharedPrefs, secureStorage]))
```

Register the background message handler before `runApp()`:

```dart
FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```

The background message handler is a top-level function (Firebase requirement):

```dart
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Minimal — no navigation, no state mutation
}
```

### 2. ApiClient

**Files:**
- `lib/core/network/api_client.dart`
- `lib/core/network/api_interceptor.dart`
- `lib/core/network/api_exceptions.dart`

**Scope:** This is the permanent, foundational HTTP client for the entire app. It is designed to serve all 51+ backend endpoints. The device-token endpoints are the first consumer; other repositories will adopt it as they migrate from mock to real implementations.

**ApiClient:** Wraps a Dio instance. The base URL is `AppConfig.apiBaseUrl` which already includes the `/api` segment (e.g., `http://hyperarena.local/api`). Therefore, endpoint paths passed to `ApiClient` methods must exclude the `/api` prefix — use `/v1/auth/device-token`, not `/api/v1/auth/device-token`. Exposes typed methods: `get()`, `post()`, `put()`, `patch()`, `delete()`. Each method accepts a path, optional body, and optional query parameters, and returns `Response`.

**ApiInterceptor:** `ApiClient` creates the `ApiInterceptor` internally during construction and adds it to the Dio instance. The interceptor receives `SecureStorageService` from `ApiClient`. This keeps the construction chain simple — consumers only depend on `ApiClient`, not on the interceptor directly.

The interceptor:
- Reads Bearer token from `SecureStorageService`, injects `Authorization` header (skipped if token is null)
- Injects `X-Client-Type: mobile` on every request
- Injects `X-Tenant: {slug}` when a tenant slug is available (safe to always send — backend ignores it on non-tenant-scoped routes like device-token endpoints). **Note:** The current `User` model does not have a `tenant` field. For this phase, the interceptor supports an optional tenant slug via a `tenantSlugProvider` (a simple `StateProvider<String?>` initialized to `null`). Device-token endpoints do not require X-Tenant, so this header is effectively skipped for all FCM-related calls. Full tenant model extension and tenant selection flow are deferred to the backend integration spec.
- Injects `Accept: application/json` and `Content-Type: application/json`
- Injects `Accept-Language: {locale}` header. The locale is read from a `localeProvider` (`StateProvider<String>` defaulting to `'id'`, matching the current hardcoded `Locale('id')` in `app.dart`). When the app adds dynamic locale switching in a future phase, update this provider.
- On 401 response: uses an internal `_isRedirecting` flag to prevent multiple concurrent 401s from causing cascading redirects. The first 401 clears the stored Bearer token via `SecureStorageService.deleteToken()` and navigates to login via the `GoRouter` instance. Subsequent 401s during the redirect are ignored. The flag resets after navigation completes.

**ApiExceptions:** Typed exceptions mapped from HTTP status codes:
- `UnauthorizedException` (401)
- `ForbiddenException` (403)
- `ValidationException` (422) — carries `errors` map
- `NotFoundException` (404)
- `ServerException` (500+)

**Supporting providers:**
```dart
final tenantSlugProvider = StateProvider<String?>((ref) => null);
final localeProvider = StateProvider<String>((ref) => 'id');
```

**Provider:**
```dart
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

### 3. SecureStorageService

**File:** `lib/core/storage/secure_storage_service.dart`

Wraps `FlutterSecureStorage` with an in-memory cache for synchronous reads. Methods:
- `warmUp()` — Async. Reads Bearer token and FCM token from encrypted storage into in-memory cache. Called once during `bootstrap()` before `runApp()`.
- `saveToken(String)` / `getToken()` / `deleteToken()` — Bearer token. `getToken()` reads from the in-memory cache (synchronous). `saveToken()` and `deleteToken()` update both the cache and encrypted storage.
- `saveFcmToken(String)` / `getFcmToken()` / `deleteFcmToken()` — FCM token. Same cache pattern.

Bearer token is encrypted at rest. FCM token stored here for convenience (needed on logout). The in-memory cache allows the `ApiInterceptor` to read the token synchronously on every request without awaiting.

**Migration from SharedPreferences:** The migration logic lives in `AuthNotifier.build()`, not in `SecureStorageService`, because `AuthNotifier` already has access to `SharedPreferences` via `sharedPreferencesProvider`. The migration flow: check SharedPreferences for existing `auth_token` key. The old value is a JSON string with shape `{"token": "...", "refreshToken": "...", "expiresAt": "..."}`. Parse the JSON, extract just the `token` field, save it to `SecureStorageService`, then delete the `auth_token` key from SharedPreferences. If parsing fails (corrupt data), delete the SharedPreferences key and treat as logged out.

**Provider:**
```dart
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
```

### 4. DeviceTokenRepository

**Files:**
- `lib/features/notification/data/device_token_repository.dart` — interface
- `lib/features/notification/data/api_device_token_repository.dart` — real implementation
- `lib/features/notification/data/mock_device_token_repository.dart` — mock

**Interface:**
```dart
abstract class DeviceTokenRepository {
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  });
  Future<void> removeToken(String fcmToken);
}
```

**ApiDeviceTokenRepository:**
- `registerToken()` → `POST /v1/auth/device-token` with `{ token, platform, device_name }`
- `removeToken()` → `DELETE /v1/auth/device-token` with `{ token }`

(Paths exclude `/api` prefix — `ApiClient` base URL already includes it.)

**MockDeviceTokenRepository:** No-op with mock delay. Logs calls for debugging.

**Provider:** Standard pattern — switches on `config.useMockData`.

### 5. PushNotificationService

**File:** `lib/core/services/push_notification_service.dart`

**Dependencies:** `FirebaseMessaging`, `FlutterLocalNotificationsPlugin`, `DeviceTokenRepository`, `SecureStorageService`, `NotificationRouteResolver`, `GoRouter`, `void Function() onUnreadCountIncrement`

**Navigation access:** The service receives the `GoRouter` instance (from `appRouterProvider`) for navigation. This works correctly with GoRouter's declarative routing — the service calls `router.go(path)` which respects route guards, redirects, and URL tracking. Using `GoRouter` directly (not `NavigatorState`) ensures compatibility with the app's routing system.

**Unread count wiring:** The service receives a `void Function() onUnreadCountIncrement` callback during construction. The provider wires this to `UnreadCountNotifier.increment()`. This avoids passing `Ref` into the service (antipattern) and keeps the service testable.

**Banner display:** The service exposes a `Stream<RemoteMessage>` via a `StreamController<RemoteMessage>.broadcast()` (broadcast because both the banner widget and potentially other listeners may subscribe). A top-level widget (e.g., in `HyperArenaApp` or the role shell) subscribes to this stream and inserts/removes `OverlayEntry` widgets for the in-app banner. This keeps UI concerns out of the service.

**Methods:**
- `initialize()` — Create Android notification channel (high importance, ID: `hyperarena_notifications`). Request notification permission (handles both Android 13+ POST_NOTIFICATIONS and iOS permission prompt). Set up `onMessage` listener (shows system notification, pushes to broadcast stream, calls unread increment callback). Set up `onMessageOpenedApp` listener for background taps. **Also call `getInitialMessage()`** to handle taps that cold-started the app — if non-null, route through `NotificationRouteResolver` and navigate via `router.go()`.
- `getToken()` — Get current FCM token from `FirebaseMessaging.instance.getToken()`
- `registerWithBackend()` — Get FCM token, save locally via `SecureStorageService`, POST to backend via `DeviceTokenRepository`. Sets up `onTokenRefresh` listener using cancel-and-replace pattern (cancels any existing subscription before creating a new one).
- `removeFromBackend()` — Read stored FCM token, DELETE from backend, clear local copy. Cancels the `onTokenRefresh` subscription.
- `dispose()` — Cancels all stream subscriptions, closes `StreamController`. Called via `ref.onDispose` in the provider.

**Permission handling:** If permission denied, service stays initialized but does not register token with backend. App works normally without push notifications.

**When to call `initialize()`:** Called by `AuthNotifier` after successful login/register, not during `bootstrap()`. This ensures the Riverpod widget tree is ready and auth state exists. On app restart with existing session, `AuthNotifier.build()` restores the session and launches FCM initialization as fire-and-forget (see Section 8 for details).

**Error handling in `registerWithBackend()`:** FCM token registration is fire-and-forget — if the `POST /v1/auth/device-token` call fails (network error, server error), the error is logged but does not block login. The user can still use the app; they just won't receive push notifications until the next token refresh triggers a re-registration attempt.

**Error handling in `removeFromBackend()`:** Token cleanup during logout is best-effort. If the `DELETE /v1/auth/device-token` call fails, the error is logged and logout proceeds locally (clear storage, navigate to login). The backend's logout endpoint also cleans up device tokens as a safety net.

**`onTokenRefresh` subscription lifecycle:** The service holds a `StreamSubscription?` for `onTokenRefresh`. On `registerWithBackend()`, any existing subscription is cancelled before creating a new one (cancel-and-replace). On `removeFromBackend()` or `dispose()`, the subscription is cancelled. The provider uses `ref.onDispose(() => service.dispose())` to prevent leaks.

**Provider:**
```dart
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final deviceTokenRepo = ref.watch(deviceTokenRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final routeResolver = ref.watch(notificationRouteResolverProvider);
  final router = ref.watch(appRouterProvider);
  final unreadNotifier = ref.watch(unreadCountProvider.notifier);
  final service = PushNotificationService(
    deviceTokenRepository: deviceTokenRepo,
    secureStorage: secureStorage,
    routeResolver: routeResolver,
    router: router,
    onUnreadCountIncrement: () => unreadNotifier.increment(),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
```

### 6. NotificationRouteResolver

**File:** `lib/features/notification/utils/notification_route_resolver.dart`

Single method: `String? resolve(String? type, Map<String, dynamic> data)`

| `data.type` | Route | Notes |
|---|---|---|
| `booking_confirmed` | `AppRoutes.session(data['session_id'])` | `/session/{session_id}` |
| `session_reminder` | `AppRoutes.session(data['session_id'])` | `/session/{session_id}` |
| `purchase_confirmed` | `AppRoutes.notifications` | `/notifications` — no dedicated purchase history route exists yet; land on notifications screen |
| `payout_approved` | `AppRoutes.organizerEarnings` | `/organizer/earnings` — closest existing route for payout info |
| `payment_rejected` | `AppRoutes.notifications` | `/notifications` — no dedicated billing route exists yet; land on notifications screen |
| `progress_updated` | `AppRoutes.session(data['session_id'])` | `/session/{session_id}` |
| unknown / null | `null` | No navigation — caller handles gracefully |

**Note:** `purchase_confirmed` and `payment_rejected` land on the notifications screen as a fallback because dedicated purchase history and billing routes do not exist in the current app. When these screens are built in a future phase, update the resolver mapping.

Returns `null` for unknown types — caller handles gracefully (does nothing).

**Coexistence with existing `NotificationType` enum:** The existing `NotificationType` enum in `NotificationItem` uses camelCase values (`bookingConfirmed`, `sessionReminder`). The FCM `data.type` payload from the backend uses snake_case strings (`booking_confirmed`, `session_reminder`). The `NotificationRouteResolver` works with the backend's raw snake_case strings and does not depend on or modify the existing enum. They coexist independently — the enum serves the polling-based notification list UI, the resolver serves FCM deep linking. If the two systems are unified in a future phase, the enum should be extended with the new backend types (`purchase_confirmed`, `payout_approved`, `payment_rejected`, `progress_updated`) and a snake_case-to-enum mapping added.

**Provider:**
```dart
final notificationRouteResolverProvider = Provider<NotificationRouteResolver>((ref) {
  return NotificationRouteResolver();
});
```

### 7. In-App Notification Banner

**File:** `lib/shared/widgets/in_app_notification_banner.dart`

- Overlay widget shown at top of screen (Telegram/WhatsApp style)
- Slides in from top with animation
- Shows notification title + body
- Auto-dismisses after ~4 seconds
- Tappable → navigates via `NotificationRouteResolver`
- Dismissible via swipe up

**Display mechanism:** A `StreamSubscription` on `PushNotificationService.foregroundMessageStream` (broadcast stream) in a top-level widget (the role shell or `HyperArenaApp`). When a message arrives, the widget creates an `OverlayEntry` with the banner, inserts it, and schedules removal after the timeout. This keeps the `PushNotificationService` free of UI concerns. The subscribing widget accesses `OverlayState` from its own `BuildContext`.

### 8. Auth Flow Updates

**`AuthNotifier` changes:**

**`AuthToken` model simplification:**
Change from `AuthToken({ token, refreshToken, expiresAt })` to `AuthToken({ token })`. This requires:
1. Update the Freezed model file and regenerate (`dart run build_runner build`)
2. Update `MockAuthRepository` to construct `AuthToken` with just `token`
3. Update `AuthNotifier` to store/restore just the token string via `SecureStorageService`
4. The `AuthRepository` interface return type `(User, AuthToken)` stays the same — only the model's fields change

**`AuthRepository.logout()` interface update:**
Change from `Future<void> logout()` to `Future<void> logout({String? deviceToken})` to support passing the FCM token in the logout request body. The mock implementation ignores the parameter. The future real implementation passes it as `{ device_token: deviceToken }` in the POST body.

**`AuthNotifier` remains a synchronous `Notifier<User?>`** — it does not change to `AsyncNotifier`. The `build()` method restores the session synchronously from local storage (same as current behavior). Async operations (SharedPreferences → SecureStorage migration, FCM initialization) are launched as fire-and-forget from `build()` without awaiting:

```dart
@override
User? build() {
  // Synchronous: read stored user from SharedPreferences
  final user = _restoreUserFromPrefs();
  if (user != null) {
    // Fire-and-forget: async migration + FCM setup
    _initializeAsyncServices();
  }
  return user; // returns immediately
}

Future<void> _initializeAsyncServices() async {
  await _migrateTokenIfNeeded(); // SharedPrefs → SecureStorage
  final pushService = ref.read(pushNotificationServiceProvider);
  await pushService.initialize();
  pushService.registerWithBackend(); // also fire-and-forget within
}
```

**Handling the async migration gap:** `FlutterSecureStorage` is entirely async — there is no synchronous API. To bridge this, `SecureStorageService` maintains an in-memory cache (`String? _cachedToken`). During `bootstrap()` (before `runApp()`), call `await secureStorage.warmUp()` which reads the token from encrypted storage into the cache. The `ApiInterceptor` reads from this in-memory cache (synchronous) rather than calling `secureStorage.getToken()` (async) on every request. The migration from SharedPreferences happens in `_initializeAsyncServices()`: it reads the old JSON, extracts the token, writes to secure storage, updates the in-memory cache, and deletes the SharedPreferences key. If the cache is empty after warm-up (first install or post-migration), API calls simply have no Authorization header until login.

**Login flow:**
```
Login success → save Bearer token (SecureStorageService)
  → save user JSON (SharedPreferences)
  → initialize PushNotificationService (request permission, setup listeners)
  → register FCM token with backend (fire-and-forget; failure does not block login)
  → done
```

**Register flow:**
```
Register success → save Bearer token (SecureStorageService)
  → save user JSON (SharedPreferences)
  → initialize PushNotificationService (request permission, setup listeners)
  → register FCM token with backend (fire-and-forget; failure does not block registration)
  → done
```

**Logout flow:**
```
Logout tap → get stored FCM token from SecureStorageService
  → call AuthRepository.logout(deviceToken: fcmToken)
    → POST /v1/auth/logout { device_token: fcmToken } (backend cleans up device token)
  → clear SecureStorageService (Bearer token + FCM token)
  → clear SharedPreferences user
  → dispose PushNotificationService listeners
  → navigate to login
```

**Logout simplification:** The backend's `POST /v1/auth/logout` endpoint accepts an optional `device_token` field in the body and handles FCM token cleanup internally. A separate `DELETE /v1/auth/device-token` call before logout is redundant. Use a single logout call with the FCM token in the body. If the logout call fails, proceed with local cleanup anyway (clear storage, navigate to login).

### 9. Unread Count — Optimistic Increment

Convert `unreadCountProvider` from `FutureProvider<int>` to `AsyncNotifierProvider<UnreadCountNotifier, int>`:

- `build()` → `Future<int>` that fetches from `NotificationRepository.getUnreadCount()`
- `increment()` → `state = AsyncData((state.valueOrNull ?? 0) + 1)` (called via the `onUnreadCountIncrement` callback wired through `PushNotificationService`)
- `refresh()` → calls `ref.invalidateSelf()` to re-fetch from backend (called when notification screen opens)

Using `AsyncNotifierProvider` (not `NotifierProvider`) because `build()` is asynchronous — it fetches from the repository which returns `Future<int>`.

## FCM Payload Format (from backend)

```json
{
  "notification": { "title": "...", "body": "..." },
  "data": {
    "type": "booking_confirmed|session_reminder|purchase_confirmed|payout_approved|payment_rejected|progress_updated",
    "session_id": "...",
    "...other entity IDs"
  }
}
```

## Constraints

- Follow existing Riverpod + repository + Freezed patterns
- Do not break existing notification polling — FCM supplements it
- Handle permission denied gracefully (app works without push)
- Android 13+ requires runtime POST_NOTIFICATIONS permission
- iOS permission prompt handled by `firebase_messaging` package
- `/simplify` review after each implementation phase
- Background message handler must be a top-level function (Firebase requirement)
- FCM token registration and cleanup are fire-and-forget — never block auth flows
- Logout always proceeds locally regardless of network errors

## What to Expect After Completion

1. **Login / Register** → app requests notification permission, registers FCM token with backend
2. **While using app (foreground)** → system notification appears in tray + Telegram-style banner slides in from top + unread badge increments
3. **App in background** → system notification appears, tapping it opens the app and navigates to the relevant screen
4. **App terminated (cold start)** → system notification appears, tapping it cold-starts the app and navigates to the relevant screen (via `getInitialMessage()`)
5. **Logout** → FCM token sent with logout request, backend cleans up, local storage cleared
6. **Permission denied** → app works normally, no push notifications, no errors
7. **Token refresh** → automatically re-registers with backend via `onTokenRefresh` listener
8. **Network error during FCM registration** → logged silently, login/register proceeds normally
