import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';

void main() {
  test('UnauthorizedException has statusCode 401', () {
    final e = UnauthorizedException('Unauthenticated.');
    expect(e.statusCode, 401);
    expect(e.message, 'Unauthenticated.');
    expect(e.toString(), contains('401'));
  });

  test('ValidationException carries errors map', () {
    final e = ValidationException(
      'The email field is required.',
      errors: {'email': ['The email field is required.']},
    );
    expect(e.statusCode, 422);
    expect(e.errors['email'], isNotEmpty);
  });

  test('ForbiddenException has statusCode 403', () {
    final e = ForbiddenException('Forbidden.');
    expect(e.statusCode, 403);
  });

  test('NotFoundException has statusCode 404', () {
    final e = NotFoundException('Not found.');
    expect(e.statusCode, 404);
  });

  test('ServerException has statusCode 500', () {
    final e = ServerException('Internal server error.', statusCode: 502);
    expect(e.statusCode, 502);
  });
}
