# Role Architecture Improvements — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make the app's routing and auth architecture properly support 4 roles (Player, Coach, Organizer, Court Owner) with centralized route constants, role-aware navigation, and placeholder shells for new roles.

**Architecture:** Create `AppRoutes` helper with exhaustive switch expressions per role. Update `UserRole` enum, fix redirect/splash, add mock users + quick-login grid, scaffold Organizer & Court Owner shells with placeholder screens.

**Tech Stack:** Flutter 3.38, Riverpod, go_router, Freezed

---

### Task 1: Create `AppRoutes` Route Constants

**Files:**
- Create: `lib/routing/app_routes.dart`

**Step 1: Create the route constants file**

```dart
import 'package:hyperarena/core/theme/app_enums.dart';

/// Centralized route definitions. Every navigation call must use these
/// instead of hardcoded strings.
abstract final class AppRoutes {
  // ── Auth (public) ─────────────────────────────────
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const sportSelection = '/auth/sport-selection';

  // ── Role-aware shell routes ───────────────────────
  static String home(UserRole role) => switch (role) {
    UserRole.player     => '/player/home',
    UserRole.coach      => '/coach/dashboard',
    UserRole.organizer  => '/organizer/dashboard',
    UserRole.courtOwner => '/owner/dashboard',
  };

  static String explore(UserRole role) => switch (role) {
    UserRole.player     => '/player/explore',
    UserRole.organizer  => '/organizer/explore',
    _                   => '/player/explore',
  };

  static String bookings(UserRole role) => switch (role) {
    UserRole.player => '/player/bookings',
    _               => '/player/bookings',
  };

  static String profile(UserRole role) => switch (role) {
    UserRole.player     => '/player/profile',
    UserRole.coach      => '/coach/profile',
    UserRole.organizer  => '/organizer/profile',
    UserRole.courtOwner => '/owner/profile',
  };

  // ── Role-neutral parameterized routes ─────────────
  static String venue(String id) => '/venue/$id';
  static String booking(String id) => '/booking/$id';
  static String coach(String id) => '/coach/$id';
  static String session(String id) => '/session/$id';
  static String bookingFlowCourt(String courtId) => '/booking/flow/court/$courtId';

  // ── Booking flow (sequential, role-neutral) ───────
  static const bookingFlowSlots = '/booking/flow/slots';
  static const bookingFlowSummary = '/booking/flow/summary';
  static const bookingFlowPayment = '/booking/flow/payment';
  static String bookingFlowConfirmation(String bookingId) =>
      '/booking/flow/confirmation/$bookingId';

  // ── Session flow ──────────────────────────────────
  static const sessionFlowPayment = '/session/flow/payment';
  static const sessionFlowConfirmation = '/session/flow/confirmation';

  // ── Coach booking flow (player-initiated) ─────────
  static const coachBooking = '/coach/booking';
  static const coachBookingPayment = '/coach/booking/payment';
  static const coachBookingConfirmation = '/coach/booking/confirmation';

  // ── Coach role-specific ───────────────────────────
  static String studentDetail(String name) =>
      '/coach/student/${Uri.encodeComponent(name)}';
  static const assessmentNew = '/coach/assessment/new';
}
```

**Step 2: Verify it compiles**

Run: `flutter analyze lib/routing/app_routes.dart`
Expected: No issues

**Step 3: Commit**

```bash
git add lib/routing/app_routes.dart
git commit -m "feat: add centralized AppRoutes constants"
```

---

### Task 2: Update `UserRole` Enum + Rebuild Freezed

**Files:**
- Modify: `lib/core/theme/app_enums.dart:27`

**Step 1: Add `courtOwner` to the enum**

Change line 27 from:
```dart
enum UserRole { player, coach, organizer }
```
To:
```dart
enum UserRole { player, coach, organizer, courtOwner }
```

**Step 2: Rebuild Freezed models**

Run: `dart run build_runner build --delete-conflicting-outputs`

This regenerates `user.freezed.dart`, `user.g.dart` (and any other Freezed models referencing UserRole) with proper serialization for the new enum value.

