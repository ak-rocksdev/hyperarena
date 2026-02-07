# Phase 0: Foundation — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the complete app foundation — environment config, design system Dart files, shared enums, core widgets, routing with Player shell, mock data — so the app launches with a themed empty Player shell that navigates between 4 tabs.

**Architecture:** Riverpod + Feature-First + go_router. Mock-first development with abstract repositories. Design system tokens from `docs/DESIGN_SYSTEM.md` translated to Dart.

**Tech Stack:** Flutter 3.38.9, Dart 3.10.8, flutter_riverpod, riverpod_annotation, go_router, google_fonts, freezed_annotation, shared_preferences, shimmer

---

## Reference Files

- **Architecture:** `docs/plans/2026-02-07-flutter-architecture-design.md` — Sections 2–3 (env config, project structure)
- **Design System:** `docs/DESIGN_SYSTEM.md` — All sections (colors, typography, spacing, shadows, animations, components, dark mode, enums)
- **MVP Spec:** `docs/MVP_FLUTTER_SPECIFICATION.md` — Section 4.1 (Player screen map)

## Pre-Requisites

- Flutter project already initialized with `flutter create`
- `pubspec.yaml` already has all dependencies
- `flutter pub get` already ran successfully

---

### Task 1: Environment Configuration

**Files:**
- Create: `lib/core/config/app_config.dart`

**Step 1: Create the environment config class**

Create `lib/core/config/app_config.dart`:

```dart
enum Environment { mock, local, dev, production }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool useMockData;
  final bool enableLogging;
  final bool showDebugBanner;
  final Duration mockDelay;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.useMockData,
    required this.enableLogging,
    required this.showDebugBanner,
    this.mockDelay = const Duration(milliseconds: 500),
  });

  bool get isProduction => environment == Environment.production;
  bool get isDev => environment == Environment.dev;
  bool get isLocal => environment == Environment.local;
  bool get isMock => environment == Environment.mock;

  static const mock = AppConfig(
    environment: Environment.mock,
    apiBaseUrl: '',
    useMockData: true,
    enableLogging: true,
    showDebugBanner: true,
    mockDelay: Duration(milliseconds: 500),
  );

  static const local = AppConfig(
    environment: Environment.local,
    apiBaseUrl: 'http://hyperarena.local/api',
    useMockData: false,
    enableLogging: true,
    showDebugBanner: true,
  );

  static const dev = AppConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://dev-api.hyperarena.id/api',
    useMockData: false,
    enableLogging: true,
    showDebugBanner: true,
  );

  static const production = AppConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.hyperarena.id/api',
    useMockData: false,
    enableLogging: false,
    showDebugBanner: false,
  );
}
```

**Step 2: Verify file compiles**

Run: `cd D:\projects\Flutter\hyperarena && flutter analyze lib/core/config/app_config.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/config/app_config.dart
git commit -m "feat: add environment config with mock/local/dev/prod"
```

---

### Task 2: Shared Providers (AppConfig + SharedPreferences)

**Files:**
- Create: `lib/shared/providers/app_config_provider.dart`

**Step 1: Create the app config provider**

Create `lib/shared/providers/app_config_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';

/// Provided via ProviderScope.overrides in bootstrap
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

/// Provided via ProviderScope.overrides in bootstrap
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at startup',
  );
});
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/shared/providers/app_config_provider.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/shared/providers/app_config_provider.dart
git commit -m "feat: add app config and shared preferences providers"
```

---

### Task 3: Bootstrap + Entry Points

**Files:**
- Create: `lib/app_bootstrap.dart`
- Modify: `lib/main.dart` (replace default counter app)
- Create: `lib/main_mock.dart`
- Create: `lib/main_local.dart`
- Create: `lib/main_dev.dart`

**Step 1: Create bootstrap function**

Create `lib/app_bootstrap.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/app.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

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
```

**Step 2: Create placeholder app.dart**

Create `lib/app.dart` (temporary — will be filled in Task 11 with theme + routing):

```dart
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
```

**Step 3: Replace main.dart (production entry)**

Replace all of `lib/main.dart` with:

```dart
import 'package:hyperarena/app_bootstrap.dart';
import 'package:hyperarena/core/config/app_config.dart';

void main() => bootstrap(AppConfig.production);
```

**Step 4: Create mock entry point**

Create `lib/main_mock.dart`:

```dart
import 'package:hyperarena/app_bootstrap.dart';
import 'package:hyperarena/core/config/app_config.dart';

void main() => bootstrap(AppConfig.mock);
```

**Step 5: Create local entry point**

Create `lib/main_local.dart`:

```dart
import 'package:hyperarena/app_bootstrap.dart';
import 'package:hyperarena/core/config/app_config.dart';

void main() => bootstrap(AppConfig.local);
```

**Step 6: Create dev entry point**

Create `lib/main_dev.dart`:

```dart
import 'package:hyperarena/app_bootstrap.dart';
import 'package:hyperarena/core/config/app_config.dart';

void main() => bootstrap(AppConfig.dev);
```

**Step 7: Run flutter analyze**

Run: `flutter analyze`
Expected: No errors (warnings about unused imports are OK at this stage)

**Step 8: Commit**

```bash
git add lib/app_bootstrap.dart lib/app.dart lib/main.dart lib/main_mock.dart lib/main_local.dart lib/main_dev.dart
git commit -m "feat: add bootstrap function and 4 environment entry points"
```

---

### Task 4: VS Code Launch Configuration

**Files:**
- Create: `.vscode/launch.json`

**Step 1: Create launch.json**

Create `.vscode/launch.json`:

```jsonc
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Mock",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_mock.dart"
    },
    {
      "name": "Local",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_local.dart"
    },
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart"
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart"
    }
  ]
}
```

