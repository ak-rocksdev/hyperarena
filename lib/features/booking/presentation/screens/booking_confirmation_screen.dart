import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';

class BookingConfirmationScreen extends ConsumerWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(bookingFlowProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 48,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              Text(
                'Booking Berhasil Dibuat!',
                style: AppTypography.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),

              Text(
                'Menunggu konfirmasi pembayaran',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.xl),

              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.base),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Column(
                  children: [
                    if (flow.venue != null)
                      Text(
                        flow.venue!.name,
                        style: AppTypography.titleSmall,
                      ),
                    if (flow.court != null)
                      Text(
                        flow.court!.name,
                        style: AppTypography.bodySmall,
                      ),
                    const SizedBox(height: AppDimensions.sm),
                    if (flow.date != null)
                      Text(
                        Formatters.formatDate(flow.date!),
                        style: AppTypography.bodyMedium,
                      ),
                    if (flow.slots.isNotEmpty) ...[
                      Text(
                        '${flow.slots.first.startTime} - ${flow.slots.last.endTime}',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        Formatters.formatRupiah(flow.totalAmount),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Lihat Booking Saya',
                  isLarge: true,
                  onPressed: () {
                    ref.read(bookingFlowProvider.notifier).reset();
                    context.go('/player/bookings');
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Kembali ke Beranda',
                  variant: AppButtonVariant.outlined,
                  isLarge: true,
                  onPressed: () {
                    ref.read(bookingFlowProvider.notifier).reset();
                    context.go('/player/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
