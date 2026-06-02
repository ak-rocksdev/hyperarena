import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/payment/presentation/widgets/booking_summary_card.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class PaymentSuccessScreen extends ConsumerStatefulWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.purchaseId,
    required this.status,
    this.sessionId,
    this.sessionLabel,
    this.sessionStartAt,
    this.venueName,
    this.amount,
    this.paymentMethodLabel,
  });

  final int purchaseId;
  final String status; // 'confirmed' | 'awaiting_review' | 'expired'
  final int? sessionId;
  final String? sessionLabel;
  final DateTime? sessionStartAt;
  final String? venueName;
  final int? amount;
  final String? paymentMethodLabel;

  @override
  ConsumerState<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    if (widget.status == 'confirmed' || widget.status == 'awaiting_review') {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onFinish() async {
    // Only 'confirmed' has special routing — the user is enrolled, so bounce
    // back to the session detail with a success marker. All other terminal
    // statuses ('awaiting_review', 'expired', unknown) go home.
    if (widget.status == 'confirmed' && widget.sessionId != null) {
      // Invalidate cache so session detail fetches fresh participant list
      ref.invalidate(
        marketplaceSessionDetailProvider(widget.sessionId.toString()),
      );
      if (!mounted) return;
      context.go(
        '${AppRoutes.marketplaceSession(widget.sessionId.toString())}?joined=1',
      );
      return;
    }

    context.go(AppRoutes.home(UserRole.player));
  }

  /// "Pesan Ulang" — go back to session detail so user can re-checkout.
  /// Invalidates the session cache first so fresh participant/status data
  /// loads before the user lands on the detail page.
  void _onReorder() {
    if (widget.sessionId != null) {
      ref.invalidate(
        marketplaceSessionDetailProvider(widget.sessionId.toString()),
      );
      context.go(AppRoutes.marketplaceSession(widget.sessionId.toString()));
    } else {
      context.go(AppRoutes.home(UserRole.player));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, subtitle) = switch (widget.status) {
      'confirmed' => (
        Icons.check_circle,
        Colors.green.shade600,
        'Pembayaran Berhasil',
        'Sesi Anda sudah terkonfirmasi. Sampai jumpa di lapangan!',
      ),
      'awaiting_review' => (
        Icons.access_time_filled,
        Colors.amber.shade700,
        'Menunggu Verifikasi',
        'Bukti transfer terkirim. Admin akan memverifikasi dalam 1×24 jam.',
      ),
      'expired' => (
        Icons.cancel,
        Colors.red.shade600,
        'Pembayaran Kedaluwarsa',
        'Waktu pembayaran sudah habis. Slot di sesi sudah dilepas, silakan pesan kembali jika masih ingin gabung.',
      ),
      _ => (
        Icons.info,
        Colors.grey,
        'Status Tidak Diketahui',
        'Hubungi admin klub jika ada masalah.',
      ),
    };

    final userName = ref.watch(authNotifierProvider)?.name ?? 'Anda';

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ScaleTransition(
                  scale: _scale,
                  child: Icon(icon, size: 80, color: color),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(subtitle, textAlign: TextAlign.center),
              if (_canShowSummary) ...[
                const SizedBox(height: 24),
                BookingSummaryCard(
                  sessionLabel: widget.sessionLabel!,
                  sessionStartAt: widget.sessionStartAt,
                  venueName: widget.venueName,
                  userName: userName,
                  amount: widget.amount!,
                  paymentMethodLabel: widget.paymentMethodLabel!,
                  paidAt: DateTime.now(),
                  status: widget.status,
                ),
              ],
              const SizedBox(height: 24),
              // Expired variant: dual-button terminal state
              if (widget.status == 'expired') ...[
                FilledButton.icon(
                  onPressed: _onReorder,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Pesan Ulang'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      context.go(AppRoutes.home(UserRole.player)),
                  child: const Text('Kembali ke Beranda'),
                ),
              ] else
                ElevatedButton(
                  onPressed: _onFinish,
                  style: _primaryStyle(),
                  child: const Text('Selesai'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canShowSummary =>
      widget.sessionLabel != null &&
      widget.amount != null &&
      widget.paymentMethodLabel != null;

  ButtonStyle _primaryStyle() => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      );
}
