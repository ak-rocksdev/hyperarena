import 'package:hyperarena/core/theme/app_enums.dart';

/// Centralized route constants for the entire app.
///
/// All route strings live here so that routers, navigation calls,
/// and deep-link handlers reference a single source of truth.
abstract final class AppRoutes {
  // ── Auth ───────────────────────────────────────────────────────────
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const sportSelection = '/auth/sport-selection';

  // ── Role-aware helpers ─────────────────────────────────────────────
  static String home(UserRole role) => switch (role) {
    UserRole.player => '/player/home',
    UserRole.coach => '/coach/dashboard',
    UserRole.organizer => '/organizer/dashboard',
  };

  static String explore(UserRole role) => switch (role) {
    UserRole.player => '/player/explore',
    UserRole.organizer => '/organizer/explore',
    _ => '/player/explore',
  };

  static String bookings(UserRole role) => switch (role) {
    UserRole.player => '/player/bookings',
    _ => '/player/bookings',
  };

  static String profile(UserRole role) => switch (role) {
    UserRole.player => '/player/profile',
    UserRole.coach => '/coach/profile',
    UserRole.organizer => '/organizer/profile',
  };

  // ── Role-neutral parameterized ─────────────────────────────────────
  static String venue(String id) => '/venue/$id';
  static String booking(String id) => '/booking/$id';
  static String coach(String id) => '/coach/$id';
  static String session(String id) => '/session/$id';
  static String bookingFlowCourt(String courtId) =>
      '/booking/flow/court/$courtId';

  // ── Booking flow ───────────────────────────────────────────────────
  static const bookingFlowSlots = '/booking/flow/slots';
  static const bookingFlowSummary = '/booking/flow/summary';
  static const bookingFlowPayment = '/booking/flow/payment';
  static String bookingFlowConfirmation(String bookingId) =>
      '/booking/flow/confirmation/$bookingId';

  // ── Session flow ───────────────────────────────────────────────────
  static const sessionFlowPayment = '/session/flow/payment';
  static const sessionFlowConfirmation = '/session/flow/confirmation';

  // ── Coach booking flow (player-initiated) ──────────────────────────
  static const coachBooking = '/coach/booking';
  static const coachBookingPayment = '/coach/booking/payment';
  static const coachBookingConfirmation = '/coach/booking/confirmation';

  // ── Coach role-specific ────────────────────────────────────────────
  static String studentDetail(String name) =>
      '/coach/student/${Uri.encodeComponent(name)}';
  static const assessmentNew = '/coach/assessment/new';
}
