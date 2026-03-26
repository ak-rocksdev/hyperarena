// test/features/auth/data/mappers/auth_response_mapper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';

void main() {
  group('parseLoginResponse', () {
    test('parses user and token from login response', () {
      final json = {
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '+628123456789',
          'locale': 'en',
          'active_role': 'member',
          'tenant_id': 1,
          'photo_path': 'users/1/photo.jpg',
          'roles': [{'name': 'member'}],
          'permissions': [{'name': 'view-sessions'}],
          'tenant': {
            'id': 1,
            'name': 'Skate School',
            'slug': 'skateschool',
            'sport': {'id': 1, 'name': 'Skating'},
          },
          'student_account': null,
          'student_guardians': [],
        },
        'token': '1|abc123',
      };

      final (user, token) = parseLoginResponse(json);

      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '+628123456789');
      expect(user.role, UserRole.player);
      expect(user.activeRole, 'member');
      expect(user.tenantId, 1);
      expect(user.tenantSlug, 'skateschool');
      expect(user.tenantName, 'Skate School');
      expect(user.locale, 'en');
      expect(token.token, '1|abc123');
    });

    test('handles super-admin with null tenant', () {
      final json = {
        'user': {
          'id': 99,
          'name': 'Super Admin',
          'email': 'admin@hypercoach.com',
          'phone': null,
          'locale': 'en',
          'active_role': 'super-admin',
          'tenant_id': null,
          'photo_path': null,
          'roles': [{'name': 'super-admin'}],
          'permissions': [],
          'tenant': null,
          'student_account': null,
          'student_guardians': [],
        },
        'token': '2|xyz789',
      };

      final (user, token) = parseLoginResponse(json);

      expect(user.id, '99');
      expect(user.role, UserRole.organizer);
      expect(user.activeRole, 'super-admin');
      expect(user.tenantId, isNull);
      expect(user.tenantSlug, isNull);
      expect(user.tenantName, isNull);
      expect(token.token, '2|xyz789');
    });
  });

  group('parseUserResponse', () {
    test('parses user from /auth/me response', () {
      final json = {
        'id': 5,
        'name': 'Coach Mike',
        'email': 'mike@example.com',
        'phone': '+628111222333',
        'locale': 'id',
        'active_role': 'coach',
        'tenant_id': 2,
        'photo_path': null,
        'roles': [{'name': 'coach'}],
        'permissions': [],
        'tenant': {
          'id': 2,
          'name': 'Tennis Club',
          'slug': 'tennisclub',
          'sport': {'id': 2, 'name': 'Tennis'},
        },
        'student_account': null,
        'student_guardians': [],
      };

      final user = parseUserResponse(json);

      expect(user.id, '5');
      expect(user.name, 'Coach Mike');
      expect(user.role, UserRole.coach);
      expect(user.activeRole, 'coach');
      expect(user.tenantSlug, 'tennisclub');
    });
  });
}
