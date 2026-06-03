import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart';

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
}
