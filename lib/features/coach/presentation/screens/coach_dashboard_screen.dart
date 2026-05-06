import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/features/notification/presentation/widgets/notification_bell.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final scheduleAsync = ref.watch(coachScheduleProvider);
    final assessmentsAsync = ref.watch(assessmentListProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),

              // ── 1. Greeting + Notification Bell ─────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting()}, ${Formatters.firstName(user?.name, fallback: 'Coach')}!',
                          style: AppTypography.headingLarge,
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'Kelola jadwal dan murid Anda',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const NotificationBell(),
                ],
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── 2. Quick Stats Row ───────────────────────────────
              const _QuickStatsRow(),
              const SizedBox(height: AppDimensions.xl),

              // ── 3. Jadwal Hari Ini ───────────────────────────────
              Text('Jadwal Hari Ini', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              AsyncValueWidget<List<CoachingBooking>>(
                value: scheduleAsync,
                data: (bookings) {
                  final now = DateTime.now();
                  final todayBookings = bookings
                      .where((b) =>
                          b.date.year == now.year &&
                          b.date.month == now.month &&
                          b.date.day == now.day)
                      .toList();

                  if (todayBookings.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.lg,
                      ),
                      child: Center(
                        child: Text(
                          'Tidak ada jadwal hari ini',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: todayBookings
                        .map((booking) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.sm,
                              ),
                              child: _ScheduleCard(booking: booking),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: AppDimensions.xl),

              // ── 4. Penilaian Terbaru ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Penilaian Terbaru', style: AppTypography.titleMedium),
                  TextButton(
                    onPressed: () {
                      // Navigate to students tab where per-student assessments live
                      context.go('/coach/students');
                    },
                    child: Text(
                      'Lihat Semua',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              AsyncValueWidget<List<Assessment>>(
                value: assessmentsAsync,
                data: (assessments) {
                  final sorted = [...assessments]
                    ..sort((a, b) => b.date.compareTo(a.date));
                  final recent = sorted.take(3).toList();

                  if (recent.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.lg,
                      ),
                      child: Center(
                        child: Text(
                          'Belum ada penilaian',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: recent
                        .map((assessment) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.sm,
                              ),
                              child: _AssessmentCard(assessment: assessment),
                            ))
                        .toList(),
                  );
                },
              ),
              // "Ulasan Terbaru" intentionally absent — design forbids coach
              // visibility into student reviews. Admin communicates feedback
              // manually.
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people_outline,
            value: '120',
            label: 'Total Murid',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            value: '8',
            label: 'Sesi Minggu Ini',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: '4.8',
            label: 'Rating',
          ),
        ),
      ],
    );
  }
}

// ── Single Stat Card ───────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: AppDimensions.iconMd),
          const SizedBox(height: AppDimensions.sm),
          Text(value, style: AppTypography.numberMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Schedule Card (today's booking) ────────────────────────────────────
class _ScheduleCard extends StatelessWidget {
  final CoachingBooking booking;

  const _ScheduleCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time range
          Text(
            Formatters.formatTimeRange(booking.startTime, booking.endTime),
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Student name
          Text(booking.playerName, style: AppTypography.titleSmall),
          const SizedBox(height: AppDimensions.sm),

          // Sport pill + Status badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: sportTheme.backgroundColor(booking.sport),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  SportChipSelector.sportLabel(booking.sport),
                  style: AppTypography.badge.copyWith(
                    color: sportTheme.textColor(booking.sport),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: statusTheme.backgroundColor(booking.status),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  StatusBadge.statusLabel(booking.status),
                  style: AppTypography.badge.copyWith(
                    color: statusTheme.textColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Assessment Card ────────────────────────────────────────────────────
class _AssessmentCard extends StatelessWidget {
  final Assessment assessment;

  const _AssessmentCard({required this.assessment});

  double get _averageScore =>
      (assessment.technique +
          assessment.stamina +
          assessment.tactics +
          assessment.mentality +
          assessment.consistency) /
      5;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          // Left: student info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assessment.studentName, style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: sportTheme.backgroundColor(assessment.sport),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        SportChipSelector.sportLabel(assessment.sport),
                        style: AppTypography.badge.copyWith(
                          color: sportTheme.textColor(assessment.sport),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      Formatters.formatDate(assessment.date),
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: average score + recommended level
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _averageScore.toStringAsFixed(1),
                style: AppTypography.numberMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.xxs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xxs,
                ),
                decoration: BoxDecoration(
                  color: gamification
                      .levelBackgroundColor(assessment.recommendedLevel),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  GamificationHelpers.tierLabel(assessment.recommendedLevel),
                  style: AppTypography.badge.copyWith(
                    color: gamification
                        .levelTextColor(assessment.recommendedLevel),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

