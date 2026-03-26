# FCM Push Notification Client Integration — Design Spec

## Overview

Integrate Firebase Cloud Messaging (FCM) into the HyperArena Flutter app to receive push notifications from the Laravel backend. This supplements the existing polling-based notification system — it does not replace it.

The backend (branch `009-fcm-push-notifications`) already implements device token registration, logout cleanup, and FCM dispatch. This spec covers the Flutter client side only.

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

**ApiClient:** Wraps a Dio instance configured with `AppConfig.apiBaseUrl`. Exposes typed methods: `get()`, `post()`, `put()`, `patch()`, `delete()`.

**ApiInterceptor:** Dio interceptor that:
- Reads Bearer token from `SecureStorageService`, injects `Authorization` header
- Injects `X-Client-Type: mobile` on every request
- Injects `X-Tenant: {slug}` when tenant is set
- Injects `Accept: application/json` and `Content-Type: application/json`
- On 401 response: clears auth state, redirects to login

**ApiExceptions:** Typed exceptions mapped from HTTP status codes:
- `UnauthorizedException` (401)
- `ForbiddenException` (403)
- `ValidationException` (422) — carries `errors` map
- `NotFoundException` (404)
- `ServerException` (500+)

**Provider:**
```dart
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(config: config, secureStorage: secureStorage);
});
```

### 3. SecureStorageService

**File:** `lib/core/storage/secure_storage_service.dart`

Wraps `FlutterSecureStorage`. Methods:
- `saveToken(String)` / `getToken()` / `deleteToken()` — Bearer token
- `saveFcmToken(String)` / `getFcmToken()` / `deleteFcmToken()` — FCM token

Bearer token is encrypted. FCM token stored here for convenience (needed on logout).

**Migration:** On first launch after update, check SharedPreferences for existing `auth_token` key. If found, move to secure storage and delete from SharedPreferences.

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
- `registerToken()` → `POST /api/v1/auth/device-token` with `{ token, platform, device_name }`
- `removeToken()` → `DELETE /api/v1/auth/device-token` with `{ token }`
- No X-Tenant header needed (user-level, not tenant-scoped)

**MockDeviceTokenRepository:** No-op with mock delay. Logs calls for debugging.

**Provider:** Standard pattern — switches on `config.useMockData`.

### 5. PushNotificationService

**File:** `lib/core/services/push_notification_service.dart`

**Dependencies:** `FirebaseMessaging`, `FlutterLocalNotificationsPlugin`, `DeviceTokenRepository`, `SecureStorageService`, `NotificationRouteResolver`

**Methods:**
- `initialize()` — Create Android notification channel (high importance, ID: `hyperarena_notifications`). Request notification permission. Set up `onMessage`, `onMessageOpenedApp` listeners.
- `getToken()` — Get current FCM token from `FirebaseMessaging.instance.getToken()`
- `registerWithBackend()` — Get FCM token, save locally via `SecureStorageService`, POST to backend via `DeviceTokenRepository`. Also listen for `onTokenRefresh` to re-register.
- `removeFromBackend()` — Read stored FCM token, DELETE from backend, clear local copy.
- `_onForegroundMessage(RemoteMessage)` — Show system notification via `flutter_local_notifications`, show in-app banner, optimistically increment unread count.
- `_onNotificationTap(RemoteMessage)` — Resolve route via `NotificationRouteResolver`, navigate via GoRouter.

**Permission handling:** If permission denied, service stays initialized but does not register token with backend. App works normally without push notifications.

**Provider:**
```dart
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  final deviceTokenRepo = ref.watch(deviceTokenRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final routeResolver = ref.watch(notificationRouteResolverProvider);
  return PushNotificationService(
    deviceTokenRepository: deviceTokenRepo,
    secureStorage: secureStorage,
    routeResolver: routeResolver,
  );
});
```

### 6. NotificationRouteResolver

**File:** `lib/features/notification/utils/notification_route_resolver.dart`

Single method: `String? resolve(String? type, Map<String, dynamic> data)`

| `data.type` | Route |
|---|---|
| `booking_confirmed` | `/session/{session_id}` |
| `session_reminder` | `/session/{session_id}` |
| `purchase_confirmed` | credits/purchase history screen |
| `payout_approved` | payout history screen |
| `payment_rejected` | billing screen |
| `progress_updated` | `/session/{session_id}` |
| unknown / null | `null` (no navigation) |

Returns `null` for unknown types — caller handles gracefully (does nothing).

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
- Triggered by `PushNotificationService` on foreground message via `Overlay` entry

### 8. Auth Flow Updates

**`AuthNotifier` changes:**

**Login flow:**
```
Login success → save Bearer token (SecureStorageService)
  → save user JSON (SharedPreferences)
  → request notification permission
  → get FCM token
  → POST /api/v1/auth/device-token
  → done
```

**Logout flow:**
```
Logout tap → get stored FCM token
  → DELETE /api/v1/auth/device-token
  → POST /api/v1/auth/logout { device_token: fcmToken }
  → clear SecureStorageService
  → clear SharedPreferences user
  → navigate to login
```

**`build()` method:** Restore Bearer token from `SecureStorageService` instead of SharedPreferences.

### 9. Unread Count — Optimistic Increment

Convert `unreadCountProvider` from `FutureProvider<int>` to `NotifierProvider<UnreadCountNotifier, int>`:

- `build()` → fetches from `NotificationRepository.getUnreadCount()`
- `increment()` → `state = state + 1` (called by `PushNotificationService` on foreground message)
- `refresh()` → re-fetches from backend (called when notification screen opens)

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
- `/simplify` review after each implementation phase
- Background message handler must be a top-level function (Firebase requirement)

## What to Expect After Completion

1. **Login** → app requests notification permission, registers FCM token with backend
2. **While using app (foreground)** → system notification appears in tray + Telegram-style banner slides in from top + unread badge increments
3. **App in background** → system notification appears, tapping it opens the app and navigates to the relevant screen
4. **App terminated** → system notification appears, tapping it cold-starts the app and navigates to the relevant screen
5. **Logout** → FCM token cleaned up from backend, no more push notifications until next login
6. **Permission denied** → app works normally, no push notifications, no errors
7. **Token refresh** → automatically re-registers with backend
