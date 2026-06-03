import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/models/purchase_status.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/widgets/cost_breakdown_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/countdown_timer.dart';
import 'package:hyperarena/features/payment/presentation/widgets/refund_policy_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/va_account_display.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class VaWaitingScreen extends ConsumerStatefulWidget {
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
  ConsumerState<VaWaitingScreen> createState() => _VaWaitingScreenState();
}

class _VaWaitingScreenState extends ConsumerState<VaWaitingScreen> {
  bool _localExpired = false;

  @override
  void initState() {
    super.initState();
    // If already expired at mount time, navigate immediately after first frame
    final alreadyExpired = widget.intent.expiresAt != null &&
        widget.intent.expiresAt!.isBefore(DateTime.now());
    if (alreadyExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _localExpired = true;
          _navigateToExpiredSuccess();
        }
      });
    }
  }

  void _navigateToExpiredSuccess() {
    if (!mounted) return;
    if (widget.sessionId != null) {
      ref.invalidate(
        marketplaceSessionDetailProvider(widget.sessionId.toString()),
      );
    }
    context.go(
      '/payment/success/${widget.purchaseId}?status=expired',
      extra: {
        'sessionId': widget.sessionId,
        'sessionLabel': widget.sessionLabel,
        'sessionStartAt': widget.sessionStartAt,
        'venueName': widget.venueName,
        'amount': widget.amount,
        'paymentMethodLabel': widget.paymentMethodLabel,
      },
    );
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Pesanan akan dibatalkan dan slot di sesi akan dilepas. Anda dapat memesan kembali nanti selama sesi masih tersedia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(paymentRepositoryProvider).cancelPurchase(widget.purchaseId);
      if (!mounted) return;
      if (widget.sessionId != null) {
        ref.invalidate(marketplaceSessionDetailProvider(widget.sessionId.toString()));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan dibatalkan.'),
          backgroundColor: Colors.grey,
        ),
      );
      context.go(AppRoutes.home(UserRole.player));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membatalkan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(purchaseStatusStreamProvider(widget.purchaseId));

    // Auto-navigate when server confirms terminal status
    ref.listen<AsyncValue<PurchaseStatus>>(
      purchaseStatusStreamProvider(widget.purchaseId),
      (prev, next) {
        next.whenData((status) {
          if (status.status != 'confirmed' && status.status != 'expired') return;
          if (status.status == 'expired') {
            _navigateToExpiredSuccess();
          } else {
            context.go(
              '/payment/success/${widget.purchaseId}?status=${status.status}',
              extra: {
                'sessionId': widget.sessionId,
                'sessionLabel': widget.sessionLabel,
                'sessionStartAt': widget.sessionStartAt,
                'venueName': widget.venueName,
                'amount': widget.amount,
                'paymentMethodLabel': widget.paymentMethodLabel,
              },
            );
          }
        });
      },
    );

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
              bank: widget.intent.vaBank ?? '',
              accountNumber: widget.intent.vaNumber ?? '',
              amount: widget.amount,
            ),
            const SizedBox(height: 16),
            CostBreakdownCard(
              itemLabel: widget.sessionLabel ?? 'Pembayaran Sesi',
              basePrice: widget.intent.amountBase,
              adminFee: widget.intent.feeAmount,
            ),
            const SizedBox(height: 12),
            const RefundPolicyCard(),
            const SizedBox(height: 16),
            if (widget.intent.expiresAt != null)
              Center(
                child: CountdownTimer(
                  expiresAt: widget.intent.expiresAt!,
                  onExpired: () {
                    if (!_localExpired) {
                      setState(() => _localExpired = true);
                      _navigateToExpiredSuccess();
                    }
                  },
                ),
              ),
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
            // Hide stale action buttons once locally expired
            if (!_localExpired) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _confirmCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Batalkan Pesanan'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go(AppRoutes.home(UserRole.player)),
                child: const Text('Bayar Nanti'),
              ),
            ],
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
