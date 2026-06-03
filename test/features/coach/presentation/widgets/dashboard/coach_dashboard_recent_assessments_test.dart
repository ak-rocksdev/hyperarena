import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';

void main() {
  testWidgets('shows EmptyState with CTA when no assessments', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assessmentListProvider.overrideWith(
            (ref) => Future.value(<Assessment>[]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardRecentAssessments()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Belum ada penilaian'), findsOneWidget);
    expect(find.text('Buat Penilaian'), findsOneWidget);
  });
}
