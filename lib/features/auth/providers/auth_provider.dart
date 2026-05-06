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
import 'package:hyperarena/features/booking/providers/marketplace_booking_providers.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_detail_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/features/coach/providers/student_provider.dart';
import 'package:hyperarena/features/gamification/providers/gamification_providers.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';
import 'package:hyperarena/features/profile/providers/activity_provider.dart';
import 'package:hyperarena/features/profile/providers/career_provider.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/features/review/providers/venue_review_providers.dart';
import 'package:hyperarena/features/session/providers/marketplace_session_join_provider.dart';
import 'package:hyperarena/features/session/providers/session_providers.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';
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
    // Clear cached data from any prior session (logout may not have completed
    // cleanly, or app may have been killed mid-session).
    _invalidateAllFeatureProviders();
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

  /// Resets every user-scoped data + UI-state provider in the app. Called on
  /// role-switch (so the new role sees fresh data) AND on logout (so the
  /// next user doesn't see the previous user's cached lists).
  ///
  /// **When adding a new data provider anywhere in `lib/features/`, add it
  /// here.** Repositories (`Provider<XRepository>`) and infrastructure
  /// (api_client, secure storage, locale, router) are intentionally NOT
  /// invalidated — they're stateless or contain user-independent state.
  ///
  /// Family providers: `ref.invalidate(family)` invalidates ALL keyed
  /// instances. NotifierProvider: invalidation recreates the Notifier and
  /// re-runs `build()`. StateProvider: resets to its initial value.
  void _invalidateAllFeatureProviders() {
    // ── Marketplace ─────────────────────────────────────────────
    ref.invalidate(marketplaceVenueListProvider);
    ref.invalidate(marketplaceSessionListProvider);
    ref.invalidate(marketplaceCoachListProvider);
    ref.invalidate(marketplaceSessionDetailProvider);
    ref.invalidate(marketplaceVenueDetailProvider);
    ref.invalidate(sportFiltersProvider);
    ref.invalidate(selectedSportIdProvider);

    // ── Venue ───────────────────────────────────────────────────
    ref.invalidate(venueListProvider);

    // ── Notifications ───────────────────────────────────────────
    ref.invalidate(notificationListProvider);
    ref.invalidate(unreadCountProvider);

    // ── Gamification ────────────────────────────────────────────
    ref.invalidate(badgeListProvider);
    ref.invalidate(playerStatsProvider);

    // ── Coach (role) ────────────────────────────────────────────
    ref.invalidate(coachListProvider);
    ref.invalidate(coachFilterProvider);
    ref.invalidate(coachDetailProvider);
    ref.invalidate(coachPackagesProvider);
    ref.invalidate(coachScheduleProvider);
    ref.invalidate(coachSessionListProvider);
    ref.invalidate(coachSessionDetailProvider);
    ref.invalidate(attendanceLocalStateProvider);
    ref.invalidate(assessmentListProvider);
    ref.invalidate(studentListProvider);
    ref.invalidate(studentAssessmentsProvider);
    ref.invalidate(coachBookingProvider);

    // ── Sessions / Bookings ─────────────────────────────────────
    ref.invalidate(sessionListProvider);
    ref.invalidate(bookingListProvider);
    ref.invalidate(myBookingsProvider);
    ref.invalidate(marketplaceSessionJoinProvider);

    // ── Reviews (Issue 13) ──────────────────────────────────────
    ref.invalidate(myReviewProvider);
    ref.invalidate(myReviewsProvider);
    ref.invalidate(coachReviewsProvider);
    ref.invalidate(coachRatingProvider);
    ref.invalidate(hasReviewedBookingProvider);
    ref.invalidate(playerWrittenReviewsProvider);

    // ── Activity feed ───────────────────────────────────────────
    ref.invalidate(activityListProvider);

    // ── Organizer ───────────────────────────────────────────────
    ref.invalidate(organizerDashboardProvider);
    ref.invalidate(organizerSessionsProvider);
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);
    ref.invalidate(organizerAgendaProvider);
    ref.invalidate(organizerActionInboxProvider);
    ref.invalidate(organizerEarningsProvider);
    ref.invalidate(organizerTemplatesProvider);
    ref.invalidate(dashboardDateRangeProvider);
    ref.invalidate(dashboardFilterProvider);
    ref.invalidate(organizerDateRangeProvider);
    ref.invalidate(organizerActionTypeFilterProvider);

    // ── Owner ───────────────────────────────────────────────────
    ref.invalidate(ownerDashboardProvider);
    ref.invalidate(ownerVenuesProvider);
    ref.invalidate(ownerVenueDetailProvider);
    ref.invalidate(ownerBookingQueueProvider);
    ref.invalidate(ownerAvailabilityIssuesProvider);
    ref.invalidate(ownerQueueVenueFilterProvider);
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
    // Clear every cached list/detail so the next login doesn't see prior
    // user's data. Without this, switching accounts leaks bookings, sessions,
    // reviews, etc. across users.
    _invalidateAllFeatureProviders();
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
