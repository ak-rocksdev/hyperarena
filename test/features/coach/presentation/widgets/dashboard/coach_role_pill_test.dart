import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_role_pill.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);
  final User? _user;
  @override
  User? build() => _user;
}

GoRouter _routerCapturing(List<String> pushed) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: CoachRolePill()),
        ),
        GoRoute(path: '/profile', builder: (_, __) {
          pushed.add('/profile');
          return const Scaffold(body: SizedBox());
        }),
      ],
    );

void main() {
  testWidgets('renders MODE COACH label', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing([])),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('MODE COACH'), findsOneWidget);
  });

  testWidgets('multi-role: tap navigates to /profile', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach', 'organizer'],
    );
    final pushed = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing(pushed)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('MODE COACH'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/profile'));
  });

  testWidgets('single-role: chevron not present', (tester) async {
    const user = User(
      id: 'u1',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(() => _StubAuth(user))],
        child: MaterialApp.router(routerConfig: _routerCapturing([])),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });
}
