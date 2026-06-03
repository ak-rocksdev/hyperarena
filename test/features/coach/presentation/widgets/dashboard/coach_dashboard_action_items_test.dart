import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart';

GoRouter _routerCapturing(List<String> pushed) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: CoachDashboardActionItems(
              result: SectionResult.success(CoachActionCounts(
                absencesUnmarked: 1,
                assessmentsUngraded: 2,
                studentsUngraded: 3,
              )),
            ),
          ),
        ),
        GoRoute(
          path: '/coach/schedule',
          builder: (_, state) {
            final q = state.uri.query;
            pushed.add('/coach/schedule${q.isEmpty ? '' : '?$q'}');
            return const Scaffold();
          },
        ),
        GoRoute(
          path: '/coach/students',
          builder: (_, state) {
            final q = state.uri.query;
            pushed.add('/coach/students${q.isEmpty ? '' : '?$q'}');
            return const Scaffold();
          },
        ),
      ],
    );

void main() {
  testWidgets('renders SizedBox.shrink when all counts are zero', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult.success(CoachActionCounts(
              absencesUnmarked: 0,
              assessmentsUngraded: 0,
              studentsUngraded: 0,
            )),
          ),
        ),
      ),
    );
    expect(find.textContaining('absensi'), findsNothing);
    expect(find.textContaining('penilaian'), findsNothing);
  });

  testWidgets('renders rows for nonzero counts', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult.success(CoachActionCounts(
              absencesUnmarked: 3,
              assessmentsUngraded: 2,
              studentsUngraded: 4,
            )),
          ),
        ),
      ),
    );
    expect(find.textContaining('3'), findsOneWidget);
    expect(find.textContaining('2'), findsOneWidget);
    expect(find.textContaining('4'), findsOneWidget);
  });

  testWidgets('renders inline retry on SectionResult.failure', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardActionItems(
            result: SectionResult<CoachActionCounts>.failure(
              Exception('x'),
              null,
            ),
            onRetry: () {},
          ),
        ),
      ),
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('tap on absensi row navigates to /coach/schedule?filter=unmarked',
      (tester) async {
    final pushed = <String>[];
    await tester.pumpWidget(
        MaterialApp.router(routerConfig: _routerCapturing(pushed)));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('absensi'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/coach/schedule?filter=unmarked'));
  });

  testWidgets('tap on penilaian row navigates to /coach/schedule?filter=ungraded',
      (tester) async {
    final pushed = <String>[];
    await tester.pumpWidget(
        MaterialApp.router(routerConfig: _routerCapturing(pushed)));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('penilaian'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/coach/schedule?filter=ungraded'));
  });

  testWidgets('tap on murid row navigates to /coach/students?filter=ungraded',
      (tester) async {
    final pushed = <String>[];
    await tester.pumpWidget(
        MaterialApp.router(routerConfig: _routerCapturing(pushed)));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('murid'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/coach/students?filter=ungraded'));
  });
}
