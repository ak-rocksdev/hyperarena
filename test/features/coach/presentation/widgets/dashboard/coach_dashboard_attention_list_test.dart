import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart';

void main() {
  testWidgets('positive empty when zero ungraded', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success(<CoachStudentRosterItem>[]),
          ),
        ),
      ),
    );
    expect(find.text('Semua murid sudah dinilai'), findsOneWidget);
  });

  testWidgets('avatar shows "?" when fullName is empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success([
              const CoachStudentRosterItem(
                studentProfileId: 's-empty',
                fullName: '',
                totalSessionsWithCoach: 0,
                attendanceRate: 0.0,
              ),
            ]),
          ),
        ),
      ),
    );
    expect(find.text('?'), findsOneWidget);
  });

  testWidgets('renders all items the provider returns (provider caps at 5)',
      (tester) async {
    // The provider caps the list at 5 before passing it to this widget.
    // The widget's responsibility is simply to render all received items.
    final students = List.generate(
      5,
      (i) => CoachStudentRosterItem(
        studentProfileId: 'id-$i',
        fullName: 'Student $i',
        totalSessionsWithCoach: 0,
        attendanceRate: 0.0,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success(students),
          ),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      expect(find.text('Student $i'), findsOneWidget);
    }
  });

  testWidgets('tap on student row navigates to /coach/students/{id}',
      (tester) async {
    final pushed = <String>[];
    final router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (_, state) => Scaffold(
          body: CoachDashboardAttentionList(
            result: SectionResult.success([
              const CoachStudentRosterItem(
                studentProfileId: 's-42',
                fullName: 'Alice',
                totalSessionsWithCoach: 0,
                attendanceRate: 0.0,
              ),
            ]),
          ),
        ),
      ),
      GoRoute(
        path: '/coach/students/:id',
        builder: (_, state) {
          pushed.add('/coach/students/${state.pathParameters['id']}');
          return const Scaffold();
        },
      ),
    ]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();
    expect(pushed, contains('/coach/students/s-42'));
  });
}
