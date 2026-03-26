import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _bearerTokenKey = 'bearer_token';
const _fcmTokenKey = 'fcm_token';
const _tenantSlugKey = 'tenant_slug';

class SecureStorageService {
  final FlutterSecureStorage? _storage;
  String? _cachedToken;
  String? _cachedFcmToken;
  String? _cachedTenantSlug;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  /// Test constructor — in-memory only, no encrypted storage.
  SecureStorageService.forTesting() : _storage = null;

  /// Pre-load tokens from encrypted storage into memory cache.
  /// Call once during bootstrap() before runApp().
  Future<void> warmUp() async {
    if (_storage == null) return;
    final results = await Future.wait([
      _storage.read(key: _bearerTokenKey),
      _storage.read(key: _fcmTokenKey),
      _storage.read(key: _tenantSlugKey),
    ]);
    _cachedToken = results[0];
    _cachedFcmToken = results[1];
    _cachedTenantSlug = results[2];
  }

  // ── Bearer token ──────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getToken() => _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage?.write(key: _bearerTokenKey, value: token);
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    await _storage?.delete(key: _bearerTokenKey);
  }

  // ── FCM token ─────────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getFcmToken() => _cachedFcmToken;

  Future<void> saveFcmToken(String token) async {
    _cachedFcmToken = token;
    await _storage?.write(key: _fcmTokenKey, value: token);
  }

  Future<void> deleteFcmToken() async {
    _cachedFcmToken = null;
    await _storage?.delete(key: _fcmTokenKey);
  }

  // ── Tenant slug ─────────────────────────────────────

  /// Synchronous read from in-memory cache.
  String? getTenantSlug() => _cachedTenantSlug;

  Future<void> saveTenantSlug(String slug) async {
    _cachedTenantSlug = slug;
    await _storage?.write(key: _tenantSlugKey, value: slug);
  }

  Future<void> deleteTenantSlug() async {
    _cachedTenantSlug = null;
    await _storage?.delete(key: _tenantSlugKey);
  }
}
