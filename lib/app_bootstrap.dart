import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/app.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable Google Fonts runtime fetching — fonts are bundled as assets.
  // Prevents network-dependent font downloads that block rendering on
  // emulators or offline devices.
  GoogleFonts.config.allowRuntimeFetching = false;

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const HyperArenaApp(),
    ),
  );
}
