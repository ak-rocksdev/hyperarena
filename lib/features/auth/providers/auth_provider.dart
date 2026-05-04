import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/api_auth_repository.dart';
import 'package:hyperarena/features/auth/data/mappers/auth_response_mapper.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/api_tenant_repository.dart';
import 'package:hyperarena/features/auth/data/auth_repository.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/data/tenant_repository.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/features/gamification/providers/gamification_providers.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';
import 'package:hyperarena/features/session/providers/session_providers.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _userKey = 'auth_user';
const _legacyTokenKey = 'auth_token';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiAuthRepository(apiClient);
});

final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiTenantRepository(apiClient);
});

final authNotifierProvider =
    NotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

/// True while a role switch API call is in flight.
final isSwitchingRoleProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
        // Restore tenant slug from secure storage cache
        final slug = _secureStorage.getTenantSlug();
        if (slug != null) {
          ref.read(tenantSlugProvider.notifier).state = slug;
        }
        _initializeAsyncServices();
        return user;
      } catch (_) {
        prefs.remove(_userKey);
        prefs.remove(_legacyTokenKey);
      }
    }
    return null;
  }

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  AuthRepository get _repo => ref.read(authRepositoryProvider);
  SecureStorageService get _secureStorage =>
      ref.read(secureStorageProvider);

  Future<void> login(String email, String password) async {
    final (user, token) = await _repo.login(email, password);
    await _secureStorage.saveToken(token.token);
    // Persist tenant slug for X-Tenant header
    if (user.tenantSlug != null) {
      await _secureStorage.saveTenantSlug(user.tenantSlug!);
      ref.read(tenantSlugProvider.notifier).state = user.tenantSlug;
    }
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
    _initializePushNotifications();
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final (user, token) = await _repo.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await _secureStorage.saveToken(token.token);
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
    // Fire-and-forget: init FCM after register
    _initializePushNotifications();
  }

  /// Re-fetch the current user from GET /auth/me and update local state.
  Future<void> refreshUser() async {
    final user = await _repo.getCurrentUser();
    if (user != null) {
      _updateUser(user);
    }
  }

  /// Update auth state from an already-fetched user JSON (e.g. PUT response).
  void updateFromResponse(Map<String, dynamic> userJson) {
    final user = parseUserResponse(userJson);
    _updateUser(user);
  }

  void _updateUser(User user) {
    // Use backend's active_role as authoritative — do not preserve old role.
    // Previously this preserved the local role via user.copyWith(role: current.role).
    // Now that /me returns active_role, the backend is authoritative.
    _prefs.setString(_userKey, jsonEncode(user.toJson()));
    state = user;
  }

  /// Switch the current user's active role via backend API.
  Future<void> switchRole(UserRole newRole) async {
    final current = state;
    if (current == null || current.role == newRole) return;

    // Use resolveBackendRole to handle super-admin / organizer ambiguity
    final backendRole = resolveBackendRole(
      newRole,
      current.availableRoles,
    );

    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.switchRole(backendRole);

      // Update state from API response
      state = updatedUser;
      _prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));

      // Full provider reset
      _invalidateAllFeatureProviders();
    } catch (e) {
      rethrow;
    }
  }

  void _invalidateAllFeatureProviders() {
    // Marketplace
    ref.invalidate(marketplaceVenueListProvider);
    ref.invalidate(marketplaceSessionListProvider);
    ref.invalidate(marketplaceCoachListProvider);
    ref.invalidate(sportFiltersProvider);

    // Notifications
    ref.invalidate(notificationListProvider);
    ref.invalidate(unreadCountProvider);

    // Gamification
    ref.invalidate(badgeListProvider);
    ref.invalidate(playerStatsProvider);

    // Coach sessions
    ref.invalidate(coachSessionListProvider);

    // Player sessions
    ref.invalidate(sessionListProvider);

    // Bookings
    ref.invalidate(bookingListProvider);

    // Organizer
    ref.invalidate(organizerDashboardProvider);
    ref.invalidate(organizerSessionsProvider);
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);
    ref.invalidate(organizerAgendaProvider);
    ref.invalidate(organizerActionInboxProvider);
    ref.invalidate(organizerEarningsProvider);
    ref.invalidate(clubProfileProvider);
    ref.invalidate(clubMembersProvider);

    // Owner
    ref.invalidate(ownerDashboardProvider);
    ref.invalidate(ownerVenuesProvider);
    ref.invalidate(ownerBookingQueueProvider);
    ref.invalidate(ownerAvailabilityIssuesProvider);
  }

  Future<void> logout() async {
    final fcmToken = _secureStorage.getFcmToken();
    try {
      await _repo.logout(deviceToken: fcmToken);
    } catch (_) {
      // Best-effort — proceed with local cleanup
    }
    await Future.wait([
      _secureStorage.deleteToken(),
      _secureStorage.deleteFcmToken(),
      _secureStorage.deleteTenantSlug(),
    ]);
    if (ref.read(tenantSlugProvider) != null) {
      ref.read(tenantSlugProvider.notifier).state = null;
    }
    _prefs.remove(_userKey);
    _prefs.remove(_legacyTokenKey);
    state = null;
  }

  /// Migrate legacy SharedPreferences token → SecureStorage (one-time).
  Future<void> _migrateTokenIfNeeded() async {
    final legacyJson = _prefs.getString(_legacyTokenKey);
    if (legacyJson == null) return;

    try {
      final decoded = jsonDecode(legacyJson) as Map<String, dynamic>;
      final token = decoded['token'] as String?;
      if (token != null && _secureStorage.getToken() == null) {
        await _secureStorage.saveToken(token);
      }
    } catch (_) {
      // Corrupt data — treat as logged out
    }
    _prefs.remove(_legacyTokenKey);
  }

  Future<void> _initializeAsyncServices() async {
    await _migrateTokenIfNeeded();
    _initializePushNotifications();
  }

  Future<void> _initializePushNotifications() async {
    // Firebase init may have failed during bootstrap (e.g. on web).
    // pushNotificationServiceProvider handles its own degradation.
    try {
      final pushService = ref.read(pushNotificationServiceProvider);
      await pushService.initialize();
      pushService.registerWithBackend(); // fire-and-forget
    } catch (_) {
      // Firebase not available — graceful degradation
    }
  }
}
