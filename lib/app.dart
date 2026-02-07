import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

class HyperArenaApp extends ConsumerWidget {
  const HyperArenaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return MaterialApp(
      title: 'HyperArena',
      debugShowCheckedModeBanner: config.showDebugBanner,
      home: Scaffold(
        body: Center(
          child: Text('HyperArena — ${config.environment.name} mode'),
        ),
      ),
    );
  }
}
