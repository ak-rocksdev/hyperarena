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
    UserRole.courtOwner => '/owner/dashboard',
  };

  static String explore(UserRole role) => switch (role) {
    UserRole.player => '/player/explore',
    UserRole.organizer => organizerSessions,
    UserRole.courtOwner => ownerVenues,
    _ => '/player/explore',
  };

  static String bookings(UserRole role) => switch (role) {
    UserRole.player => '/player/bookings',
    UserRole.courtOwner => ownerBookingQueue,
    _ => '/player/bookings',
  };

  static String profile(UserRole role) => switch (role) {
    UserRole.player => '/player/profile',
    UserRole.coach => '/coach/profile',
    UserRole.organizer => '/organizer/profile',
    UserRole.courtOwner => '/owner/profile',
  };

  // ── Role-neutral parameterized ─────────────────────────────────────
  static String venue(String id) => '/venue/$id';
  static String booking(String id) => '/booking/$id';
  static String coach(String id) => '/coach/$id';
  static String session(String id) => '/session/$id';

  // ── Marketplace detail (API mode) ────────────────────────────────
  static String marketplaceVenue(String id) => '/marketplace/venue/$id';
  static String marketplaceCoach(String id) => '/marketplace/coach/$id';
  static String marketplaceSession(String id) => '/marketplace/session/$id';

  // ── Marketplace session flow ────────────────────────────────
  static String marketplaceSessionPayment(String sessionId) =>
      '/marketplace/session/$sessionId/payment';
  static String marketplaceSessionConfirmation(String sessionId) =>
      '/marketplace/session/$sessionId/confirmation';

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

  // ── Organizer routes ───────────────────────────────────────────────
  static const organizerDashboard = '/organizer/dashboard';
  static const organizerSessions = '/organizer/sessions';
  static const organizerMembers = '/organizer/members';
  static String organizerMember(String id) => '/organizer/members/$id';
  /// Community / Klub tab — club identity, cover photo, member directory.
  /// Distinct from [organizerMembers] (financial-lens member list).
  static const organizerClub = '/organizer/club';
  static const organizerProfile = '/organizer/profile';
  static const organizerCreateSession = '/organizer/session/create';
  static String organizerSessionDetail(String id) => '/organizer/session/$id';
  static String organizerParticipants(String sessionId) =>
      '/organizer/session/$sessionId/participants';
  static const organizerEarnings = '/organizer/earnings';
  static const organizerInbox = '/organizer/inbox';
  static const organizerAgenda = '/organizer/agenda';

  // ── Owner routes ───────────────────────────────────────────────────
  static const ownerDashboard = '/owner/dashboard';
  static const ownerVenues = '/owner/venues';
  static String ownerVenueDetail(String id) => '/owner/venue/$id';
  static const ownerProfile = '/owner/profile';
  static const ownerBookingQueue = '/owner/bookings';

  // ── Coach booking flow (player-initiated) ──────────────────────────
  static const coachBooking = '/coach/booking';
  static const coachBookingPayment = '/coach/booking/payment';
  static const coachBookingConfirmation = '/coach/booking/confirmation';
  static String coachingBookingDetail(String id) => '/coaching-booking/$id';

  // ── Coach role-specific ────────────────────────────────────────────
  static String coachSessionDetail(String id) => '/coach/session/$id';
  static String studentDetail(String name) =>
      '/coach/student/${Uri.encodeComponent(name)}';
  static const coachStudents = '/coach/students';
  static String coachStudent(String id) => '/coach/students/$id';
  static const coachAvailability = '/coach/availability';

  // ── Coach Wallet / Earnings ────────────────────────────────────────
  static const coachWallet = '/coach/wallet';
  static const coachWithdrawalHistory = '/coach/wallet/requests';
  static String coachWithdrawalDetail(int id) => '/coach/wallet/requests/$id';

  // ── Review routes ────────────────────────────────────────────────
  static String submitReview(String sessionId) => '/review/create/$sessionId';
  static const myReviews = '/player/reviews';
  static String coachReviews(String coachId) => '/coach/$coachId/reviews';

  // ── Venue review routes ─────────────────────────────────────
  static String submitVenueReview(String bookingId) =>
      '/review/venue/$bookingId';
  static String venueReviews(String venueId) => '/venue/$venueId/reviews';

  // ── Profile sub-routes ──────────────────────────────────────────
  static const career = '/player/career';
  static const editProfile = '/player/profile/edit';
  static const settings = '/player/settings';

  // ── Auth sub-routes ─────────────────────────────────────────
  static const forgotPassword = '/auth/forgot-password';
  static const tenantPicker = '/auth/tenant-picker';

  // ── Notification routes ───────────────────────────────────────
  static const notifications = '/notifications';

  // ── Gamification routes ───────────────────────────────────────
  static const achievements = '/player/achievements';

  // ── Purchase history routes ────────────────────────────────────
  static const myPurchases = '/purchases';
  static String purchaseDetail(String id) => '/purchases/$id';
}