**Step 2: Commit**

```bash
git add .vscode/launch.json
git commit -m "feat: add VS Code launch configs for all 4 environments"
```

---

### Task 5: Design System — Colors (app_colors.dart)

**Files:**
- Create: `lib/core/theme/app_colors.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Sections 1.1 (Brand), 1.2 (Neutral), 1.3 (Semantic), 1.5 (Text), 1.6 (Border)

**Step 1: Create app_colors.dart**

Create `lib/core/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

/// Brand, neutral, semantic, text, and border color tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.1–1.6
abstract final class AppColors {
  // ── Primary: Electric Blue ──────────────────────────────────
  static const primary50 = Color(0xFFEFF6FF);
  static const primary100 = Color(0xFFDBEAFE);
  static const primary200 = Color(0xFFBFDBFE);
  static const primary300 = Color(0xFF93C5FD);
  static const primary400 = Color(0xFF60A5FA);
  static const primary500 = Color(0xFF3B82F6);
  static const primary = Color(0xFF2563EB); // primary600 — main
  static const primary700 = Color(0xFF1D4ED8);
  static const primary800 = Color(0xFF1E40AF);
  static const primary900 = Color(0xFF1E3A8A);

  // ── Secondary: Teal ─────────────────────────────────────────
  static const secondary50 = Color(0xFFF0FDFA);
  static const secondary100 = Color(0xFFCCFBF1);
  static const secondary200 = Color(0xFF99F6E4);
  static const secondary300 = Color(0xFF5EEAD4);
  static const secondary400 = Color(0xFF2DD4BF);
  static const secondary500 = Color(0xFF14B8A6);
  static const secondary = Color(0xFF0D9488); // secondary600 — main
  static const secondary700 = Color(0xFF0F766E);
  static const secondary800 = Color(0xFF115E59);
  static const secondary900 = Color(0xFF134E4A);

  // ── Accent: Vivid Orange ────────────────────────────────────
  static const accent50 = Color(0xFFFFF7ED);
  static const accent100 = Color(0xFFFFEDD5);
  static const accent200 = Color(0xFFFED7AA);
  static const accent300 = Color(0xFFFDBA74);
  static const accent400 = Color(0xFFFB923C);
  static const accent = Color(0xFFF97316); // accent500 — main
  static const accent600 = Color(0xFFEA580C);
  static const accent700 = Color(0xFFC2410C);
  static const accent800 = Color(0xFF9A3412);
  static const accent900 = Color(0xFF7C2D12);

  // ── Neutral: Slate ──────────────────────────────────────────
  static const neutral50 = Color(0xFFF8FAFC);
  static const neutral100 = Color(0xFFF1F5F9);
  static const neutral200 = Color(0xFFE2E8F0);
  static const neutral300 = Color(0xFFCBD5E1);
  static const neutral400 = Color(0xFF94A3B8);
  static const neutral500 = Color(0xFF64748B);
  static const neutral600 = Color(0xFF475569);
  static const neutral700 = Color(0xFF334155);
  static const neutral800 = Color(0xFF1E293B);
  static const neutral900 = Color(0xFF0F172A);

  // ── Semantic ────────────────────────────────────────────────
  static const success = Color(0xFF22C55E);
  static const successLight = Color(0xFFDCFCE7);
  static const successDark = Color(0xFF16A34A);

  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const warningDark = Color(0xFFD97706);

  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const errorDark = Color(0xFFDC2626);

  static const info = Color(0xFF6366F1);
  static const infoLight = Color(0xFFE0E7FF);
  static const infoDark = Color(0xFF4F46E5);

  // ── Text ────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF94A3B8);
  static const textDisabled = Color(0xFFCBD5E1);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnSecondary = Color(0xFF042F2E);
  static const textOnAccent = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textLink = Color(0xFF2563EB);

  // ── Border & Divider ────────────────────────────────────────
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);
  static const borderMedium = Color(0xFFCBD5E1);
  static const borderStrong = Color(0xFF94A3B8);
  static const borderFocused = Color(0xFF2563EB);
  static const borderError = Color(0xFFEF4444);
  static const divider = Color(0xFFE2E8F0);
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_colors.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_colors.dart
git commit -m "feat: add brand, neutral, semantic, text, border color tokens"
```

---

### Task 6: Design System — Domain Colors (app_domain_colors.dart)

**Files:**
- Create: `lib/core/theme/app_domain_colors.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Sections 1.7 (Sport), 1.8 (Booking Status), 1.9 (Level Tier), 1.10 (Rating)

**Step 1: Create app_domain_colors.dart**

Create `lib/core/theme/app_domain_colors.dart`:

