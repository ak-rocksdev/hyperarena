import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/presentation/widgets/coaching_booking_card.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Coach's schedule tab screen with "Mendatang" (upcoming) and "Selesai" (done) tabs.
class CoachScheduleScreen extends ConsumerWidget {
  const CoachScheduleScreen({super.key});

  static const _upcomingStatuses = {
    BookingStatus.confirmed,
    BookingStatus.pendingPayment,
    BookingStatus.waitingConfirmation,
  };

  static const _doneStatuses = {
    BookingStatus.completed,
    BookingStatus.cancelled,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(coachScheduleProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal Coaching'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            labelStyle: AppTypography.labelMedium,
            unselectedLabelStyle: AppTypography.labelMedium,
            tabs: const [
              Tab(text: 'Mendatang'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Mendatang (upcoming)
            _BookingListTab(
              scheduleAsync: scheduleAsync,
              filterStatuses: _upcomingStatuses,
              emptyText: 'Belum ada jadwal',
              onRefresh: () => ref.refresh(coachScheduleProvider.future),
            ),

            // Tab 2: Selesai (done)
            _BookingListTab(
              scheduleAsync: scheduleAsync,
              filterStatuses: _doneStatuses,
              emptyText: 'Belum ada riwayat',
              onRefresh: () => ref.refresh(coachScheduleProvider.future),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable tab content that filters bookings by status set.
class _BookingListTab extends StatelessWidget {
  final AsyncValue<List<CoachingBooking>> scheduleAsync;
  final Set<BookingStatus> filterStatuses;
  final String emptyText;
  final Future<void> Function() onRefresh;

  const _BookingListTab({
    required this.scheduleAsync,
    required this.filterStatuses,
    required this.emptyText,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget<List<CoachingBooking>>(
      value: scheduleAsync,
      data: (bookings) {
        final filtered = bookings
            .where((b) => filterStatuses.contains(b.status))
            .toList();

        if (filtered.isEmpty) {
          return Center(
            child: Text(
              emptyText,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final booking = filtered[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.md),
                child: CoachingBookingCard(
                  booking: booking,
                  onTap: () => context.push(
                    AppRoutes.coachingBookingDetail(booking.id),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
