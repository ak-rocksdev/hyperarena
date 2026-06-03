import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);
  final User? _user;
  @override
  User? build() => _user;
}

void main() {
  test('coachIdProvider returns user.id when role is coach', () {
    const user = User(
      id: 'u-42',
      name: 'Andi',
      email: 'a@x.com',
      role: UserRole.coach,
    );
    final container = ProviderContainer(overrides: [
      authNotifierProvider.overrideWith(() => _StubAuth(user)),
    ]);
    addTearDown(container.dispose);
    expect(container.read(coachIdProvider), 'u-42');
  });

  test('coachIdProvider throws when user is null', () {
    final container = ProviderContainer(overrides: [
      authNotifierProvider.overrideWith(() => _StubAuth(null)),
    ]);
    addTearDown(container.dispose);
    expect(() => container.read(coachIdProvider), throwsStateError);
  });

  test('coachIdProvider throws when user is not in coach role', () {
    const user = User(
      id: 'u-7',
      name: 'X',
      email: 'x@x.com',
      role: UserRole.player,
    );
    final container = ProviderContainer(overrides: [
      authNotifierProvider.overrideWith(() => _StubAuth(user)),
    ]);
    addTearDown(container.dispose);
    expect(() => container.read(coachIdProvider), throwsStateError);
  });
}
