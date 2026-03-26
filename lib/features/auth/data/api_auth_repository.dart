import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  ApiAuthRepository(this._apiClient);

  @override
  Future<(User, AuthToken)> login(String email, String password) async {
    final response = await _apiClient.post('/v1/auth/login', data: {
      'email': email,
      'password': password,
    });
    return parseLoginResponse(response.data as Map<String, dynamic>);
  }

  @override
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    // Deferred — registration requires tenant context (marketplace sub-project)
    throw UnimplementedError(
      'Registration is not yet available. Coming soon.',
    );
  }

  @override
  Future<void> logout({String? deviceToken}) async {
    await _apiClient.post('/v1/auth/logout', data: {
      if (deviceToken != null) 'device_token': deviceToken,
    });
  }

  @override
  Future<User?> getCurrentUser() async {
    final response = await _apiClient.get('/v1/auth/me');
    final data = response.data as Map<String, dynamic>;
    // The /me endpoint may wrap user in a 'user' key or return directly
    final userJson = data.containsKey('user')
        ? data['user'] as Map<String, dynamic>
        : data;
    return parseUserResponse(userJson);
  }
}