**Step 3: Fix RoleShell `_destinations` switch**

In `lib/routing/app_router.dart`, the `_destinations` switch on `UserRole` will now be non-exhaustive. Add the `courtOwner` case:

```dart
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
```

**Step 4: Verify**

Run: `flutter analyze`
Expected: May show warnings about non-exhaustive switches in other files — that's expected and will be fixed in subsequent tasks.

**Step 5: Commit**

```bash
git add lib/core/theme/app_enums.dart lib/routing/app_router.dart
git add lib/features/auth/data/models/user.freezed.dart lib/features/auth/data/models/user.g.dart
git commit -m "feat: add courtOwner to UserRole enum, update RoleShell"
```

---

### Task 3: Add Mock Users + Update Auth Repository

**Files:**
- Modify: `lib/core/mocks/mock_users.dart`
- Modify: `lib/features/auth/data/mock_auth_repository.dart`

**Step 1: Add Organizer and Court Owner mock users**

In `mock_users.dart`, add after `coachUser`:

```dart
static const organizerUser = User(
  id: 'organizer-001',
  name: 'Sari Rahmawati',
  email: 'organizer@email.com',
  phone: '+6281555666777',
  role: UserRole.organizer,
  isVerified: true,
);

static const ownerUser = User(
  id: 'owner-001',
  name: 'Hendra Wijaya',
  email: 'owner@email.com',
  phone: '+6281333444555',
  role: UserRole.courtOwner,
  isVerified: true,
);
```

**Step 2: Update MockAuthRepository.login() to use email map**

Replace the current if/else in `mock_auth_repository.dart` login method:

```dart
@override
Future<(User, AuthToken)> login(String email, String password) async {
  await Future.delayed(config.mockDelay);
  final userByEmail = {
    MockUsers.currentUser.email: MockUsers.currentUser,
    MockUsers.coachUser.email: MockUsers.coachUser,
    MockUsers.organizerUser.email: MockUsers.organizerUser,
    MockUsers.ownerUser.email: MockUsers.ownerUser,
  };
  return (userByEmail[email] ?? MockData.currentUser, _fakeToken());
}
```

**Step 3: Verify**

Run: `flutter analyze lib/core/mocks/mock_users.dart lib/features/auth/data/mock_auth_repository.dart`
Expected: No issues

**Step 4: Commit**

```bash
git add lib/core/mocks/mock_users.dart lib/features/auth/data/mock_auth_repository.dart
git commit -m "feat: add organizer + court owner mock users"
```

---

### Task 4: Placeholder Screens for Organizer & Court Owner

**Files:**
- Create: `lib/features/organizer/presentation/screens/organizer_dashboard_screen.dart`
- Create: `lib/features/organizer/presentation/screens/organizer_session_list_screen.dart`
- Create: `lib/features/organizer/presentation/screens/organizer_community_screen.dart`
- Create: `lib/features/owner/presentation/screens/owner_dashboard_screen.dart`
- Create: `lib/features/owner/presentation/screens/owner_venue_list_screen.dart`

**Step 1: Create a shared placeholder builder**

Each placeholder screen follows the same pattern. Create 5 screens with this template (vary title and icon per screen):

