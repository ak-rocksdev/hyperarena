import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/mocks/mock_users.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

class MockAuthRepository implements AuthRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  MockAuthRepository();

  AuthToken _fakeToken() => AuthToken(
        token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      );

  @override
  Future<(User, AuthToken)> login(String email, String password) async {
    await Future.delayed(_delay);
    final userByEmail = {
      MockUsers.currentUser.email: MockUsers.currentUser,
      MockUsers.coachUser.email: MockUsers.coachUser,
      MockUsers.organizerUser.email: MockUsers.organizerUser,
      MockUsers.ownerUser.email: MockUsers.ownerUser,
    };
    return (userByEmail[email] ?? MockData.currentUser, _fakeToken());
  }

  @override
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(_delay);
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
  Future<void> logout({String? deviceToken}) async {
    await Future.delayed(_delay);
  }

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(_delay);
    return MockData.currentUser;
  }

  @override
  Future<User> switchRole(String role) async {
    await Future.delayed(_delay);
    return MockUsers.currentUser.copyWith(
      activeRole: role,
      role: mapBackendRole(role),
      availableRoles: MockUsers.currentUser.availableRoles,
    );
  }
}
