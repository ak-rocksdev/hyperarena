import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_theme.dart';
import 'package:hyperarena/core/theme/app_theme_dark.dart';
import 'package:hyperarena/routing/app_router.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

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
      routerConfig: router,
    );
  }
}