```dart
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Organizer')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dashboard_outlined, size: 64, color: AppColors.neutral400),
              const SizedBox(height: AppDimensions.base),
              Text('Segera hadir', style: AppTypography.headingSmall),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Fitur dashboard organizer sedang dalam pengembangan.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Repeat for each screen with appropriate title/icon/description:

| Screen | AppBar Title | Icon | Description |
|--------|-------------|------|-------------|
| `OrganizerDashboardScreen` | Dashboard Organizer | `Icons.dashboard_outlined` | Fitur dashboard organizer sedang dalam pengembangan. |
| `OrganizerSessionListScreen` | Sesi Saya | `Icons.event_outlined` | Fitur manajemen sesi sedang dalam pengembangan. |
| `OrganizerCommunityScreen` | Komunitas | `Icons.group_outlined` | Fitur komunitas sedang dalam pengembangan. |
| `OwnerDashboardScreen` | Dashboard Owner | `Icons.store_outlined` | Fitur dashboard pemilik lapangan sedang dalam pengembangan. |
| `OwnerVenueListScreen` | Venue Saya | `Icons.location_on_outlined` | Fitur manajemen venue sedang dalam pengembangan. |

**Step 2: Verify**

Run: `flutter analyze lib/features/organizer/ lib/features/owner/`
Expected: No issues

**Step 3: Commit**

```bash
git add lib/features/organizer/ lib/features/owner/
git commit -m "feat: add placeholder screens for organizer and court owner roles"
```

---

### Task 5: Wire Routes for Organizer & Court Owner Shells

**Files:**
- Modify: `lib/routing/app_router.dart`

**Step 1: Add imports for new screens**

Add at the top of `app_router.dart`:
```dart
import 'package:hyperarena/features/organizer/presentation/screens/organizer_dashboard_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_session_list_screen.dart';
import 'package:hyperarena/features/organizer/presentation/screens/organizer_community_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_dashboard_screen.dart';
import 'package:hyperarena/features/owner/presentation/screens/owner_venue_list_screen.dart';
```

**Step 2: Add Organizer shell route**

After the Coach shell route block (after line ~318), add:

```dart
// ── Organizer role shell (4 tabs) ────────────────
StatefulShellRoute.indexedStack(
  builder: (_, _, shell) => RoleShell(
    navigationShell: shell,
    role: UserRole.organizer,
  ),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/organizer/dashboard',
        builder: (_, _) => const OrganizerDashboardScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/organizer/sessions',
        builder: (_, _) => const OrganizerSessionListScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/organizer/community',
        builder: (_, _) => const OrganizerCommunityScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/organizer/profile',
        builder: (_, _) => const ProfileScreen(),
      ),
    ]),
  ],
),
```

**Step 3: Add Court Owner shell route**

After the Organizer shell:

```dart
// ── Court Owner role shell (3 tabs) ──────────────
StatefulShellRoute.indexedStack(
  builder: (_, _, shell) => RoleShell(
    navigationShell: shell,
    role: UserRole.courtOwner,
  ),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/owner/dashboard',
        builder: (_, _) => const OwnerDashboardScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/owner/venues',
        builder: (_, _) => const OwnerVenueListScreen(),
      ),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(
        path: '/owner/profile',
        builder: (_, _) => const ProfileScreen(),
      ),
    ]),
  ],
),
```

**Step 4: Fix the redirect to use AppRoutes**

Replace the redirect block (lines 143-158) with:

```dart
redirect: (context, state) {
  final isAuthenticated = authState != null;
  final isPublicRoute = _publicPaths.contains(state.matchedLocation);

  if (!isAuthenticated && !isPublicRoute) {
    return AppRoutes.login;
  }

  if (isAuthenticated && isPublicRoute) {
    return AppRoutes.home(authState.role);
  }

  return null;
},
```

Add import at top: `import 'package:hyperarena/routing/app_routes.dart';`

**Step 5: Verify**

Run: `flutter analyze lib/routing/app_router.dart`
Expected: No issues

**Step 6: Commit**

```bash
git add lib/routing/app_router.dart
git commit -m "feat: wire organizer + court owner shells, use AppRoutes in redirect"
```

---

### Task 6: Update Login Screen — 4-Role Quick Login Grid

**Files:**
- Modify: `lib/features/auth/presentation/screens/login_screen.dart`

**Step 1: Replace the 2-button Row with a 2x2 grid**

Replace the current quick-login section (the Row with Player/Coach buttons) with:

```dart
if (ref.read(appConfigProvider).useMockData) ...[
  const SizedBox(height: AppDimensions.xl),
  Divider(color: AppColors.neutral200),
  const SizedBox(height: AppDimensions.sm),
  Text(
    'Quick Login (Mock)',
    style: AppTypography.caption.copyWith(
      color: AppColors.textTertiary,
    ),
    textAlign: TextAlign.center,
  ),
  const SizedBox(height: AppDimensions.sm),
  Row(
    children: [
      Expanded(
        child: _QuickLoginButton(
          label: 'Player',
          icon: Icons.person,
          color: AppColors.primary,
          onPressed: _isLoading
              ? null
              : () => _quickLogin(MockUsers.currentUser.email),
        ),
      ),
      const SizedBox(width: AppDimensions.sm),
      Expanded(
        child: _QuickLoginButton(
          label: 'Coach',
          icon: Icons.sports,
          color: AppColors.secondary,
          onPressed: _isLoading
              ? null
              : () => _quickLogin(MockUsers.coachUser.email),
        ),
      ),
    ],
  ),
  const SizedBox(height: AppDimensions.sm),
  Row(
    children: [
      Expanded(
        child: _QuickLoginButton(
          label: 'Host',
          icon: Icons.event,
          color: AppColors.accent,
          onPressed: _isLoading
              ? null
              : () => _quickLogin(MockUsers.organizerUser.email),
        ),
      ),
      const SizedBox(width: AppDimensions.sm),
      Expanded(
        child: _QuickLoginButton(
          label: 'Owner',
          icon: Icons.store,
          color: AppColors.neutral500,
          onPressed: _isLoading
              ? null
              : () => _quickLogin(MockUsers.ownerUser.email),
        ),
      ),
    ],
  ),
],
```

**Step 2: Add `_QuickLoginButton` widget at the bottom of the file**

```dart
class _QuickLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _QuickLoginButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
      ),
    );
  }
}
```

**Step 3: Verify**

Run: `flutter analyze lib/features/auth/presentation/screens/login_screen.dart`
Expected: No issues

**Step 4: Commit**

```bash
git add lib/features/auth/presentation/screens/login_screen.dart
git commit -m "feat: 4-role quick login grid on login screen"
```

---

### Task 7: Replace Hardcoded Routes — Auth & Splash

**Files:**
- Modify: `lib/features/auth/presentation/screens/splash_screen.dart`
- Modify: `lib/features/auth/presentation/screens/sport_selection_screen.dart`
- Modify: `lib/features/auth/presentation/screens/onboarding_screen.dart`
- Modify: `lib/features/auth/presentation/screens/register_screen.dart`
- Modify: `lib/features/profile/presentation/screens/profile_screen.dart`

**Step 1: Fix splash_screen.dart**

Import `AppRoutes`:
```dart
import 'package:hyperarena/routing/app_routes.dart';
```

Replace lines 52-54:
```dart
// Before:
context.go(user.role == UserRole.coach
    ? '/coach/dashboard'
    : '/player/home');

