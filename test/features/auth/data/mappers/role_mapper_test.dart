// test/features/auth/data/mappers/role_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';

void main() {
  group('mapBackendRole', () {
    test('maps "member" to player', () {
      expect(mapBackendRole('member'), UserRole.player);
    });

    test('maps "coach" to coach', () {
      expect(mapBackendRole('coach'), UserRole.coach);
    });

    test('maps "admin" to organizer', () {
      expect(mapBackendRole('admin'), UserRole.organizer);
    });

    test('maps "super-admin" to organizer', () {
      expect(mapBackendRole('super-admin'), UserRole.organizer);
    });

    test('maps null to player (safe default)', () {
      expect(mapBackendRole(null), UserRole.player);
    });

    test('maps unknown string to player (safe default)', () {
      expect(mapBackendRole('unknown-role'), UserRole.player);
    });
  });
}
