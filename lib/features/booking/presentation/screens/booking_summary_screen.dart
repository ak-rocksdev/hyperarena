import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() =>
      _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  PaymentMethodType _paymentMethod = PaymentMethodType.qris;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      ref
          .read(bookingFlowProvider.notifier)
          .selectPaymentMethod(_paymentMethod);
      await ref.read(bookingFlowProvider.notifier).submit();
      if (mounted) {
        context.push('/booking/flow/payment');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat booking: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(bookingFlowProvider);
    final slots = [...flow.slots]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Booking')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue + court
                  Text('Detail Booking', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.md),

                  _InfoRow('Venue', flow.venue?.name ?? '-'),
                  _InfoRow('Lapangan', flow.court?.name ?? '-'),
                  _InfoRow(
                    'Tanggal',
                    flow.date != null
                        ? Formatters.formatDate(flow.date!)
                        : '-',
                  ),
                  if (slots.isNotEmpty)
                    _InfoRow(
                      'Waktu',
                      '${slots.first.startTime} - ${slots.last.endTime}',
                    ),
                  _InfoRow(
                    'Durasi',
                    Formatters.formatDuration(slots.length),
                  ),

                  const Divider(height: AppDimensions.xl),

                  // Price breakdown
                  Text('Rincian Biaya', style: AppTypography.titleMedium),
                  const SizedBox(height: AppDimensions.md),
                  ...slots.map((slot) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimensions.xs),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${slot.startTime} - ${slot.endTime}${slot.isPeak ? ' (Peak)' : ''}',
                              style: AppTypography.bodySmall,
                            ),
                            Text(
                              Formatters.formatRupiah(slot.price),
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: AppDimensions.base),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTypography.titleMedium),
                      Text(
                        Formatters.formatRupiah(flow.totalAmount),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // Payment method selection
                  Text(
                    'Metode Pembayaran',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  RadioGroup<PaymentMethodType>(
                    groupValue: _paymentMethod,
                    onChanged: (v) {
                      if (v != null) setState(() => _paymentMethod = v);
                    },
                    child: Column(
                      children: [
                        RadioListTile<PaymentMethodType>(
                          title: const Text('QRIS'),
                          subtitle: const Text('Scan QR code'),
                          value: PaymentMethodType.qris,
                        ),
                        RadioListTile<PaymentMethodType>(
                          title: const Text('Transfer Bank'),
                          subtitle: const Text('BCA'),
                          value: PaymentMethodType.bankTransfer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Lanjutkan ke Pembayaran',
                isLarge: true,
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
