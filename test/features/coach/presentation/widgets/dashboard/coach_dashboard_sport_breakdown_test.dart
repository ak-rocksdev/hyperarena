import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart';

void main() {
  testWidgets('section hidden when empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardSportBreakdown(
            result: SectionResult.success(<Sport, int>{}),
          ),
        ),
      ),
    );
    expect(find.text('Distribusi Murid'), findsNothing);
  });

  testWidgets('renders distribution when populated', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoachDashboardSportBreakdown(
            result: SectionResult.success(<Sport, int>{
              Sport.tennis: 4,
              Sport.padel: 2,
            }),
          ),
        ),
      ),
    );
    expect(find.text('Distribusi Murid'), findsOneWidget);
  });
}