```dart
import 'package:flutter/material.dart';

/// Sport, booking status, level tier, and rating color tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.7–1.10
abstract final class AppDomainColors {
  // ── Sport Colors ────────────────────────────────────────────
  // Each sport: (color, background, text)

  // Tennis
  static const tennis = Color(0xFF65A30D);
  static const tennisBg = Color(0xFFF5FAD1);
  static const tennisText = Color(0xFF3F6212);

  // Padel
  static const padel = Color(0xFF7C3AED);
  static const padelBg = Color(0xFFEDE9FE);
  static const padelText = Color(0xFF5B21B6);

  // Badminton
  static const badminton = Color(0xFF0EA5E9);
  static const badmintonBg = Color(0xFFE0F2FE);
  static const badmintonText = Color(0xFF0369A1);

  // Futsal
  static const futsal = Color(0xFFEF4444);
  static const futsalBg = Color(0xFFFEE2E2);
  static const futsalText = Color(0xFFB91C1C);

  // Basketball
  static const basketball = Color(0xFFF97316);
  static const basketballBg = Color(0xFFFFF7ED);
  static const basketballText = Color(0xFFC2410C);

  // Volleyball
  static const volleyball = Color(0xFFEC4899);
  static const volleyballBg = Color(0xFFFCE7F3);
  static const volleyballText = Color(0xFFBE185D);

  // Table Tennis
  static const tableTennis = Color(0xFF14B8A6);
  static const tableTennisBg = Color(0xFFF0FDFA);
  static const tableTennisText = Color(0xFF0F766E);

  // ── Booking Status Colors ───────────────────────────────────
  // Pending Payment → warning
  static const statusPendingPayment = Color(0xFFF59E0B);
  static const statusPendingPaymentBg = Color(0xFFFEF3C7);
  static const statusPendingPaymentText = Color(0xFFD97706);

  // Waiting Confirmation → accent
  static const statusWaitingConfirmation = Color(0xFFF97316);
  static const statusWaitingConfirmationBg = Color(0xFFFFF7ED);
  static const statusWaitingConfirmationText = Color(0xFFC2410C);

  // Confirmed → success
  static const statusConfirmed = Color(0xFF22C55E);
  static const statusConfirmedBg = Color(0xFFDCFCE7);
  static const statusConfirmedText = Color(0xFF16A34A);

  // Rejected → error
  static const statusRejected = Color(0xFFEF4444);
  static const statusRejectedBg = Color(0xFFFEE2E2);
  static const statusRejectedText = Color(0xFFDC2626);

  // Cancelled → neutral
  static const statusCancelled = Color(0xFF94A3B8);
  static const statusCancelledBg = Color(0xFFF1F5F9);
  static const statusCancelledText = Color(0xFF475569);

  // Completed → primary
  static const statusCompleted = Color(0xFF3B82F6);
  static const statusCompletedBg = Color(0xFFDBEAFE);
  static const statusCompletedText = Color(0xFF2563EB);

  // Expired → neutral
  static const statusExpired = Color(0xFF64748B);
  static const statusExpiredBg = Color(0xFFF1F5F9);
  static const statusExpiredText = Color(0xFF334155);

  // ── Level Tier Colors ───────────────────────────────────────
  static const tierRookie = Color(0xFFCD7F32);
  static const tierRookieBg = Color(0xFFFDF2E3);
  static const tierRookieText = Color(0xFF8B5E20);

  static const tierAmateur = Color(0xFF94A3B8);
  static const tierAmateurBg = Color(0xFFF1F5F9);
  static const tierAmateurText = Color(0xFF64748B);

  static const tierIntermediate = Color(0xFFF59E0B);
  static const tierIntermediateBg = Color(0xFFFEF3C7);
  static const tierIntermediateText = Color(0xFFB45309);

  static const tierAdvanced = Color(0xFF38BDF8);
  static const tierAdvancedBg = Color(0xFFE0F2FE);
  static const tierAdvancedText = Color(0xFF0369A1);

  static const tierPro = Color(0xFFA78BFA);
  static const tierProBg = Color(0xFFEDE9FE);
  static const tierProText = Color(0xFF6D28D9);

  // ── Rating ──────────────────────────────────────────────────
  static const ratingStar = Color(0xFFFFC107);
  static const ratingStarHalf = Color(0xFFFFD54F);
  static const ratingStarEmpty = Color(0xFFE2E8F0);
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_domain_colors.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_domain_colors.dart
git commit -m "feat: add sport, booking status, level tier, rating color tokens"
```

---

### Task 7: Design System — Surfaces, Overlays, Gradients (app_surfaces.dart)

**Files:**
- Create: `lib/core/theme/app_surfaces.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Sections 1.4, 1.11, 1.12, 1.13

**Step 1: Create app_surfaces.dart**

Create `lib/core/theme/app_surfaces.dart`:

```dart
import 'package:flutter/material.dart';

/// Surface, overlay, gradient, and dark mode tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.4, 1.11–1.13
abstract final class AppSurfaces {
  // ── Light Surfaces ──────────────────────────────────────────
  static const background = Color(0xFFF8FAFC);
  static const backgroundPure = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const surfaceHighlight = Color(0xFFEFF6FF);
  static const surfaceSecondary = Color(0xFFF0FDFA);
  static const surfaceAccent = Color(0xFFFFF7ED);

  // ── Dark Surfaces ──────────────────────────────────────────
  static const darkBackground = Color(0xFF0F172A);
  static const darkBackgroundPure = Color(0xFF020617);
  static const darkSurface = Color(0xFF1E293B);
  static const darkSurfaceVariant = Color(0xFF334155);
  static const darkSurfaceHighlight = Color(0xFF1E3A5F);
  static const darkSurfaceSecondary = Color(0xFF134E4A);
  static const darkSurfaceAccent = Color(0xFF431407);

  // ── Overlays ────────────────────────────────────────────────
  static final overlay = const Color(0xFF000000).withValues(alpha: 0.50);
  static final overlayLight = const Color(0xFF000000).withValues(alpha: 0.20);
  static final overlayDark = const Color(0xFF000000).withValues(alpha: 0.80);
  static final scrim = const Color(0xFF000000).withValues(alpha: 0.32);
  static final ripple = const Color(0xFF2563EB).withValues(alpha: 0.10);

  // ── Shimmer ─────────────────────────────────────────────────
  static const shimmerBase = Color(0xFFE2E8F0);
  static const shimmerHighlight = Color(0xFFF8FAFC);
  static const darkShimmerBase = Color(0xFF334155);
  static const darkShimmerHighlight = Color(0xFF475569);