// After:
context.go(AppRoutes.home(user.role));
```

Remove the now-unused `app_enums.dart` import (AppRoutes handles the enum internally).

Replace lines 61-63:
```dart
// Before:
context.go('/onboarding');
// After:
context.go(AppRoutes.onboarding);

// Before:
context.go('/auth/login');
// After:
context.go(AppRoutes.login);
```

**Step 2: Fix sport_selection_screen.dart**

Import `AppRoutes` and `auth_provider.dart`.

Replace the hardcoded `/player/home` (line ~164):
```dart
// Before:
? () => context.go('/player/home')
// After:
? () {
    final role = ref.read(authNotifierProvider)?.role ?? UserRole.player;
    context.go(AppRoutes.home(role));
  }
```

**Step 3: Fix onboarding_screen.dart**

Import `AppRoutes`.

Replace:
```dart
// Before:
context.go('/auth/login');
// After:
context.go(AppRoutes.login);
```

**Step 4: Fix register_screen.dart**

Import `AppRoutes`.

Replace:
```dart
// Before:
context.go('/auth/sport-selection');
// After:
context.go(AppRoutes.sportSelection);

// Before:
context.go('/auth/login');
// After:
context.go(AppRoutes.login);
```

**Step 5: Fix profile_screen.dart**

Import `AppRoutes`.

Replace logout navigation:
```dart
// Before:
if (context.mounted) context.go('/auth/login');
// After:
if (context.mounted) context.go(AppRoutes.login);
```

**Step 6: Verify**

Run: `flutter analyze lib/features/auth/ lib/features/profile/`
Expected: No issues

**Step 7: Commit**

```bash
git add lib/features/auth/ lib/features/profile/
git commit -m "refactor: replace hardcoded routes with AppRoutes in auth + profile"
```

---

### Task 8: Replace Hardcoded Routes — Booking, Home, Session, Coach Screens

**Files:**
- Modify: `lib/features/home/presentation/screens/home_screen.dart`
- Modify: `lib/features/booking/presentation/screens/booking_confirmation_screen.dart`
- Modify: `lib/features/booking/presentation/screens/booking_date_screen.dart`
- Modify: `lib/features/booking/presentation/screens/slot_selection_screen.dart`
- Modify: `lib/features/booking/presentation/screens/booking_summary_screen.dart`
- Modify: `lib/features/booking/presentation/screens/payment_screen.dart`
- Modify: `lib/features/booking/presentation/widgets/booking_card.dart`
- Modify: `lib/features/session/presentation/widgets/session_card.dart`
- Modify: `lib/features/session/presentation/screens/session_payment_screen.dart`
- Modify: `lib/features/session/presentation/screens/session_confirmation_screen.dart`
- Modify: `lib/features/venue/presentation/widgets/venue_card.dart`
- Modify: `lib/features/venue/presentation/widgets/court_card.dart`
- Modify: `lib/features/coach/presentation/widgets/coach_card.dart`
- Modify: `lib/features/coach/presentation/screens/coach_detail_screen.dart`
- Modify: `lib/features/coach/presentation/screens/coach_booking_screen.dart`
- Modify: `lib/features/coach/presentation/screens/coach_booking_payment_screen.dart`
- Modify: `lib/features/coach/presentation/screens/coach_booking_confirmation_screen.dart`
- Modify: `lib/features/coach/presentation/screens/student_list_screen.dart`
- Modify: `lib/features/coach/presentation/screens/student_detail_screen.dart`

**Step 1: Fix home_screen.dart (role-aware)**

Import `AppRoutes` and `auth_provider.dart`.

```dart
// Line 78 — Before:
onTap: () => context.go('/player/profile'),
// After:
onTap: () => context.go(AppRoutes.profile(ref.read(authNotifierProvider)!.role)),

