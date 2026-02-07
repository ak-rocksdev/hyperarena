import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

class MockAuthRepository implements AuthRepository {
  final AppConfig config;

  MockAuthRepository(this.config);

  AuthToken _fakeToken() => AuthToken(
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock-refresh-token',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
      );

  @override
  Future<(User, AuthToken)> login(String email, String password) async {
    await Future.delayed(config.mockDelay);
    return (MockData.currentUser, _fakeToken());
  }

  @override
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(config.mockDelay);
    final user = User(
      id: 'user-new-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.player,
    );
    return (user, _fakeToken());
  }

  @override
  Future<void> logout() async {
    await Future.delayed(config.mockDelay);
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(config.mockDelay);
    return MockData.currentUser;
  }
}