  // ── Gradients ───────────────────────────────────────────────
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
  );

  static const energyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
  );

  static const darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)], // 80% black
  );

  static const surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
  );
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_surfaces.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_surfaces.dart
git commit -m "feat: add surface, overlay, gradient, shimmer, dark mode tokens"
```

---

### Task 8: Design System — Typography (app_typography.dart)

**Files:**
- Create: `lib/core/theme/app_typography.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 2 (Typography)

**Step 1: Create app_typography.dart**

Create `lib/core/theme/app_typography.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hyperarena/core/theme/app_colors.dart';

/// Typography tokens using Plus Jakarta Sans.
/// Reference: DESIGN_SYSTEM.md Section 2
abstract final class AppTypography {
  static String? _fontFamily;

  static String get fontFamily {
    _fontFamily ??= GoogleFonts.plusJakartaSans().fontFamily;
    return _fontFamily!;
  }

  // ── Display ─────────────────────────────────────────────────
  static final displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static final displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static final displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  // ── Heading ─────────────────────────────────────────────────
  static final headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static final headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  static final headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ── Title ───────────────────────────────────────────────────
  static final titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static final titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  static final titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  // ── Body ────────────────────────────────────────────────────
  static final bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static final bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static final bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  // ── Label ───────────────────────────────────────────────────
  static final labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static final labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static final labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static final caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static final overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.0,
    color: AppColors.textPrimary,
  );

  // ── Special ─────────────────────────────────────────────────
  static final numberLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static final numberMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final numberSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final priceSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final badgeLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Returns a Material TextTheme built from our design tokens.
  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headingLarge,
      headlineMedium: headingMedium,
      headlineSmall: headingSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_typography.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_typography.dart
git commit -m "feat: add typography tokens with Plus Jakarta Sans"
```

---

### Task 9: Design System — Dimensions (app_dimensions.dart)

**Files:**
- Create: `lib/core/theme/app_dimensions.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 3 (Spacing, Radius, Component Sizes)

**Step 1: Create app_dimensions.dart**

Create `lib/core/theme/app_dimensions.dart`:

```dart
/// Spacing, border radius, and component size tokens.
/// Reference: DESIGN_SYSTEM.md Section 3
abstract final class AppDimensions {
  // ── Spacing Scale (base: 4px) ───────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double massive = 64;

  // ── Screen Padding ──────────────────────────────────────────
  static const double screenHorizontal = 20; // = lg
  static const double screenTop = 16;
  static const double screenBottom = 24;

  // ── Border Radius ───────────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 999;

  // ── Component Sizes ─────────────────────────────────────────
  static const double buttonHeightLg = 56;
  static const double buttonHeightMd = 48;
  static const double buttonHeightSm = 36;
  static const double buttonHeightXs = 28;
  static const double inputHeight = 52;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 72;
  static const double chipHeight = 32;
  static const double chipHeightSm = 24;

  // ── Avatar Sizes ────────────────────────────────────────────
  static const double avatarXs = 24;
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;

  // ── Icon Sizes ──────────────────────────────────────────────
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // ── Misc ────────────────────────────────────────────────────
  static const double badgeSize = 20;
  static const double badgeDot = 8;
  static const double dividerThickness = 1;
  static const double strokeWidth = 1.5;
  static const double strokeWidthThick = 2;
  static const double cardMinHeight = 80;
  static const double maxContentWidth = 600;

  // ── Aspect Ratios (as doubles for use in AspectRatio widget) ──
  static const double imageAspectVenue = 16 / 9;
  static const double imageAspectAvatar = 1;
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_dimensions.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_dimensions.dart
git commit -m "feat: add spacing, radius, and component size tokens"
```

---

### Task 10: Design System — Shadows (app_shadows.dart)

**Files:**
- Create: `lib/core/theme/app_shadows.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 4 (Shadows/Elevation)

**Step 1: Create app_shadows.dart**

Create `lib/core/theme/app_shadows.dart`:

```dart
import 'package:flutter/material.dart';

/// Shadow/elevation tokens.
/// Reference: DESIGN_SYSTEM.md Section 4
abstract final class AppShadows {
  static const _base = Color(0xFF0F172A);

  static final none = <BoxShadow>[];

  static final xs = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 2,
      color: _base.withValues(alpha: 0.05),
    ),
  ];

  static final sm = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 3,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final md = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final lg = [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final xl = [
    BoxShadow(
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final bottomNav = [
    BoxShadow(
      offset: const Offset(0, -4),
      blurRadius: 12,
      color: _base.withValues(alpha: 0.08),
    ),
  ];

  static final button = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 4,
      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
    ),
  ];

  static final colored = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 12,
      color: const Color(0xFF2563EB).withValues(alpha: 0.20),
    ),
  ];

  static final focusRing = [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 3,
      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
    ),
  ];
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_shadows.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_shadows.dart
git commit -m "feat: add shadow and elevation tokens"
```

---

### Task 11: Design System — Animations (app_animations.dart)

**Files:**
- Create: `lib/core/theme/app_animations.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 5 (Animation/Motion)

**Step 1: Create app_animations.dart**

Create `lib/core/theme/app_animations.dart`:

```dart
import 'package:flutter/material.dart';

/// Duration and curve tokens for animations.
/// Reference: DESIGN_SYSTEM.md Section 5
abstract final class AppAnimations {
  // ── Durations ───────────────────────────────────────────────
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 400);
  static const xSlow = Duration(milliseconds: 600);

