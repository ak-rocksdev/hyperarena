import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/login_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/tenant_picker_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/register_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/splash_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/sport_selection_screen.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_date_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_list_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_summary_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/payment_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/slot_selection_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/assessment_form_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_confirmation_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coaching_booking_detail_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_payment_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_availability_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_dashboard_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_detail_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_schedule_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/student_detail_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/student_list_screen.dart';
import 'package:hyperarena/features/home/presentation/screens/home_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_community_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_dashboard_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_earnings_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_session_detail_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_session_list_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_dashboard_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_booking_queue_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_venue_detail_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_venue_list_screen.dart';
import 'package:hyperarena/features/gamification/presentation/screens/achievements_screen.dart';
import 'package:hyperarena/features/notification/presentation/screens/notifications_screen.dart';
import 'package:hyperarena/features/profile/presentation/screens/career_screen.dart';
import 'package:hyperarena/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:hyperarena/features/profile/presentation/screens/profile_screen.dart';
import 'package:hyperarena/features/profile/presentation/screens/settings_screen.dart';
import 'package:hyperarena/features/review/presentation/screens/coach_review_list_screen.dart';
import 'package:hyperarena/features/review/presentation/screens/submit_review_screen.dart';
import 'package:hyperarena/features/review/presentation/screens/submit_venue_review_screen.dart';
import 'package:hyperarena/features/review/presentation/screens/venue_review_list_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_confirmation_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_detail_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_payment_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/create_session_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/participant_management_screen.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/coach/presentation/screens/marketplace_coach_detail_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/marketplace_session_confirmation_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/marketplace_session_detail_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/marketplace_session_payment_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/explore_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/marketplace_venue_detail_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/venue_detail_screen.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Role-aware bottom navigation shell.
class RoleShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final UserRole role;

  const RoleShell({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: _destinations(role),
      ),
    );
  }

  List<NavigationDestination> _destinations(UserRole role) => switch (role) {
    UserRole.player => const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Explore',
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined),
        selectedIcon: Icon(Icons.calendar_today),
        label: 'Bookings',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    UserRole.coach => const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.schedule_outlined),
        selectedIcon: Icon(Icons.schedule),
        label: 'Schedule',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Students',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    UserRole.organizer => const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.event_outlined),
        selectedIcon: Icon(Icons.event),
        label: 'Sessions',
      ),
      NavigationDestination(
        icon: Icon(Icons.group_outlined),
        selectedIcon: Icon(Icons.group),
        label: 'Klub',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    UserRole.courtOwner => const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.store_outlined),
        selectedIcon: Icon(Icons.store),
        label: 'Venues',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  };
}

/// Extracts [GoRouterState.extra] as [T], showing a fallback scaffold if null.
Widget _requireExtra<T>(
  GoRouterState state,
  Widget Function(T) builder,
  String errorMessage,
) {
  final extra = state.extra as T?;
  if (extra == null) {
    return Scaffold(body: Center(child: Text(errorMessage)));
  }
  return builder(extra);
}

/// Auth routes that don't require authentication.
const _publicPaths = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.sportSelection,
  AppRoutes.forgotPassword,
  AppRoutes.tenantPicker,
};

