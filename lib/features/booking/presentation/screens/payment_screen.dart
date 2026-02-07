import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_venues.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  Timer? _timer;
  Duration _remaining = const Duration(minutes: 60);
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
    setState(() => _isLoading = true);
    // Simulate payment confirmation delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.go('/booking/flow/confirmation/mock');
    }
  }

  String get _countdownText {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(bookingFlowProvider);
    final venueId = flow.venue?.id ?? '';
    final paymentMethods = MockVenues.paymentMethods[venueId] ?? [];
    final paymentMethod = flow.paymentMethod;

    return DefaultTabController(
      length: 2,
      initialIndex: paymentMethod == PaymentMethodType.bankTransfer ? 1 : 0,
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
              padding: const EdgeInsets.all(AppDimensions.base),
              color: AppColors.warningLight,
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
                    Formatters.formatRupiah(flow.totalAmount),
                    style: AppTypography.priceLarge,
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
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd),
                          ),
                          child: const Icon(
                            Icons.qr_code_2,
                            size: 120,
                          ),
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
                    padding: const EdgeInsets.all(
                        AppDimensions.screenHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.xl),
                        ...paymentMethods
                            .where(
                                (pm) => pm.type == PaymentMethodType.bankTransfer)
                            .map((pm) => Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pm.bankName ?? 'Bank',
                                      style: AppTypography.titleMedium,
                                    ),
                                    const SizedBox(height: AppDimensions.md),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            pm.accountNumber ?? '',
                                            style:
                                                AppTypography.numberMedium,
                                          ),
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.copy, size: 20),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                              text: pm.accountNumber ?? '',
                                            ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Nomor rekening disalin'),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppDimensions.xs),
                                    Text(
                                      'a.n. ${pm.accountHolderName ?? ''}',
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: SizedBox(
                width: double.infinity,
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