  // ── Curves ──────────────────────────────────────────────────
  static const standard = Curves.easeInOut;
  static const decelerate = Curves.easeOut;
  static const accelerate = Curves.easeIn;
  static const sharp = Curves.easeInOutCubic;
  static const bounce = Curves.bounceOut;
  static const elastic = Curves.elasticOut;
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_animations.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_animations.dart
git commit -m "feat: add animation duration and curve tokens"
```

---

### Task 12: Design System — Enums (app_enums.dart)

**Files:**
- Create: `lib/core/theme/app_enums.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 8, Architecture doc Section 5.2

**Step 1: Create app_enums.dart**

Create `lib/core/theme/app_enums.dart`:

```dart
/// Type-safe domain enums shared between theme and data layers.
/// Reference: DESIGN_SYSTEM.md Section 8, Architecture Section 5.2
enum Sport {
  tennis,
  padel,
  badminton,
  futsal,
  basketball,
  volleyball,
  tableTennis,
}

enum BookingStatus {
  pendingPayment,
  waitingConfirmation,
  confirmed,
  rejected,
  cancelled,
  completed,
  expired,
}

enum BookingType { court, coaching, openSession }

enum LevelTier { rookie, amateur, intermediate, advanced, pro }

enum UserRole { player, coach, organizer }

enum PaymentMethodType { qris, bankTransfer }
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_enums.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_enums.dart
git commit -m "feat: add type-safe domain enums (Sport, BookingStatus, LevelTier, etc.)"
```

---

### Task 13: Design System — Theme Extensions (app_theme_extensions.dart)

**Files:**
- Create: `lib/core/theme/app_theme_extensions.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 8 (Theme Extensions)

**Step 1: Create app_theme_extensions.dart**

Create `lib/core/theme/app_theme_extensions.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_domain_colors.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

/// Custom ThemeExtension for sport-specific colors.
/// Reference: DESIGN_SYSTEM.md Section 8.1
class SportThemeExtension extends ThemeExtension<SportThemeExtension> {
  const SportThemeExtension();

  Color color(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennis,
    Sport.padel => AppDomainColors.padel,
    Sport.badminton => AppDomainColors.badminton,
    Sport.futsal => AppDomainColors.futsal,
    Sport.basketball => AppDomainColors.basketball,
    Sport.volleyball => AppDomainColors.volleyball,
    Sport.tableTennis => AppDomainColors.tableTennis,
  };

  Color backgroundColor(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennisBg,
    Sport.padel => AppDomainColors.padelBg,
    Sport.badminton => AppDomainColors.badmintonBg,
    Sport.futsal => AppDomainColors.futsalBg,
    Sport.basketball => AppDomainColors.basketballBg,
    Sport.volleyball => AppDomainColors.volleyballBg,
    Sport.tableTennis => AppDomainColors.tableTennisBg,
  };

  Color textColor(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennisText,
    Sport.padel => AppDomainColors.padelText,
    Sport.badminton => AppDomainColors.badmintonText,
    Sport.futsal => AppDomainColors.futsalText,
    Sport.basketball => AppDomainColors.basketballText,
    Sport.volleyball => AppDomainColors.volleyballText,
    Sport.tableTennis => AppDomainColors.tableTennisText,
  };

  @override
  SportThemeExtension copyWith() => const SportThemeExtension();

  @override
  SportThemeExtension lerp(covariant SportThemeExtension? other, double t) =>
      const SportThemeExtension();
}

/// Custom ThemeExtension for booking status colors.
/// Reference: DESIGN_SYSTEM.md Section 8.2
class BookingStatusThemeExtension
    extends ThemeExtension<BookingStatusThemeExtension> {
  const BookingStatusThemeExtension();

  Color color(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPayment,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmation,
    BookingStatus.confirmed => AppDomainColors.statusConfirmed,
    BookingStatus.rejected => AppDomainColors.statusRejected,
    BookingStatus.cancelled => AppDomainColors.statusCancelled,
    BookingStatus.completed => AppDomainColors.statusCompleted,
    BookingStatus.expired => AppDomainColors.statusExpired,
  };

  Color backgroundColor(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPaymentBg,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmationBg,
    BookingStatus.confirmed => AppDomainColors.statusConfirmedBg,
    BookingStatus.rejected => AppDomainColors.statusRejectedBg,
    BookingStatus.cancelled => AppDomainColors.statusCancelledBg,
    BookingStatus.completed => AppDomainColors.statusCompletedBg,
    BookingStatus.expired => AppDomainColors.statusExpiredBg,
  };

  Color textColor(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPaymentText,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmationText,
    BookingStatus.confirmed => AppDomainColors.statusConfirmedText,
    BookingStatus.rejected => AppDomainColors.statusRejectedText,
    BookingStatus.cancelled => AppDomainColors.statusCancelledText,
    BookingStatus.completed => AppDomainColors.statusCompletedText,
    BookingStatus.expired => AppDomainColors.statusExpiredText,
  };

  @override
  BookingStatusThemeExtension copyWith() =>
      const BookingStatusThemeExtension();

  @override
  BookingStatusThemeExtension lerp(
    covariant BookingStatusThemeExtension? other,
    double t,
  ) => const BookingStatusThemeExtension();
}

/// Custom ThemeExtension for gamification/level tier colors.
/// Reference: DESIGN_SYSTEM.md Section 8.3
class GamificationThemeExtension
    extends ThemeExtension<GamificationThemeExtension> {
  const GamificationThemeExtension();

  Color levelColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookie,
    LevelTier.amateur => AppDomainColors.tierAmateur,
    LevelTier.intermediate => AppDomainColors.tierIntermediate,
    LevelTier.advanced => AppDomainColors.tierAdvanced,
    LevelTier.pro => AppDomainColors.tierPro,
  };

