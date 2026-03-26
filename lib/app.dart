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
