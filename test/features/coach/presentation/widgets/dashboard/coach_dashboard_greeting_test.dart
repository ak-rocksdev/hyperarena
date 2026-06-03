import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';

void main() {
  testWidgets('greeting shows first name from user', (tester) async {
    const user = User(
      id: 'u1',
      name: 'Budi Santoso',
      email: 'b@x.com',
      role: UserRole.coach,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _StubAuth(user)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardGreeting()),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Budi'), findsOneWidget);
    expect(find.text('Kelola jadwal dan murid Anda'), findsOneWidget);
  });

  testWidgets('greeting falls back to "Coach" when name is null', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => _StubAuth(null)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardGreeting()),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('Coach'), findsOneWidget);
  });
}

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);
  final User? _user;
  @override
  User? build() => _user;
}
