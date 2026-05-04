import 'dart:developer';

import 'package:hyperarena/features/notification/data/device_token_repository.dart';

class MockDeviceTokenRepository implements DeviceTokenRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  MockDeviceTokenRepository();

  @override
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  }) async {
    await Future.delayed(_delay);
    log('MockDeviceTokenRepository.registerToken: $fcmToken ($platform)');
  }

  @override
  Future<void> removeToken(String fcmToken) async {
    await Future.delayed(_delay);
    log('MockDeviceTokenRepository.removeToken: $fcmToken');
  }
}
