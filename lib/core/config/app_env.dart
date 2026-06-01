/// Application environment configuration.
///
/// All values are compile-time constants populated via `--dart-define`.
/// Defaults point to production so that a flagless `flutter run` or release
/// build is always safe (never accidentally points at localhost).
///
/// To switch environments, use the helper scripts in `scripts/` or the
/// VS Code Run configurations in `.vscode/launch.json`.
class AppEnv {
  static const String name = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.hyperarena.hyperscore.cloud/api',
  );

  static const String defaultTenantSlug = String.fromEnvironment(
    'DEFAULT_TENANT_SLUG',
    defaultValue: 'petenis-kelana',
  );

  static const Duration httpTimeout = Duration(seconds: 30);

  static bool get isLocal => name == 'local';
  static bool get isDev => name == 'dev';
  static bool get isProduction => name == 'production';
}
