import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_animations.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.elastic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(bookingFlowProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated success icon
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.md,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 48,
                    color: AppColors.success,
                  ),
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

              // Summary card with shadow
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.base),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: AppShadows.sm,
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
                        Formatters.formatCurrency(flow.totalAmount, currency),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              // Primary button with glow
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: AppShadows.colored,
                ),
                child: AppButton(
                  label: 'Lihat Booking Saya',
                  isLarge: true,
                  onPressed: () {
                    ref.read(bookingFlowProvider.notifier).reset();
                    context.go(AppRoutes.bookings(ref.read(authNotifierProvider)!.role));
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
                    context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
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
