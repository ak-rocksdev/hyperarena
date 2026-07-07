import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/models/purchase_status.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/widgets/cost_breakdown_card.dart';
import 'package:hyperarena/features/payment/presentation/widgets/countdown_timer.dart';
import 'package:hyperarena/features/payment/presentation/widgets/refund_policy_card.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class QrisWaitingScreen extends ConsumerStatefulWidget {
  const QrisWaitingScreen({
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
  ConsumerState<QrisWaitingScreen> createState() => _QrisWaitingScreenState();
}

class _QrisWaitingScreenState extends ConsumerState<QrisWaitingScreen> {
  bool _localExpired = false;

  Map<String, dynamic> get _navExtra => {
        'sessionId': widget.sessionId,
        'sessionLabel': widget.sessionLabel,
        'sessionStartAt': widget.sessionStartAt,
        'venueName': widget.venueName,
        'amount': widget.amount,
        'paymentMethodLabel': widget.paymentMethodLabel,
      };

  void _navigateToExpiredSuccess() {
    if (!mounted) return;
    if (widget.sessionId != null) {
      ref.invalidate(marketplaceSessionDetailProvider(widget.sessionId.toString()));
    }
    context.go('/payment/success/${widget.purchaseId}?status=expired', extra: _navExtra);
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final statusAsync = ref.watch(purchaseStatusStreamProvider(widget.purchaseId));

    ref.listen<AsyncValue<PurchaseStatus>>(
      purchaseStatusStreamProvider(widget.purchaseId),
      (prev, next) {
        next.whenData((status) {
          if (status.status != 'confirmed' && status.status != 'expired') return;
          if (status.status == 'expired') {
            _navigateToExpiredSuccess();
          } else {
            context.go('/payment/success/${widget.purchaseId}?status=${status.status}', extra: _navExtra);
          }
        });
      },
    );

    final qr = widget.intent.qrString;

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
            if (qr == null || qr.isEmpty)
              _MissingQrCard(onHome: () => context.go(AppRoutes.home(UserRole.player)))
            else
              _QrCard(qrString: qr, amount: widget.amount),
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
            const _QrisInstructionsBlock(),
            const SizedBox(height: 24),
            statusAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Cek status: $e',
                  style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              data: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _PulseDot(),
                  SizedBox(width: 8),
                  Text('Menunggu pembayaran… terkonfirmasi otomatis'),
                ],
              ),
            ),
            if (!_localExpired) ...[
              const SizedBox(height: 24),
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

class _QrCard extends StatelessWidget {
  const _QrCard({required this.qrString, required this.amount});
  final String qrString;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Text('QRIS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          QrImageView(data: qrString, version: QrVersions.auto, size: 240),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(amount, 'IDR'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          const Text(
            'Scan QR dengan aplikasi e-wallet atau mobile banking',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MissingQrCard extends StatelessWidget {
  const _MissingQrCard({required this.onHome});
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text('QR tidak tersedia. Coba buat pembayaran lagi.',
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onHome, child: const Text('Kembali')),
        ],
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();
  @override
  Widget build(BuildContext context) => Container(
        width: 10, height: 10,
        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      );
}

class _QrisInstructionsBlock extends StatelessWidget {
  const _QrisInstructionsBlock();
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
          Text('Cara Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('1. Buka aplikasi e-wallet atau mobile banking Anda'),
          Text('2. Pilih menu Scan / QRIS / Bayar'),
          Text('3. Scan QR di atas'),
          Text('4. Konfirmasi jumlah pembayaran'),
          Text('5. Selesaikan transaksi — pembayaran akan terkonfirmasi otomatis'),
        ],
      ),
    );
  }
}
