import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

CoachingBooking _booking(DateTime date) => CoachingBooking(
      id: 'b1',
      coachId: 'coach-001',
      coachName: 'Coach',
      playerId: 'p1',
      playerName: 'Player A',
      packageId: 'pkg-1',
      packageName: 'Standard',
      sport: Sport.tennis,
      venueName: 'Court 1',
      date: date,
      startTime: '08:00',
      endTime: '09:00',
      status: BookingStatus.confirmed,
      amount: 100000,
      createdAt: DateTime(2026, 1, 1),
    );

void main() {
  testWidgets('renders today bookings only', (tester) async {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith(
            (ref) => Future.value([_booking(now), _booking(tomorrow)]),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [
              SportThemeExtension(),
              BookingStatusThemeExtension(),
            ],
          ),
          home: const Scaffold(body: CoachDashboardTodaySchedule()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Jadwal Hari Ini'), findsOneWidget);
    expect(find.text('Player A'), findsOneWidget);
  });

  testWidgets('shows EmptyState when no bookings today', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith(
              (ref) => Future.value(<CoachingBooking>[])),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [
              SportThemeExtension(),
              BookingStatusThemeExtension(),
            ],
          ),
          home: const Scaffold(body: CoachDashboardTodaySchedule()),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Tidak ada jadwal hari ini'), findsOneWidget);
  });

  testWidgets('renders "Besok: N sesi" hint when sessionsTomorrow > 0',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith(
              (ref) => Future.value(<CoachingBooking>[])),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardTodaySchedule(sessionsTomorrow: 3)),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Besok: 3 sesi'), findsOneWidget);
  });

  testWidgets('hint hidden when sessionsTomorrow is 0', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          coachScheduleProvider.overrideWith(
              (ref) => Future.value(<CoachingBooking>[])),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CoachDashboardTodaySchedule()),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('Besok:'), findsNothing);
  });
}
