import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;

  ApiAuthRepository(this._apiClient);

  @override
  Future<(User, AuthToken)> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/v1/auth/login', data: {
        'email': email,
        'password': password,
      });
      return parseLoginResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<(User, AuthToken)> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    throw UnimplementedError(
      'Registration is not yet available. Coming soon.',
    );
  }

  @override
  Future<void> logout({String? deviceToken}) async {
    try {
      await _apiClient.post('/v1/auth/logout', data: {
        'device_token': ?deviceToken,
      });
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/v1/auth/me');
      final data = response.data as Map<String, dynamic>;
      final userJson = data.containsKey('user')
          ? data['user'] as Map<String, dynamic>
          : data;
      return parseUserResponse(userJson);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<User> switchRole(String role) async {
    try {
      final response = await _apiClient.put(
        '/v1/auth/switch-role',
        data: {'role': role},
      );
      final json = response.data as Map<String, dynamic>;
      final userJson = json.containsKey('user')
          ? json['user'] as Map<String, dynamic>
          : json;
      return parseUserResponse(userJson);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }
}
