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
