import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/widgets/cost_breakdown_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/countdown_timer.dart';
import 'package:hyperarena/features/payment/presentation/widgets/refund_policy_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/va_account_display.dart';
import 'package:hyperarena/routing/app_routes.dart';

class VaWaitingScreen extends ConsumerWidget {
  const VaWaitingScreen({
    super.key,
    required this.purchaseId,
    required this.amount,
    required this.intent,
    this.sessionId,
    this.sessionLabel,
    this.sessionStartAt,
    this.venueName,
    this.paymentMethodLabel,
  });

  final int purchaseId;
  final int amount;
  final PaymentIntent intent;
  final int? sessionId;
  final String? sessionLabel;
  final DateTime? sessionStartAt;
  final String? venueName;
  final String? paymentMethodLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(purchaseStatusStreamProvider(purchaseId));

    // Auto-navigate when status becomes terminal
    ref.listen<AsyncValue<dynamic>>(purchaseStatusStreamProvider(purchaseId), (prev, next) {
      next.whenData((status) {
        if (status.status != 'confirmed' && status.status != 'expired') return;
        context.go(
          '/payment/success/$purchaseId?status=${status.status}',
          extra: {
            'sessionId': sessionId,
            'sessionLabel': sessionLabel,
            'sessionStartAt': sessionStartAt,
            'venueName': venueName,
            'amount': amount,
            'paymentMethodLabel': paymentMethodLabel,
          },
        );
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menunggu Pembayaran'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VaAccountDisplay(
              bank: intent.vaBank ?? '',
              accountNumber: intent.vaNumber ?? '',
              amount: amount,
            ),
            const SizedBox(height: 16),
            CostBreakdownCard(
              itemLabel: sessionLabel ?? 'Pembayaran Sesi',
              basePrice: intent.amountBase,
              adminFee: intent.feeAmount,
            ),
            const SizedBox(height: 12),
            const RefundPolicyCard(),
            const SizedBox(height: 16),
            if (intent.expiresAt != null)
              Center(child: CountdownTimer(expiresAt: intent.expiresAt!)),
            const SizedBox(height: 24),
            const _InstructionsBlock(),
            const SizedBox(height: 24),
            statusAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                'Cek status: $e',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              data: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Menunggu pembayaran… terkonfirmasi otomatis'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.home(UserRole.player)),
              child: const Text('Bayar Nanti'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionsBlock extends StatelessWidget {
  const _InstructionsBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cara Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('1. Buka aplikasi mobile banking atau ATM bank Anda'),
          Text('2. Pilih menu Virtual Account / Transfer VA'),
          Text('3. Masukkan nomor VA di atas'),
          Text('4. Konfirmasi jumlah pembayaran'),
          Text('5. Selesaikan transaksi — pembayaran akan terkonfirmasi otomatis'),
        ],
      ),
    );
  }
}