/// Phase 1 router — Auth guards, Player shell, booking flow.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isPublicRoute = _publicPaths.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isPublicRoute) {
        // Super-admin without tenant slug → tenant picker
        if (authState.activeRole == 'super-admin') {
          final slug = ref.read(tenantSlugProvider);
          if (slug == null && state.matchedLocation != AppRoutes.tenantPicker) {
            return AppRoutes.tenantPicker;
          }
        }
        if (state.matchedLocation == AppRoutes.tenantPicker) {
          return null; // Allow super-admin to stay on picker
        }
        return AppRoutes.home(authState.role);
      }

      // Authenticated, non-public route: check super-admin needs tenant
      if (isAuthenticated && authState.activeRole == 'super-admin') {
        final slug = ref.read(tenantSlugProvider);
        if (slug == null && state.matchedLocation != AppRoutes.tenantPicker) {
          return AppRoutes.tenantPicker;
        }
      }

      return null;
    },
    routes: [
      // ── Pre-auth routes ──────────────────────────────
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.sportSelection,
        builder: (_, _) => const SportSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.tenantPicker,
        builder: (_, _) => const TenantPickerScreen(),
      ),

      // ── Player shell (4 tabs) ────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) =>
            RoleShell(navigationShell: shell, role: UserRole.player),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/player/home',
                builder: (_, _) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/player/explore',
                builder: (_, _) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/player/bookings',
                builder: (_, _) => const BookingListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/player/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen routes (outside shell) ────────────
      GoRoute(
        path: '/venue/:id/reviews',
        builder: (_, state) => VenueReviewListScreen(
          venueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/venue/:id',
        builder: (_, state) =>
            VenueDetailScreen(venueId: state.pathParameters['id']!),
      ),

      // ── Marketplace detail routes ────────────────────────
      GoRoute(
        path: '/marketplace/venue/:id',
        builder: (_, state) => MarketplaceVenueDetailScreen(
          venueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/marketplace/coach/:id',
        builder: (_, state) => _requireExtra<MarketplaceCoach>(
          state,
          (coach) => MarketplaceCoachDetailScreen(coach: coach),
          'Data coach tidak tersedia',
        ),
      ),
      GoRoute(
        path: '/marketplace/session/:id',
        builder: (_, state) => MarketplaceSessionDetailScreen(
          sessionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/marketplace/session/:id/payment',
        builder: (_, state) => MarketplaceSessionPaymentScreen(
          sessionId: state.pathParameters['id']!,
          extra: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/marketplace/session/:id/confirmation',
        builder: (_, state) => MarketplaceSessionConfirmationScreen(
          sessionId: state.pathParameters['id']!,
          extra: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (_, state) =>
            BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),

      // ── Booking flow routes ───────────────────────────
      GoRoute(
        path: '/booking/flow/court/:courtId',
        builder: (_, state) =>
            BookingDateScreen(courtId: state.pathParameters['courtId']!),
      ),
      GoRoute(
        path: AppRoutes.bookingFlowSlots,
        builder: (_, _) => const SlotSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingFlowSummary,
        builder: (_, _) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingFlowPayment,
        builder: (_, _) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/booking/flow/confirmation/:bookingId',
        builder: (_, state) => BookingConfirmationScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),

      // ── Session flow routes ──────────────────────────────
      GoRoute(
        path: '/session/:id',
        builder: (_, state) =>
            SessionDetailScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.sessionFlowPayment,
        builder: (_, _) => const SessionPaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.sessionFlowConfirmation,
        builder: (_, _) => const SessionConfirmationScreen(),
      ),

      // ── Coach booking flow (player view) ────────────────
      GoRoute(
        path: AppRoutes.coachBooking,
        builder: (_, _) => const CoachBookingScreen(),
      ),
      GoRoute(
        path: AppRoutes.coachBookingPayment,
        builder: (_, _) => const CoachBookingPaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.coachBookingConfirmation,
        builder: (_, _) => const CoachBookingConfirmationScreen(),
      ),

      // ── Coaching booking detail (coach view) ────────────
      GoRoute(
        path: '/coaching-booking/:id',
        builder: (_, state) => CoachingBookingDetailScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),

      // ── Coach role shell (4 tabs) ──────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) =>
            RoleShell(navigationShell: shell, role: UserRole.coach),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coach/dashboard',
                builder: (_, _) => const CoachDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coach/schedule',
                builder: (_, _) => const CoachScheduleScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coach/students',
                builder: (_, _) => const StudentListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/coach/profile',
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Coach full-screen routes ───────────────────────
      GoRoute(
        path: '/coach/student/:name',
        builder: (_, state) => StudentDetailScreen(
          studentName: Uri.decodeComponent(state.pathParameters['name']!),
        ),
      ),
      GoRoute(
        path: '/coach/assessment/new',
        builder: (_, state) {
          final query = state.uri.queryParameters;
          return AssessmentFormScreen(
            sessionId: query['sessionId'],
            sessionTitle: query['sessionTitle'],
            studentId: query['studentId'],
            studentName: query['studentName'],
            sport: query['sport'] != null
                ? Sport.values.firstWhere(
                    (s) => s.name == query['sport'],
                    orElse: () => Sport.tennis,
                  )
                : null,
          );
        },
      ),

      // ── Coach availability (coach role) ────────────────────
      GoRoute(
        path: '/coach/availability',
        builder: (_, _) => const CoachAvailabilityScreen(),
      ),

      // ── Coach detail (parameterized — must come after specific /coach/* routes)
      GoRoute(
        path: '/coach/:id',
        builder: (_, state) =>
            CoachDetailScreen(coachId: state.pathParameters['id']!),
      ),

      // ── Organizer role shell (4 tabs) ────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) =>
            RoleShell(navigationShell: shell, role: UserRole.organizer),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.organizerDashboard,
                builder: (_, _) => const OrganizerDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.organizerSessions,
                builder: (_, _) => const OrganizerSessionListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.organizerClub,
                builder: (_, _) => const OrganizerCommunityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.organizerProfile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Court Owner role shell (3 tabs) ──────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) =>
            RoleShell(navigationShell: shell, role: UserRole.courtOwner),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ownerDashboard,
                builder: (_, _) => const OwnerDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ownerVenues,
                builder: (_, _) => const OwnerVenueListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ownerProfile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Organizer full-screen routes ───────────────────
      GoRoute(
        path: '/organizer/session/create',
        builder: (_, _) => const CreateSessionScreen(),
      ),
      GoRoute(
        path: '/organizer/session/:id',
        builder: (_, state) => OrganizerSessionDetailScreen(
          sessionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/organizer/session/:id/participants',
        builder: (_, state) =>
            ParticipantManagementScreen(sessionId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.organizerEarnings,
        builder: (_, _) => const OrganizerEarningsScreen(),
      ),
      GoRoute(
        path: AppRoutes.organizerInbox,
        builder: (_, _) => const OrganizerDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.organizerAgenda,
        builder: (_, _) => const OrganizerSessionListScreen(),
      ),

      // ── Career route ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.career,
        builder: (_, _) => const CareerScreen(),
      ),

      // ── Review routes ────────────────────────────────────
      GoRoute(
        path: '/review/create/:sessionId',
        builder: (_, state) => SubmitReviewScreen(
          sessionId: state.pathParameters['sessionId']!,
          coachId: state.uri.queryParameters['coachId'] ?? '',
          coachName: state.uri.queryParameters['coachName'] ?? '',
          sessionTitle: state.uri.queryParameters['sessionTitle'] ?? '',
        ),
      ),
      GoRoute(
        path: '/coach/:id/reviews',
        builder: (_, state) => CoachReviewListScreen(
          coachId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/review/venue/:bookingId',
        builder: (_, state) => SubmitVenueReviewScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),

      // ── Notification route ──────────────────────────────
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),

      // ── Achievements route ──────────────────────────────
      GoRoute(
        path: AppRoutes.achievements,
        builder: (_, _) => const AchievementsScreen(),
      ),

      // ── Edit Profile + Settings routes ──────────────────
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),

      // ── Owner full-screen routes ───────────────────────
      GoRoute(
        path: '/owner/venue/:id',
        builder: (_, state) =>
            OwnerVenueDetailScreen(venueId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.ownerBookingQueue,
        builder: (_, _) => const OwnerBookingQueueScreen(),
      ),
    ],
  );
});
