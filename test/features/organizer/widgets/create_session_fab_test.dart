import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session_fab.dart';
import 'package:hyperarena/routing/app_routes.dart';

Widget _harness(GoRouter router) => MaterialApp.router(routerConfig: router);

GoRouter _router() => GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(
            body: Center(child: CreateSessionFab(heroTag: 'test')),
          ),
        ),
        GoRoute(
          path: AppRoutes.organizerCreateSession,
          builder: (_, _) =>
              const Scaffold(body: Text('CREATE SESSION SCREEN')),
        ),
      ],
    );

void main() {
  testWidgets('renders the branded Buat Sesi pill', (tester) async {
    await tester.pumpWidget(_harness(_router()));

    expect(find.text('Buat Sesi'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    final fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.backgroundColor, AppColors.primary);
    expect(fab.foregroundColor, Colors.white);
    expect(fab.shape, const StadiumBorder());
    expect(fab.heroTag, 'test');
  });

  testWidgets('pushes the create-session route (Back returns to origin)',
      (tester) async {
    await tester.pumpWidget(_harness(_router()));

    await tester.tap(find.byType(CreateSessionFab));
    await tester.pumpAndSettle();

    // Pushed (not replaced): the create screen is shown...
    expect(find.text('CREATE SESSION SCREEN'), findsOneWidget);
    // ...on top of the origin, so it can be popped back.
    final ctx = tester.element(find.text('CREATE SESSION SCREEN'));
    expect(GoRouter.of(ctx).canPop(), isTrue);
  });
}
