import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/firebase_options.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart'; // appConfigProvider only
import 'package:hyperarena/shared/providers/network_providers.dart'; // shared + secure storage providers
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

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  } catch (e) {
    // Firebase not configured for this platform (e.g. web) — continue without it.
    debugPrint('Firebase init skipped: $e');
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