// Line 95 — Before:
onTap: () => context.go('/player/explore'),
// After:
onTap: () => context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role)),

// Line 186 — Before:
context.go('/player/explore');
// After:
context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));
```

**Step 2: Fix booking_confirmation_screen.dart (role-aware)**

Import `AppRoutes` and `auth_provider.dart`.

```dart
// Line 159 — Before:
context.go('/player/bookings');
// After:
final role = ref.read(authNotifierProvider)!.role;
context.go(AppRoutes.bookings(role));

// Line 172 — Before:
context.go('/player/home');
// After:
context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
```

**Step 3: Fix session_confirmation_screen.dart (role-aware)**

Import `AppRoutes` and `auth_provider.dart`.

```dart
// Line 154 — Before:
context.go('/player/explore');
// After:
context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));

// Line 167 — Before:
context.go('/player/home');
// After:
context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
```

**Step 4: Fix coach_booking_confirmation_screen.dart (role-aware)**

Import `AppRoutes` and `auth_provider.dart`.

```dart
// Line 52 — Before:
context.go('/player/explore');
// After:
context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));

// Line 57 — Before:
context.go('/player/home');
// After:
context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
```

**Step 5: Fix role-neutral routes with constants**

All remaining files — replace string literals with `AppRoutes.*` constants:

```dart
// venue_card.dart:
context.push('/venue/${venue.id}')  →  context.push(AppRoutes.venue(venue.id))

