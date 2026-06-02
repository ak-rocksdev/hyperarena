import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class PurchaseDetailScreen extends ConsumerWidget {
  const PurchaseDetailScreen({super.key, required this.purchaseId});

  final int purchaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseDetailProvider(purchaseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (data) {
          final p = data.purchase;
          final eligibility = data.rebookEligibility;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Reference + status header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      p.reference,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusLabel(p.status),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _statusColor(p.status),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Session card
              if (p.session != null)
                _sectionCard(
                  'Sesi',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.session!.displayTitle ?? 'Sesi',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (p.session!.startAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          Formatters.tryFormatId(
                            'EEE, d MMM y • HH:mm',
                            p.session!.startAt!,
                          ),
                        ),
                      ],
                      if (p.session!.venue != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          p.session!.venue!.name,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Cost breakdown
              _sectionCard(
                'Rincian Pembayaran',
                Column(
                  children: [
                    _row(
                      'Sesi',
                      Formatters.formatCurrency(p.amountPaid, p.currency),
                    ),
                    const SizedBox(height: 4),
                    _row(
                      'Biaya admin',
                      p.feeAmount == 0
                          ? 'Gratis'
                          : Formatters.formatCurrency(
                              p.feeAmount,
                              p.currency,
                            ),
                    ),
                    const Divider(height: 16),
                    _row(
                      'Total',
                      Formatters.formatCurrency(p.amountTotal, p.currency),
                      bold: true,
                    ),
                    const SizedBox(height: 8),
                    _row(
                      'Metode',
                      p.paymentProvider == 'automatic'
                          ? 'Virtual Account ${(p.vaBank ?? '').toUpperCase()}'
                          : 'Transfer Manual',
                    ),
                    if (p.confirmedAt != null) ...[
                      const SizedBox(height: 4),
                      _row(
                        'Dibayar',
                        Formatters.tryFormatId('d MMM y, HH:mm', p.confirmedAt!),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Re-book CTA
              if (eligibility.eligible) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(
                        AppRoutes.marketplaceSession(
                          eligibility.sessionId.toString(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Pesan Ulang'),
                  ),
                ),
              ] else if (eligibility.reason != null &&
                  _shouldShowReason(p.status)) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _reasonLabel(eligibility.reason!),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  bool _shouldShowReason(String status) =>
      ['expired', 'cancelled', 'rejected'].contains(status);

  String _reasonLabel(String reason) => switch (reason) {
    'session_removed' => 'Sesi sudah tidak tersedia.',
    'session_past' => 'Sesi sudah lewat — tidak bisa dipesan ulang.',
    'session_full' => 'Sesi sudah penuh.',
    'completed' => 'Pesanan sudah berhasil — tidak perlu dipesan ulang.',
    _ => 'Pesan ulang tidak tersedia: $reason',
  };

  String _statusLabel(String s) => switch (s) {
    'pending_payment' => 'Menunggu Pembayaran',
    'confirmed' => 'Berhasil',
    'cancelled' => 'Dibatalkan',
    'expired' => 'Kedaluwarsa',
    'rejected' => 'Ditolak',
    _ => s,
  };

  Color _statusColor(String s) => switch (s) {
    'pending_payment' => Colors.amber.shade700,
    'confirmed' => Colors.green.shade700,
    'cancelled' => Colors.grey.shade700,
    'expired' => Colors.red.shade600,
    'rejected' => Colors.red.shade800,
    _ => Colors.grey,
  };

  Widget _sectionCard(String title, Widget body) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          body,
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

}
