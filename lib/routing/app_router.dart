import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/presentation/screens/login_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/register_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/splash_screen.dart';
import 'package:hyperarena/features/auth/presentation/screens/sport_selection_screen.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_date_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_list_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/booking_summary_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/payment_screen.dart';
import 'package:hyperarena/features/booking/presentation/screens/slot_selection_screen.dart';
import 'package:hyperarena/features/home/presentation/screens/home_screen.dart';
import 'package:hyperarena/features/profile/presentation/screens/profile_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_confirmation_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_detail_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_payment_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/assessment_form_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_confirmation_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_payment_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_booking_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_dashboard_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_detail_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_schedule_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/student_detail_screen.dart';
import 'package:hyperarena/features/coach/presentation/screens/student_list_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/explore_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/venue_detail_screen.dart';

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
              label: 'Community',
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

/// Auth routes that don't require authentication.
const _publicPaths = {
  '/splash',
  '/onboarding',
  '/auth/login',
  '/auth/register',
  '/auth/sport-selection',
};

/// Phase 1 router — Auth guards, Player shell, booking flow.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isPublicRoute = _publicPaths.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return '/auth/login';
      }

      if (isAuthenticated && isPublicRoute) {
        return authState.role == UserRole.coach
            ? '/coach/dashboard'
            : '/player/home';
      }

      return null;
    },
    routes: [
      // ── Pre-auth routes ──────────────────────────────
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/sport-selection',
        builder: (_, _) => const SportSelectionScreen(),
      ),

      // ── Player shell (4 tabs) ────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.player,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/home',
              builder: (_, _) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/explore',
              builder: (_, _) => const ExploreScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/bookings',
              builder: (_, _) => const BookingListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/profile',
              builder: (_, _) => const ProfileScreen(),
            ),
          ]),
        ],
      ),

      // ── Full-screen routes (outside shell) ────────────
      GoRoute(
        path: '/venue/:id',
        builder: (_, state) => VenueDetailScreen(
          venueId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (_, state) => BookingDetailScreen(
          bookingId: state.pathParameters['id']!,
        ),
      ),

      // ── Booking flow routes ───────────────────────────
      GoRoute(
        path: '/booking/flow/court/:courtId',
        builder: (_, state) => BookingDateScreen(
          courtId: state.pathParameters['courtId']!,
        ),
      ),
      GoRoute(
        path: '/booking/flow/slots',
        builder: (_, _) => const SlotSelectionScreen(),
      ),
      GoRoute(
        path: '/booking/flow/summary',
        builder: (_, _) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: '/booking/flow/payment',
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
        builder: (_, state) => SessionDetailScreen(
          sessionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/session/flow/payment',
        builder: (_, _) => const SessionPaymentScreen(),
      ),
      GoRoute(
        path: '/session/flow/confirmation',
        builder: (_, _) => const SessionConfirmationScreen(),
      ),

      // ── Coach booking flow (player view) ────────────────
      GoRoute(
        path: '/coach/booking',
        builder: (_, _) => const CoachBookingScreen(),
      ),
      GoRoute(
        path: '/coach/booking/payment',
        builder: (_, _) => const CoachBookingPaymentScreen(),
      ),
      GoRoute(
        path: '/coach/booking/confirmation',
        builder: (_, _) => const CoachBookingConfirmationScreen(),
      ),

      // ── Coach role shell (4 tabs) ──────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.coach,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/coach/dashboard',
              builder: (_, _) => const CoachDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/coach/schedule',
              builder: (_, _) => const CoachScheduleScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/coach/students',
              builder: (_, _) => const StudentListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/coach/profile',
              builder: (_, _) => const ProfileScreen(),
            ),
          ]),
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
        builder: (_, _) => const AssessmentFormScreen(),
      ),

      // ── Coach detail (parameterized — must come after specific /coach/* routes)
      GoRoute(
        path: '/coach/:id',
        builder: (_, state) => CoachDetailScreen(
          coachId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
