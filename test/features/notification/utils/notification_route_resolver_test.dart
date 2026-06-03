import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/notification/utils/notification_route_resolver.dart';
import 'package:hyperarena/routing/app_routes.dart';

void main() {
  late NotificationRouteResolver resolver;

  setUp(() => resolver = NotificationRouteResolver());

  test('booking_confirmed resolves to session route', () {
    final route = resolver.resolve('booking_confirmed', {'session_id': '42'});
    expect(route, '/session/42');
  });

  test('session_reminder resolves to session route', () {
    final route = resolver.resolve('session_reminder', {'session_id': '7'});
    expect(route, '/session/7');
  });

  test('progress_updated resolves to session route', () {
    final route = resolver.resolve('progress_updated', {'session_id': '15'});
    expect(route, '/session/15');
  });

  test('purchase_confirmed resolves to notifications', () {
    final route = resolver.resolve('purchase_confirmed', {});
    expect(route, '/notifications');
  });

  test('payout_approved resolves to organizer earnings', () {
    final route = resolver.resolve('payout_approved', {});
    expect(route, '/organizer/earnings');
  });

  test('payment_rejected resolves to notifications', () {
    final route = resolver.resolve('payment_rejected', {});
    expect(route, '/notifications');
  });

  test('unknown type returns null', () {
    final route = resolver.resolve('some_unknown_type', {});
    expect(route, isNull);
  });

  test('null type returns null', () {
    final route = resolver.resolve(null, {});
    expect(route, isNull);
  });

  test('session type with missing session_id returns null', () {
    final route = resolver.resolve('booking_confirmed', {});
    expect(route, isNull);
  });

  test('coach_assigned_to_session resolves to /coach/sessions/{id}', () {
    final route = resolver.resolve(
      'coach_assigned_to_session',
      {'session_id': '42'},
    );
    expect(route, AppRoutes.coachSessionDetail('42'));
  });

  test('session_schedule_change resolves to /coach/sessions/{id}', () {
    final route = resolver.resolve(
      'session_schedule_change',
      {'session_id': '7'},
    );
    expect(route, AppRoutes.coachSessionDetail('7'));
  });

  test('assessment_reminder resolves to /coach/sessions/{id}', () {
    final route = resolver.resolve(
      'assessment_reminder',
      {'session_id': '99'},
    );
    expect(route, AppRoutes.coachSessionDetail('99'));
  });

  test('coach_assigned_to_session returns null when session_id missing', () {
    final route = resolver.resolve(
      'coach_assigned_to_session',
      {},
    );
    expect(route, isNull);
  });
}