  Color levelBackgroundColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookieBg,
    LevelTier.amateur => AppDomainColors.tierAmateurBg,
    LevelTier.intermediate => AppDomainColors.tierIntermediateBg,
    LevelTier.advanced => AppDomainColors.tierAdvancedBg,
    LevelTier.pro => AppDomainColors.tierProBg,
  };

  Color levelTextColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookieText,
    LevelTier.amateur => AppDomainColors.tierAmateurText,
    LevelTier.intermediate => AppDomainColors.tierIntermediateText,
    LevelTier.advanced => AppDomainColors.tierAdvancedText,
    LevelTier.pro => AppDomainColors.tierProText,
  };

  @override
  GamificationThemeExtension copyWith() =>
      const GamificationThemeExtension();

  @override
  GamificationThemeExtension lerp(
    covariant GamificationThemeExtension? other,
    double t,
  ) => const GamificationThemeExtension();
}

/// Custom ThemeExtension for star rating colors.
/// Reference: DESIGN_SYSTEM.md Section 8.4
class RatingThemeExtension extends ThemeExtension<RatingThemeExtension> {
  final Color starColor;
  final Color halfStarColor;
  final Color emptyStarColor;

  const RatingThemeExtension({
    this.starColor = const Color(0xFFFFC107),
    this.halfStarColor = const Color(0xFFFFD54F),
    this.emptyStarColor = const Color(0xFFE2E8F0),
  });

  @override
  RatingThemeExtension copyWith({
    Color? starColor,
    Color? halfStarColor,
    Color? emptyStarColor,
  }) {
    return RatingThemeExtension(
      starColor: starColor ?? this.starColor,
      halfStarColor: halfStarColor ?? this.halfStarColor,
      emptyStarColor: emptyStarColor ?? this.emptyStarColor,
    );
  }

  @override
  RatingThemeExtension lerp(
    covariant RatingThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return RatingThemeExtension(
      starColor: Color.lerp(starColor, other.starColor, t)!,
      halfStarColor: Color.lerp(halfStarColor, other.halfStarColor, t)!,
      emptyStarColor: Color.lerp(emptyStarColor, other.emptyStarColor, t)!,
    );
  }
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_theme_extensions.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_theme_extensions.dart
git commit -m "feat: add theme extensions for sport, booking, gamification, rating"
```

---

### Task 14: Design System — Light Theme (app_theme.dart)

**Files:**
- Create: `lib/core/theme/app_theme.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 6 (Component Themes)

**Step 1: Create app_theme.dart**

Create `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';

/// Light ThemeData builder.
/// Reference: DESIGN_SYSTEM.md Section 6
abstract final class AppTheme {
  static ThemeData light() {
    final textTheme = AppTypography.textTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,

      // ColorScheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textOnAccent,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppSurfaces.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppSurfaces.surfaceVariant,
        outline: AppColors.border,
        outlineVariant: AppColors.borderLight,
      ),

      scaffoldBackgroundColor: AppSurfaces.background,

      // AppBar — Section 6.1
      appBarTheme: AppBarTheme(
        backgroundColor: AppSurfaces.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTypography.headingMedium,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // Bottom Navigation — Section 6.2
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppSurfaces.surface,
        height: AppDimensions.bottomNavHeight,
        indicatorColor: AppColors.primary50,
        labelTextStyle: WidgetStatePropertyAll(AppTypography.labelMedium),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.neutral400);
        }),
      ),

      // Cards — Section 6.3
      cardTheme: CardThemeData(
        color: AppSurfaces.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: const EdgeInsets.symmetric(vertical: AppDimensions.md / 2),
      ),

      // Elevated Button — Section 6.4 primary CTA
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          textStyle: AppTypography.button,
          disabledBackgroundColor: AppColors.neutral200,
          disabledForegroundColor: AppColors.textDisabled,
        ),
      ),

      // Outlined Button — Section 6.4 secondary
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: AppTypography.button,
        ),
      ),

      // Text Button — Section 6.4 tertiary
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),

      // Input Fields — Section 6.5
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppSurfaces.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderError, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderError, width: 2),
        ),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
        prefixIconColor: AppColors.neutral400,
        suffixIconColor: AppColors.neutral400,
      ),

      // Chips — Section 6.6
      chipTheme: ChipThemeData(
        backgroundColor: AppSurfaces.surfaceVariant,
        selectedColor: AppColors.primary50,
        labelStyle: AppTypography.labelMedium,
        side: const BorderSide(color: AppColors.border),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Tab Bar — Section 6.7
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        labelStyle: AppTypography.labelLarge,
        unselectedLabelStyle: AppTypography.labelLarge,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: AppColors.primary, width: 3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
      ),

      // Dialog — Section 6.8
      dialogTheme: DialogThemeData(
        backgroundColor: AppSurfaces.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        titleTextStyle: AppTypography.headingSmall,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Bottom Sheet — Section 6.9
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppSurfaces.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
      ),

      // Snackbar — Section 6.10
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral800,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textOnDark,
        ),
        actionTextColor: AppColors.primary300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(16),
      ),

      // Switch — Section 6.11
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return AppColors.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.neutral200;
        }),
      ),

      // Checkbox — Section 6.12
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: AppColors.borderMedium, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),

      // Radio — Section 6.12
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.borderMedium;
        }),
      ),

      // Slider — Section 6.13
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.neutral200,
        thumbColor: AppColors.primary,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
      ),

      // Progress Indicator — Section 6.14
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.neutral200,
        linearMinHeight: 4,
      ),

      // Divider — Section 6.16
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppDimensions.dividerThickness,
        space: 0,
      ),

      // Tooltip — Section 6.17
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral800,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        textStyle: AppTypography.bodySmall.copyWith(color: Colors.white),
      ),

      // FAB — Section 6.4
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        sizeConstraints: const BoxConstraints.tightFor(width: 56, height: 56),
      ),

      // Theme Extensions
      extensions: const [
        SportThemeExtension(),
        BookingStatusThemeExtension(),
        GamificationThemeExtension(),
        RatingThemeExtension(),
      ],
    );
  }
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_theme.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_theme.dart
git commit -m "feat: add light ThemeData builder with all component themes"
```

---

### Task 15: Design System — Dark Theme (app_theme_dark.dart)

**Files:**
- Create: `lib/core/theme/app_theme_dark.dart`

**Reference:** `docs/DESIGN_SYSTEM.md` — Section 1.13 (Dark Mode)

**Step 1: Create app_theme_dark.dart**

Create `lib/core/theme/app_theme_dark.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_theme.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';

/// Dark ThemeData builder.
/// Reference: DESIGN_SYSTEM.md Section 1.13
extension AppThemeDark on AppTheme {
  static ThemeData dark() {
    final light = AppTheme.light();

    return light.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppSurfaces.darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textOnSecondary,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textOnAccent,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppSurfaces.darkSurface,
        onSurface: Color(0xFFF1F5F9), // textPrimary dark
        surfaceContainerHighest: AppSurfaces.darkSurfaceVariant,
        outline: Color(0xFF334155), // border dark
        outlineVariant: Color(0xFF1E293B), // borderLight dark
      ),

      // AppBar
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
        titleTextStyle: AppTypography.headingMedium.copyWith(
          color: const Color(0xFFF1F5F9),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF1F5F9)),
      ),

      // Navigation Bar
      navigationBarTheme: light.navigationBarTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
        indicatorColor: AppColors.primary900,
      ),

      // Cards
      cardTheme: light.cardTheme.copyWith(
        color: AppSurfaces.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),

      // Input
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        fillColor: AppSurfaces.darkSurfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFF334155), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 2),
        ),
      ),

      // Dialog
      dialogTheme: light.dialogTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
      ),

      // Bottom Sheet
      bottomSheetTheme: light.bottomSheetTheme.copyWith(
        backgroundColor: AppSurfaces.darkSurface,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: AppDimensions.dividerThickness,
        space: 0,
      ),

      // Tooltip
      tooltipTheme: light.tooltipTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
        textStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.neutral900,
        ),
      ),

      // Extensions — same as light (brand colors don't change in dark mode)
      extensions: const [
        SportThemeExtension(),
        BookingStatusThemeExtension(),
        GamificationThemeExtension(),
        RatingThemeExtension(),
      ],
    );
  }
}
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/core/theme/app_theme_dark.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/app_theme_dark.dart
git commit -m "feat: add dark ThemeData builder"
```

---

### Task 16: Design System — Barrel Export (theme.dart)

**Files:**
- Create: `lib/core/theme/theme.dart`

**Step 1: Create barrel export**

Create `lib/core/theme/theme.dart`:

```dart
/// Barrel export for all design system tokens.
library;

export 'app_animations.dart';
export 'app_colors.dart';
export 'app_dimensions.dart';
export 'app_domain_colors.dart';
export 'app_enums.dart';
export 'app_shadows.dart';
export 'app_surfaces.dart';
export 'app_theme.dart';
export 'app_theme_dark.dart';
export 'app_theme_extensions.dart';
export 'app_typography.dart';
```

**Step 2: Run flutter analyze on entire project**

Run: `flutter analyze`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/core/theme/theme.dart
git commit -m "feat: add theme barrel export"
```

---

### Task 17: Core Widgets — AsyncValueWidget

**Files:**
- Create: `lib/core/widgets/async_value_widget.dart`

**Step 1: Create AsyncValueWidget**

Create `lib/core/widgets/async_value_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic handler for AsyncValue — provides loading, error, and data states.
/// Usage: AsyncValueWidget(value: ref.watch(myProvider), data: (data) => ...)
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
      error: error ??
          (e, st) => Center(
                child: Text('Error: $e'),
              ),
      data: data,
    );
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/widgets/async_value_widget.dart
git commit -m "feat: add generic AsyncValueWidget for Riverpod"
```

---

### Task 18: Core Widgets — AppButton

**Files:**
- Create: `lib/core/widgets/app_button.dart`

**Step 1: Create AppButton**

Create `lib/core/widgets/app_button.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