// court_card.dart:
context.push('/booking/flow/court/${court.id}')  →  context.push(AppRoutes.bookingFlowCourt(court.id))

// booking_date_screen.dart:
context.push('/booking/flow/slots')  →  context.push(AppRoutes.bookingFlowSlots)

// slot_selection_screen.dart:
context.push('/booking/flow/summary')  →  context.push(AppRoutes.bookingFlowSummary)

// booking_summary_screen.dart:
context.push('/booking/flow/payment')  →  context.push(AppRoutes.bookingFlowPayment)

// payment_screen.dart:
context.go('/booking/flow/confirmation/mock')  →  context.go(AppRoutes.bookingFlowConfirmation('mock'))

// booking_card.dart:
context.push('/booking/${booking.id}')  →  context.push(AppRoutes.booking(booking.id))

// session_card.dart:
context.push('/session/${session.id}')  →  context.push(AppRoutes.session(session.id))

// session_payment_screen.dart:
context.go('/session/flow/confirmation')  →  context.go(AppRoutes.sessionFlowConfirmation)

// coach_card.dart:
context.push('/coach/${coach.id}')  →  context.push(AppRoutes.coach(coach.id))

// coach_detail_screen.dart:
context.push('/coach/booking')  →  context.push(AppRoutes.coachBooking)

// coach_booking_screen.dart:
context.push('/coach/booking/payment')  →  context.push(AppRoutes.coachBookingPayment)

// coach_booking_payment_screen.dart:
context.go('/coach/booking/confirmation')  →  context.go(AppRoutes.coachBookingConfirmation)

// student_list_screen.dart:
'/coach/student/${...}'  →  AppRoutes.studentDetail(name)

// student_detail_screen.dart:
context.push('/coach/assessment/new')  →  context.push(AppRoutes.assessmentNew)
```

**Step 6: Also update app_router.dart route definitions**

In `app_router.dart`, replace all hardcoded path strings with `AppRoutes.*`:

```dart
// Before:
path: '/splash',
// After:
path: AppRoutes.splash,
```

Do this for ALL GoRoute path definitions in the file. This ensures the route definitions and navigation calls always reference the same source of truth.

**Step 7: Verify**

Run: `flutter analyze`
Expected: No issues across the entire project

**Step 8: Commit**

```bash
git add lib/
git commit -m "refactor: replace all hardcoded routes with AppRoutes constants"
```

---

### Task 9: Update Explore Tabs for Organizer Role

**Files:**
- Modify: `lib/routing/app_router.dart`

The Organizer shell includes a "Sessions" tab. The organizer should see their **own** sessions (ones they created), not the player's explore view. For now, wire it to the placeholder screen. But the organizer also needs to browse venues to book courts for sessions.

This is already handled — the `OrganizerSessionListScreen` placeholder is wired to `/organizer/sessions`. No additional work needed for this task beyond what's in Task 5.

**Note:** When Organizer features are built later, the "Sessions" tab will show the organizer's created sessions with create/edit/cancel actions. The "Community" tab will show participants across sessions with management tools.

---

### Verification

After all tasks are complete:

```bash
# Full analysis
flutter analyze

# Build check
flutter build apk --debug -t lib/main_mock.dart

# Manual test on emulator
flutter run -t lib/main_mock.dart -d emulator-5554
```

**Test flow:**
1. Login screen shows 4 quick-login buttons (Player, Coach, Host, Owner)
2. Tap **Player** → Player shell (Home, Explore, Bookings, Profile)
3. Logout → Tap **Coach** → Coach shell (Dashboard, Schedule, Students, Profile)
4. Logout → Tap **Host** → Organizer shell (Dashboard, Sessions, Community, Profile) — all placeholder
5. Logout → Tap **Owner** → Court Owner shell (Dashboard, Venues, Profile) — all placeholder
6. Navigate through booking flow → confirmation → "Lihat Booking" and "Kembali" use role-aware routes
7. Navigate to session detail → join → confirmation → routes are role-aware
8. No hardcoded `/player/` or `/coach/` strings remain outside `app_routes.dart`
