import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_animations.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachBookingConfirmationScreen extends ConsumerStatefulWidget {
  const CoachBookingConfirmationScreen({super.key});

  @override
  ConsumerState<CoachBookingConfirmationScreen> createState() =>
      _CoachBookingConfirmationScreenState();
}

class _CoachBookingConfirmationScreenState
    extends ConsumerState<CoachBookingConfirmationScreen>
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

  void _goToExplore() {
    ref.read(coachBookingProvider.notifier).reset();
    context.go(AppRoutes.explore(ref.read(authNotifierProvider)!.role));
  }

  void _goToHome() {
    ref.read(coachBookingProvider.notifier).reset();
    context.go(AppRoutes.home(ref.read(authNotifierProvider)!.role));
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(coachBookingProvider);
    final coach = bookingState.coach;
    final package = bookingState.package;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
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
                'Booking Coaching Berhasil!',
                style: AppTypography.headingLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.md),

              Text(
                'Sesi coaching kamu telah dijadwalkan',
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
                  color: AppSurfaces.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: AppShadows.sm,
                ),
                child: Column(
                  children: [
                    if (coach != null)
                      Text(
                        coach.name,
                        style: AppTypography.titleMedium,
                      ),
                    if (package != null) ...[
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        package.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimensions.sm),
                    if (bookingState.date != null)
                      Text(
                        Formatters.formatDate(bookingState.date!),
                        style: AppTypography.bodyMedium,
                      ),
                    if (bookingState.startTime != null &&
                        bookingState.endTime != null)
                      Text(
                        Formatters.formatTimeRange(
                          bookingState.startTime!,
                          bookingState.endTime!,
                        ),
                        style: AppTypography.bodyMedium,
                      ),
                    if (bookingState.venueName != null &&
                        bookingState.venueName!.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.xs),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: AppDimensions.iconXs,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: AppDimensions.xs),
                          Text(
                            bookingState.venueName!,
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      Formatters.formatRupiah(bookingState.totalAmount),
                      style: AppTypography.priceLarge,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Buttons
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: AppShadows.colored,
                ),
                child: AppButton(
                  label: 'Kembali ke Explore',
                  isLarge: true,
                  onPressed: _goToExplore,
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Kembali ke Beranda',
                  variant: AppButtonVariant.outlined,
                  isLarge: true,
                  onPressed: _goToHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