enum AppButtonVariant { elevated, outlined, text, tonal }

/// Standardized button component.
/// Reference: DESIGN_SYSTEM.md Section 6.4
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isLarge;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.elevated,
    this.isLoading = false,
    this.isLarge = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        isLarge ? AppDimensions.buttonHeightLg : AppDimensions.buttonHeightMd;

    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppDimensions.iconSm),
                  const SizedBox(width: AppDimensions.sm),
                  Text(label),
                ],
              )
            : Text(label);

    final effectiveOnPressed = isLoading ? null : onPressed;

    return SizedBox(
      height: height,
      child: switch (variant) {
        AppButtonVariant.elevated => ElevatedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.outlined => OutlinedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.text => TextButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.tonal => FilledButton.tonal(
            onPressed: effectiveOnPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary50,
              foregroundColor: AppColors.primary700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: child,
          ),
      },
    );
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/widgets/app_button.dart
git commit -m "feat: add AppButton with elevated, outlined, text, tonal variants"
```

---

### Task 19: Core Widgets — EmptyState + ErrorView

**Files:**
- Create: `lib/core/widgets/empty_state.dart`
- Create: `lib/core/widgets/error_view.dart`

**Step 1: Create EmptyState**

Create `lib/core/widgets/empty_state.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimensions.iconXl, color: AppColors.neutral300),
            const SizedBox(height: AppDimensions.base),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.base),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Create ErrorView**

Create `lib/core/widgets/error_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconXl,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.base),
            Text(
              'Terjadi kesalahan',
              style: AppTypography.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              error.toString(),
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.base),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

**Step 3: Commit**

```bash
git add lib/core/widgets/empty_state.dart lib/core/widgets/error_view.dart
git commit -m "feat: add EmptyState and ErrorView reusable widgets"
```

---

### Task 20: Routing — Player Shell + App Router

**Files:**
- Create: `lib/routing/app_router.dart`

**Reference:** Architecture doc Section 6 (Routing)

**Step 1: Create app_router.dart with Player shell only**

Create `lib/routing/app_router.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

