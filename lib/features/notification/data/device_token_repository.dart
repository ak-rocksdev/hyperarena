abstract class DeviceTokenRepository {
  Future<void> registerToken({
    required String fcmToken,
    required String platform,
    String? deviceName,
  });

  Future<void> removeToken(String fcmToken);
}
