import 'dart:developer';

import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/features/notification/data/device_token_repository.dart';

class MockDeviceTokenRepository implements DeviceTokenRepository {
  final AppConfig config;

  MockDeviceTokenRepository(this.config);

  @override
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await Future.delayed(config.mockDelay);
    log('MockDeviceTokenRepository.registerToken: $fcmToken ($platform)');
  }

  @override
  Future<void> removeToken(String fcmToken) async {
    await Future.delayed(config.mockDelay);
    log('MockDeviceTokenRepository.removeToken: $fcmToken');
  }
}
