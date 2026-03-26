import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

abstract class AuthRepository {
  Future<(User, AuthToken)> login(String email, String password);
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout({String? deviceToken});
  Future<User?> getCurrentUser();
}
