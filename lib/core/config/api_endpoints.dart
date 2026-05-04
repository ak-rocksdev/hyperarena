/// API endpoint path constants, grouped by resource.
///
/// Paths are relative — combine with `AppEnv.apiBaseUrl` to form the full URL:
/// `'${AppEnv.apiBaseUrl}${ApiEndpoints.authLogin}'`
///
/// Convention: `{resourceGroup}{Action}` in camelCase, with parameterized paths
/// exposed as `static String x(int id) => '/path/$id'`.
///
/// This is a seed file — existing repositories continue to use inline path
/// strings. New endpoints should be added here.
class ApiEndpoints {
  // Auth
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authSwitchRole = '/auth/switch-role';
  static const String authDeviceToken = '/auth/device-token';

  // Public
  static const String plans = '/plans';
  static const String sports = '/sports';
  static const String arenas = '/arenas';
}
