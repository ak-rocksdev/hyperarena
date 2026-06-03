import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_dashboard_summary.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_dashboard_screen.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_dashboard_summary_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';

class _StubAuth extends AuthNotifier {
  _StubAuth(this._u);
  final User? _u;
  @override
  User? build() => _u;
}

void main() {
  testWidgets('coach dashboard renders all sections with seeded data',
      (tester) async {
    const user = User(
      id: 'u1',
      name: 'Andi Pratama',
      email: 'a@x.com',
      role: UserRole.coach,
      availableRoles: ['coach'],
    );

    final summary = CoachDashboardSummary(
      performance: const SectionResult.success(CoachPerformance(
        earningsThisWeekCents: 0,
        earningsThisMonthCents: 1000000,
        sessionsThisWeek: 3,
        sessionsThisMonth: 12,
        activeStudentCount: 8,
      )),
      actions: const SectionResult.success(CoachActionCounts(
        absencesUnmarked: 1,
        assessmentsUngraded: 2,
        studentsUngraded: 4,
      )),
      attentionList: const SectionResult.success([
        CoachStudentRosterItem(
          studentProfileId: 's1',
          fullName: 'Anna',
        ),
        CoachStudentRosterItem(
          studentProfileId: 's2',
          fullName: 'Bobi',
        ),
      ]),
      sportBreakdown: const SectionResult.success(
          {Sport.tennis: 5, Sport.padel: 3}),
      sessionsTomorrow: 2,
    );

    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (_, __) => const CoachDashboardScreen()),
      GoRoute(
          path: '/coach/students/:id',
          builder: (_, __) => const Scaffold()),
      GoRoute(path: '/coach/students', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/coach/schedule', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/notifications', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/profile', builder: (_, __) => const Scaffold()),
    ]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith(() => _StubAuth(user)),
        coachDashboardSummaryProvider.overrideWith((ref) async => summary),
        coachScheduleProvider
            .overrideWith((ref) => Future.value(<CoachingBooking>[])),
        assessmentListProvider
            .overrideWith((ref) => Future.value(<Assessment>[])),
        unreadCountProvider.overrideWith(() => _StubUnreadCount()),
        tenantCurrencyProvider.overrideWithValue('IDR'),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          extensions: const [
            SportThemeExtension(),
            BookingStatusThemeExtension(),
            GamificationThemeExtension(),
          ],
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Role pill
    expect(find.text('MODE COACH'), findsOneWidget);

    // Greeting includes first name
    expect(find.textContaining('Andi'), findsOneWidget);

    // Today schedule section title
    expect(find.text('Jadwal Hari Ini'), findsOneWidget);

    // Performance card labels
    expect(find.text('Penghasilan'), findsOneWidget);
    expect(find.text('Sesi'), findsOneWidget);
    expect(find.text('Murid Aktif'), findsOneWidget);

    // Attention list with both students
    expect(find.text('Perlu Perhatian'), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('Bobi'), findsOneWidget);

    // Sport breakdown (populated map — chart + title rendered)
    expect(find.text('Distribusi Murid'), findsOneWidget);
  });
}

class _StubUnreadCount extends UnreadCountNotifier {
  @override
  Future<int> build() async => 0;
}
