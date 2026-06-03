import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

class CoachDashboardTodaySchedule extends ConsumerWidget {
  const CoachDashboardTodaySchedule({super.key, this.sessionsTomorrow = 0});

  final int sessionsTomorrow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(coachScheduleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              return const EmptyState(
                icon: Icons.event_available,
                message: 'Tidak ada jadwal hari ini',
              );
            }
            return Column(
              children: todayBookings
                  .map((b) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimensions.sm),
                        child: _ScheduleCard(booking: b),
                      ))
                  .toList(),
            );
          },
        ),
        if (sessionsTomorrow > 0)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.sm),
            child: Text(
              'Besok: $sessionsTomorrow sesi',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textTertiary),
            ),
          ),
      ],
    );
  }
}

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
          Text(
            Formatters.formatTimeRange(booking.startTime, booking.endTime),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(booking.playerName, style: AppTypography.titleSmall),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
                decoration: BoxDecoration(
                  color: sportTheme.backgroundColor(booking.sport),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  SportChipSelector.sportLabel(booking.sport),
                  style: AppTypography.badge
                      .copyWith(color: sportTheme.textColor(booking.sport)),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
                decoration: BoxDecoration(
                  color: statusTheme.backgroundColor(booking.status),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  StatusBadge.statusLabel(booking.status),
                  style: AppTypography.badge
                      .copyWith(color: statusTheme.textColor(booking.status)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
