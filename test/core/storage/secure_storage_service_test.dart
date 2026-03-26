import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

void main() {
  late SecureStorageService service;

  setUp(() {
    service = SecureStorageService.forTesting();
  });

  group('Bearer token', () {
    test('getToken returns null when empty', () {
      expect(service.getToken(), isNull);
    });

    test('saveToken updates cache synchronously', () async {
      await service.saveToken('bearer-123');
      expect(service.getToken(), equals('bearer-123'));
    });

    test('deleteToken clears cache', () async {
      await service.saveToken('bearer-123');
      await service.deleteToken();
      expect(service.getToken(), isNull);
    });
  });

  group('FCM token', () {
    test('getFcmToken returns null when empty', () {
      expect(service.getFcmToken(), isNull);
    });

    test('saveFcmToken updates cache synchronously', () async {
      await service.saveFcmToken('fcm-abc');
      expect(service.getFcmToken(), equals('fcm-abc'));
    });

    test('deleteFcmToken clears cache', () async {
      await service.saveFcmToken('fcm-abc');
      await service.deleteFcmToken();
      expect(service.getFcmToken(), isNull);
    });
  });

  group('Tenant slug', () {
    test('getTenantSlug returns null when empty', () {
      expect(service.getTenantSlug(), isNull);
    });

    test('saveTenantSlug updates cache synchronously', () async {
      await service.saveTenantSlug('skateschool');
      expect(service.getTenantSlug(), equals('skateschool'));
    });

    test('deleteTenantSlug clears cache', () async {
      await service.saveTenantSlug('skateschool');
      await service.deleteTenantSlug();
      expect(service.getTenantSlug(), isNull);
    });
  });
}
