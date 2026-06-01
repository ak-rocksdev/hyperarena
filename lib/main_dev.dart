/// Dev-environment entry point.
///
/// Same code as `main.dart` — env-specific config (API base URL, tenant
/// slug, env name) is injected via `--dart-define` at build time. Use this
/// target with `flutter run --target=lib/main_dev.dart --dart-define=...`
/// or `flutter build apk --target=lib/main_dev.dart --dart-define=...`.
///
/// See `scripts/build-dev.ps1` (or `releases/README.md`) for the canonical
/// dart-defines for the dev build (APP_ENV=dev, API_BASE_URL=…/devapp/…).
///
/// Visible difference vs the prod build: a green "DEV" corner ribbon
/// rendered by `app.dart` when `AppEnv.isDev` is true, so testers can tell
/// at a glance which build they're holding.
import 'package:hyperarena/app_bootstrap.dart';

void main() => bootstrap();
