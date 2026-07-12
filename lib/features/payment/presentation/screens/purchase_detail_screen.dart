import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/data/models/purchase_full_detail.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/purchase_status_ui.dart';
import 'package:hyperarena/routing/app_routes.dart';

class PurchaseDetailScreen extends ConsumerWidget {
  const PurchaseDetailScreen({super.key, required this.purchaseId});

  final int purchaseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(purchaseDetailProvider(purchaseId));

    // While awaiting payment or admin review, poll the raw status so the
    // page reacts immediately when the admin approves (no manual refresh).
    // The stream self-terminates on terminal statuses.
    final awaiting = detailAsync.valueOrNull?.purchase.status;
    if (awaiting == 'pending_payment' || awaiting == 'pending_confirmation') {
      ref.listen(purchaseStatusStreamProvider(purchaseId), (previous, next) {
        final live = next.valueOrNull?.status;
        if (kTerminalPurchaseStatuses.contains(live)) {
          ref.invalidate(purchaseDetailProvider(purchaseId));
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (data) {
          final p = data.purchase;
          final eligibility = data.rebookEligibility;
          final (statusLabel, statusColor) = purchaseStatusUi(p.status);
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
                      statusLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: statusColor,
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

              // Proof uploaded — awaiting admin review. No further payment
              // action is possible; explain that clearly instead.
              if (p.status == 'pending_confirmation') ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.hourglass_top,
                        size: 18,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bukti transfer terkirim. Admin akan memverifikasi '
                          'dalam 1×24 jam — tidak perlu melakukan pembayaran '
                          'lagi.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warningDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Resume payment CTA — only when pending, resume data available,
              // and the session hasn't started (same rule as the session
              // detail bottom bar: started/ended sessions are read-only).
              if (p.status == 'pending_payment' &&
                  p.resume != null &&
                  !_sessionStarted(p.session)) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToResumePayment(
                      context,
                      p.resume!,
                      p.id,
                      p.session?.displayTitle ?? p.productLabel ?? 'Sesi',
                      p.session,
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text('Lanjutkan Pembayaran'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

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

  void _navigateToResumePayment(
    BuildContext context,
    PurchaseResume resume,
    int purchaseId,
    String sessionLabel,
    DetailSession? session,
  ) {
    final target = paymentTargetPath(
      provider: resume.provider,
      method: resume.method,
      id: purchaseId,
    );
    final sharedExtra = <String, dynamic>{
      'amount': resume.amountTotal,
      'sessionId': session?.id,
      'sessionLabel': sessionLabel,
      'sessionStartAt': session?.startAt,
      'venueName': session?.venue?.name,
    };

    if (resume.provider == 'automatic') {
      final intent = PaymentIntent(
        purchaseId: purchaseId,
        status: 'pending_payment',
        provider: resume.provider,
        paymentMethod: resume.method,
        amountBase: resume.amountBase,
        feeAmount: resume.feeAmount,
        amountTotal: resume.amountTotal,
        vaNumber: resume.vaNumber,
        vaBank: resume.vaBank,
        qrString: resume.qrString,
        expiresAt: resume.expiresAt,
        bankDetails: resume.bankDetails,
        proofUploadUrl: resume.proofUploadUrl,
      );
      context.push(target, extra: {
        ...sharedExtra,
        'intent': intent,
        'paymentMethodLabel':
            paymentMethodLabel(method: resume.method, vaBank: resume.vaBank),
      });
    } else {
      final bankDetails = resume.bankDetails;
      if (bankDetails == null) return; // guard: manual flow needs bank details
      context.push(target, extra: {
        ...sharedExtra,
        'bankDetails': bankDetails,
        'paymentMethodLabel': 'Transfer Manual',
      });
    }
  }

  /// Started/ended sessions are read-only — no payment CTA (matches the
  /// session-detail bottom bar rule).
  bool _sessionStarted(DetailSession? session) =>
      session?.startAt != null && !DateTime.now().isBefore(session!.startAt!);

  bool _shouldShowReason(String status) =>
      ['expired', 'cancelled', 'rejected'].contains(status);

  String _reasonLabel(String reason) => switch (reason) {
    'session_removed' => 'Sesi sudah tidak tersedia.',
    'session_past' => 'Sesi sudah lewat — tidak bisa dipesan ulang.',
    'session_full' => 'Sesi sudah penuh.',
    'completed' => 'Pesanan sudah berhasil — tidak perlu dipesan ulang.',
    _ => 'Pesan ulang tidak tersedia: $reason',
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
