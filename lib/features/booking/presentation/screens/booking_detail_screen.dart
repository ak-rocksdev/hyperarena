import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_stepper.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/review/presentation/widgets/post_booking_review_banner.dart';

class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  bool _isCancellable(BookingStatus status) =>
      status == BookingStatus.pendingPayment ||
      status == BookingStatus.waitingConfirmation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Booking')),
      body: AsyncValueWidget(
        value: bookingAsync,
        loading: () => ShimmerLoading.card(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () =>
              ref.invalidate(bookingDetailProvider(bookingId)),
        ),
        data: (booking) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status stepper
                StatusStepper(status: booking.status),
                const Divider(),

                // Post-booking review banner (only for completed court bookings)
                if (booking.status == BookingStatus.completed &&
                    booking.bookingType == BookingType.court)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ).copyWith(top: AppDimensions.md),
                    child: PostBookingReviewBanner(
                      bookingId: booking.id,
                      venueName: booking.venueName ?? 'Venue',
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(
                      AppDimensions.screenHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge + booking code
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.md),
                        decoration: BoxDecoration(
                          color: AppSurfaces.surfaceHighlight,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg),
                        ),
                        child: Row(
                          children: [
                            StatusBadge(status: booking.status),
                            const Spacer(),
                            Text(
                              booking.bookingCode,
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      // Info card
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(AppDimensions.base),
                        decoration: BoxDecoration(
                          color: AppSurfaces.surface,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg),
                          boxShadow: AppShadows.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.venueName ?? 'Venue',
                              style: AppTypography.titleMedium,
                            ),
                            Text(
                              booking.courtName ?? 'Court',
                              style: AppTypography.bodySmall,
                            ),
                            const SizedBox(height: AppDimensions.md),
                            _DetailRow(
                              Icons.calendar_today,
                              Formatters.formatDate(booking.bookingDate),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _DetailRow(
                              Icons.access_time,
                              Formatters.formatTimeRange(
                                  booking.startTime, booking.endTime),
                            ),
                            const SizedBox(height: AppDimensions.md),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total',
                                    style: AppTypography.titleSmall),
                                Text(
                                  Formatters.formatRupiah(
                                      booking.totalAmount),
                                  style: AppTypography.priceLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      // Payment info
                      Text(
                        'Pembayaran',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        booking.paymentMethod ==
                                PaymentMethodType.qris
                            ? 'QRIS'
                            : 'Transfer Bank',
                        style: AppTypography.bodyMedium,
                      ),

                      // Cancel button
                      if (_isCancellable(booking.status)) ...[
                        const SizedBox(height: AppDimensions.xxl),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSm),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error
                                    .withValues(alpha: 0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: AppButton(
                            label: 'Batalkan Booking',
                            variant: AppButtonVariant.outlined,
                            onPressed: () => _showCancelDialog(
                                context, ref, booking.id),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.screenBottom),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Booking?'),
        content: const Text(
            'Booking yang sudah dibatalkan tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(bookingRepositoryProvider)
                  .cancelBooking(id);
              ref.invalidate(bookingDetailProvider(id));
              ref.invalidate(bookingListProvider);
            },
            child: Text(
              'Ya, Batalkan',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.sm),
        Text(text, style: AppTypography.bodyMedium),
      ],
    );
  }
}
