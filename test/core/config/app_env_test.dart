import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/config/app_env.dart';

void main() {
  group('AppEnv defaults (no --dart-define)', () {
    test('name defaults to production', () {
      expect(AppEnv.name, 'production');
    });

    test('apiBaseUrl defaults to VPS production URL', () {
      expect(
        AppEnv.apiBaseUrl,
        'https://api.hyperarena.hyperscore.cloud/api/v1',
      );
    });

    test('defaultTenantSlug defaults to petenis-kelana', () {
      expect(AppEnv.defaultTenantSlug, 'petenis-kelana');
    });

    test('httpTimeout is 30 seconds', () {
      expect(AppEnv.httpTimeout, const Duration(seconds: 30));
    });
  });

  group('AppEnv environment helpers', () {
    test('isProduction is true when name == production', () {
      expect(AppEnv.isProduction, true);
    });

    test('isLocal is false when name == production', () {
      expect(AppEnv.isLocal, false);
    });
  });
}
