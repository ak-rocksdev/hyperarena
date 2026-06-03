import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('renders up to 5 items', (tester) async {
    final students = List.generate(
      7,
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
    expect(find.text('Student 5'), findsNothing);
  });
}