/// Placeholder screens for Phase 0 — replaced by real screens in Phase 1+
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

/// Role-aware bottom navigation shell.
/// Reference: Architecture doc Section 6.2
class RoleShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final UserRole role;

  const RoleShell({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: _destinations(role),
      ),
    );
  }

  List<NavigationDestination> _destinations(UserRole role) => switch (role) {
    UserRole.player => const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Explore',
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined),
        selectedIcon: Icon(Icons.calendar_today),
        label: 'Bookings',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    UserRole.coach => const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.schedule_outlined),
        selectedIcon: Icon(Icons.schedule),
        label: 'Schedule',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Students',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    UserRole.organizer => const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.event_outlined),
        selectedIcon: Icon(Icons.event),
        label: 'Sessions',
      ),
      NavigationDestination(
        icon: Icon(Icons.group_outlined),
        selectedIcon: Icon(Icons.group),
        label: 'Community',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  };
}

/// Phase 0 router — Player shell only, placeholder screens.
/// Coach and Organizer shells added in Phase 2+3.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/player/home',
    routes: [
      // Player shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.player,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/home',
              builder: (_, __) => const _PlaceholderScreen(title: 'Home'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/explore',
              builder: (_, __) => const _PlaceholderScreen(title: 'Explore'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/bookings',
              builder: (_, __) => const _PlaceholderScreen(title: 'Bookings'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/profile',
              builder: (_, __) => const _PlaceholderScreen(title: 'Profile'),
            ),
          ]),
        ],
      ),
    ],
  );
});
```

**Step 2: Verify file compiles**

Run: `flutter analyze lib/routing/app_router.dart`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/routing/app_router.dart
git commit -m "feat: add GoRouter with Player shell and placeholder screens"
```

---

### Task 21: Wire Up App — Theme + Router in app.dart

**Files:**
- Modify: `lib/app.dart` (replace placeholder)

**Step 1: Update app.dart with full theme + routing**

Replace all of `lib/app.dart` with:

```dart
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
```

**Step 2: Run flutter analyze on entire project**

Run: `flutter analyze`
Expected: No errors

**Step 3: Commit**

```bash
git add lib/app.dart
git commit -m "feat: wire up theme + routing in HyperArenaApp"
```

---

### Task 22: Full Build Test + Clean Up

**Step 1: Run flutter analyze**

Run: `cd D:\projects\Flutter\hyperarena && flutter analyze`
Expected: No errors

**Step 2: Test mock launch (verify app builds)**

Run: `flutter build apk --debug -t lib/main_mock.dart`
Expected: Build succeeds. If emulator/device is available, also try:
Run: `flutter run -t lib/main_mock.dart`
Expected: App launches showing Player shell with 4 bottom nav tabs (Home, Explore, Bookings, Profile). Tapping each tab shows a placeholder screen.

**Step 3: Delete default test file if broken**

The default `test/widget_test.dart` references the old `MyApp` widget which no longer exists. Delete it:

Run: `rm test/widget_test.dart` (or delete manually)

Then run analyze again:
Run: `flutter analyze`
Expected: No errors

**Step 4: Final commit**

```bash
git add -A
git commit -m "chore: clean up default test, Phase 0 foundation complete"
```

**Step 5: Push to remote**

```bash
git push origin main
```

---

## Phase 0 Deliverables Checklist

After completing all tasks above, the app should have:

- [x] `core/config/app_config.dart` — 4 environments (mock/local/dev/prod)
- [x] `shared/providers/app_config_provider.dart` — Riverpod providers for DI
- [x] `app_bootstrap.dart` — shared bootstrap with ProviderScope
- [x] `main.dart` + `main_mock.dart` + `main_local.dart` + `main_dev.dart`
- [x] `.vscode/launch.json` — 4 launch configs
- [x] `core/theme/app_colors.dart` — brand, neutral, semantic, text, border
- [x] `core/theme/app_domain_colors.dart` — sport, booking, level, rating
- [x] `core/theme/app_surfaces.dart` — surfaces, overlays, gradients, shimmer
- [x] `core/theme/app_typography.dart` — Plus Jakarta Sans type scale
- [x] `core/theme/app_dimensions.dart` — spacing, radius, component sizes
- [x] `core/theme/app_shadows.dart` — shadow tokens
- [x] `core/theme/app_animations.dart` — duration + curve tokens
- [x] `core/theme/app_enums.dart` — Sport, BookingStatus, LevelTier, etc.
- [x] `core/theme/app_theme_extensions.dart` — 4 custom theme extensions
- [x] `core/theme/app_theme.dart` — full light ThemeData
- [x] `core/theme/app_theme_dark.dart` — full dark ThemeData
- [x] `core/theme/theme.dart` — barrel export
- [x] `core/widgets/async_value_widget.dart` — generic .when() handler
- [x] `core/widgets/app_button.dart` — 4-variant button
- [x] `core/widgets/empty_state.dart` — empty state placeholder
- [x] `core/widgets/error_view.dart` — error with retry
- [x] `routing/app_router.dart` — Player shell with 4 tabs + RoleShell
- [x] `app.dart` — MaterialApp.router with theme + routing
- [x] App launches in mock mode with themed Player bottom nav

**Total files created:** 24
**Total commits:** ~18

---

*Plan Version: 1.0*
*Phase: 0 — Foundation*
*Reference: Architecture Design v1.0, DESIGN_SYSTEM.md v1.0*
