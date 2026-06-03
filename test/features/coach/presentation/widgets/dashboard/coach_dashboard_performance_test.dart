import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart';

void main() {
  testWidgets('renders three metric cards', (tester) async {
    const perf = CoachPerformance(
      earningsThisWeekCents: 0,
      earningsThisMonthCents: 500000,
      sessionsThisWeek: 3,
      sessionsThisMonth: 12,
      activeStudentCount: 8,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tenantCurrencyProvider.overrideWithValue('IDR')],
        child: const MaterialApp(
          home: Scaffold(
            body: CoachDashboardPerformance(
              result: SectionResult.success(perf),
              sportCount: 2,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Earnings'), findsOneWidget);
    expect(find.text('Sesi'), findsOneWidget);
    expect(find.text('Murid Aktif'), findsOneWidget);
  });

  testWidgets('inline retry on failure', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tenantCurrencyProvider.overrideWithValue('IDR')],
        child: MaterialApp(
          home: Scaffold(
            body: CoachDashboardPerformance(
              result: SectionResult<CoachPerformance>.failure(Exception('x'), null),
              sportCount: 0,
              onRetry: () {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });
}
