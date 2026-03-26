import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';

class ApiDeviceTokenRepository implements DeviceTokenRepository {
  final ApiClient _apiClient;

  ApiDeviceTokenRepository(this._apiClient);

  @override
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await _apiClient.post('/v1/auth/device-token', data: {
      'token': fcmToken,
      'platform': platform,
      'device_name': ?deviceName,
    });
  }

  @override
  Future<void> removeToken(String fcmToken) async {
    await _apiClient.delete('/v1/auth/device-token', data: {
      'token': fcmToken,
    });
  }
}
