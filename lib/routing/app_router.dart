import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

/// Placeholder screens for Phase 0 — replaced by real screens in Phase 1+
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

/// Role-aware bottom navigation shell.
/// Reference: Architecture doc Section 6.2
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
  };
}

/// Phase 0 router — Player shell only, placeholder screens.
/// Coach and Organizer shells added in Phase 2+3.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/player/home',
    routes: [
      // Player shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => RoleShell(
          navigationShell: shell,
          role: UserRole.player,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/home',
              builder: (_, _) => const _PlaceholderScreen(title: 'Home'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/explore',
              builder: (_, _) => const _PlaceholderScreen(title: 'Explore'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/bookings',
              builder: (_, _) => const _PlaceholderScreen(title: 'Bookings'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/player/profile',
              builder: (_, _) => const _PlaceholderScreen(title: 'Profile'),
            ),
          ]),
        ],
      ),
    ],
  );
});
