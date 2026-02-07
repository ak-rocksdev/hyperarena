import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/booking/presentation/widgets/booking_card.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingListProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Saya'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mendatang'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: AsyncValueWidget(
          value: bookingsAsync,
          loading: () => Padding(
            padding:
                const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 100),
                ),
              ),
            ),
          ),
          error: (e, _) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(bookingListProvider),
          ),
          data: (bookings) {
            final upcoming = bookings.where((b) =>
                b.status == BookingStatus.pendingPayment ||
                b.status == BookingStatus.waitingConfirmation ||
                b.status == BookingStatus.confirmed);
            final past = bookings.where((b) =>
                b.status == BookingStatus.completed ||
                b.status == BookingStatus.cancelled ||
                b.status == BookingStatus.rejected ||
                b.status == BookingStatus.expired);

            return TabBarView(
              children: [
                _BookingTab(
                  bookings: upcoming.toList(),
                  emptyMessage: 'Belum ada booking mendatang',
                  ref: ref,
                ),
                _BookingTab(
                  bookings: past.toList(),
                  emptyMessage: 'Belum ada booking selesai',
                  ref: ref,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookingTab extends StatelessWidget {
  final List bookings;
  final String emptyMessage;
  final WidgetRef ref;

  const _BookingTab({
    required this.bookings,
    required this.emptyMessage,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyState(
        message: emptyMessage,
        icon: Icons.calendar_today_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(bookingListProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        itemCount: bookings.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.sm),
          child: BookingCard(booking: bookings[i]),
        ),
      ),
    );
  }
}
