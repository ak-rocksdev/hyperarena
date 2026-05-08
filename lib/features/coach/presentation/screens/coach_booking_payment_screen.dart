import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachBookingPaymentScreen extends ConsumerStatefulWidget {
  const CoachBookingPaymentScreen({super.key});

  @override
  ConsumerState<CoachBookingPaymentScreen> createState() =>
      _CoachBookingPaymentScreenState();
}

class _CoachBookingPaymentScreenState
    extends ConsumerState<CoachBookingPaymentScreen> {
  Timer? _timer;
  Duration _remaining = const Duration(minutes: 30);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() => _remaining -= const Duration(seconds: 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _confirmPayment() async {
    AppHaptics.tap();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.go(AppRoutes.coachBookingConfirmation);
    }
  }

  String get _countdownText {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(coachBookingProvider);
    final currency = ref.watch(tenantCurrencyProvider);
    final amount = bookingState.totalAmount;
    final packageName = bookingState.package?.name ?? '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'QRIS'),
              Tab(text: 'Transfer Bank'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Countdown + amount
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppDimensions.base),
              padding: const EdgeInsets.all(AppDimensions.base),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: AppShadows.sm,
              ),
              child: Column(
                children: [
                  Text(
                    'Bayar dalam $_countdownText',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.warningDark,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    Formatters.formatCurrency(amount, currency),
                    style: AppTypography.priceLarge,
                  ),
                  if (packageName.isNotEmpty)
                    Text(
                      packageName,
                      style: AppTypography.caption,
                    ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // QRIS tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppSurfaces.surface,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLg),
                            boxShadow: AppShadows.sm,
                            border: Border.all(
                              color: AppColors.neutral200,
                              width: 1.5,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: const Icon(Icons.qr_code_2, size: 120),
                        ),
                        const SizedBox(height: AppDimensions.base),
                        Text(
                          'Scan QR di atas untuk membayar',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bank Transfer tab
                  Padding(
                    padding:
                        const EdgeInsets.all(AppDimensions.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.xl),
                        Container(
                          padding: const EdgeInsets.all(AppDimensions.base),
                          decoration: BoxDecoration(
                            color: AppSurfaces.surface,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd),
                            boxShadow: AppShadows.xs,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BCA',
                                  style: AppTypography.titleMedium),
                              const SizedBox(height: AppDimensions.md),
                              Text('1234567890',
                                  style: AppTypography.numberMedium),
                              const SizedBox(height: AppDimensions.xs),
                              Text(
                                'a.n. HyperArena Payment',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: AppShadows.colored,
                ),
                child: AppButton(
                  label: 'Saya Sudah Bayar',
                  isLarge: true,
                  isLoading: _isLoading,
                  onPressed: _confirmPayment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
