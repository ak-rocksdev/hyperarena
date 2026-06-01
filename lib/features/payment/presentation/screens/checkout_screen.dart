import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/payment_method.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/widgets/payment_method_card.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.tenantSlug,
    required this.productId,
    required this.sessionId,
    required this.productLabel,
    required this.amount,
    this.sessionStartAt,
    this.venueName,
  });

  final String tenantSlug;
  final int productId;
  final int sessionId;
  final String productLabel;
  final int amount;
  final DateTime? sessionStartAt;
  final String? venueName;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethod? _selected;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(
      availablePaymentMethodsProvider(widget.tenantSlug),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: methodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Gagal memuat metode pembayaran: $e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (methods) {
          if (methods.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada metode pembayaran tersedia.\nHubungi admin klub.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OrderSummaryCard(
                  label: widget.productLabel,
                  amount: widget.amount,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pilih metode pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...methods.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PaymentMethodCard(
                      method: m,
                      selected: _selected?.key == m.key,
                      onTap: () => setState(() => _selected = m),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: methodsAsync.maybeWhen(
        data: (_) => SafeArea(
          minimum: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _canSubmit() && !_submitting ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(_submitting ? 'Memproses...' : 'Lanjut Bayar'),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  bool _canSubmit() => _selected != null;

  Future<void> _submit() async {
    if (_selected == null) return;
    setState(() => _submitting = true);

    try {
      final intent = await ref.read(paymentRepositoryProvider).createPurchase(
        productId: widget.productId,
        sessionId: widget.sessionId,
        paymentMethod: _selected!.key,
      );

      if (!mounted) return;

      // Route based on provider
      final paymentMethodLabel = _selected!.label;
      if (intent.provider == 'manual') {
        context.go('/payment/manual/${intent.purchaseId}', extra: {
          'amount': intent.amountTotal,
          'bankDetails': intent.bankDetails,
          'proofUploadUrl': intent.proofUploadUrl,
          'sessionId': widget.sessionId,
          'sessionLabel': widget.productLabel,
          'sessionStartAt': widget.sessionStartAt,
          'venueName': widget.venueName,
          'paymentMethodLabel': paymentMethodLabel,
        });
      } else {
        context.go('/payment/va/${intent.purchaseId}', extra: {
          'amount': intent.amountTotal,
          'intent': intent,
          'sessionId': widget.sessionId,
          'sessionLabel': widget.productLabel,
          'sessionStartAt': widget.sessionStartAt,
          'venueName': widget.venueName,
          'paymentMethodLabel': paymentMethodLabel,
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses pembayaran: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.label, required this.amount});
  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          const SizedBox(width: 12),
          Text(
            Formatters.formatCurrency(amount, 'IDR'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
