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
    showDebugBanner: false,
    mockDelay: Duration(milliseconds: 500),
  );

  static const local = AppConfig(
    environment: Environment.local,
    apiBaseUrl: 'http://10.142.152.40:8080/api',
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
