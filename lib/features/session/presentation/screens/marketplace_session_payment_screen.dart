import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';

import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/data/models/session_join_response.dart';
import 'package:hyperarena/features/session/data/models/tenant_payment_info.dart';
import 'package:hyperarena/features/session/providers/marketplace_session_join_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class MarketplaceSessionPaymentScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final Map<String, dynamic>? extra;

  const MarketplaceSessionPaymentScreen({
    super.key,
    required this.sessionId,
    this.extra,
  });

  @override
  ConsumerState<MarketplaceSessionPaymentScreen> createState() =>
      _MarketplaceSessionPaymentScreenState();
}

class _MarketplaceSessionPaymentScreenState
    extends ConsumerState<MarketplaceSessionPaymentScreen> {

  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isUploading = false;
  String? _selectedFilePath;

  SessionJoinResponse? _joinResponse;
  TenantPaymentInfo? _tenantPayment;
  String _sessionName = '';
  int _price = 0;

  @override
  void initState() {
    super.initState();
    _parseExtra();
    _startCountdown();
  }

  void _parseExtra() {
    final extra = widget.extra;
    if (extra == null) return;

    _joinResponse = extra['joinResponse'] as SessionJoinResponse?;
    _tenantPayment = extra['tenantPayment'] as TenantPaymentInfo?;
    _sessionName = extra['sessionName'] as String? ?? '';
    _price = extra['price'] as int? ?? 0;
  }

  void _startCountdown() {
    final expiresAt = _joinResponse?.expiresAt;
    if (expiresAt == null) return;

    _remaining = expiresAt.difference(DateTime.now());
    if (_remaining.isNegative) {
      _remaining = Duration.zero;
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = expiresAt.difference(now);
      if (diff.isNegative || diff == Duration.zero) {
        setState(() => _remaining = Duration.zero);
        _timer?.cancel();
      } else {
        setState(() => _remaining = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _countdownText {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _pickAndUploadProof() async {
    AppHaptics.tap();
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );
    if (image == null || !mounted) return;

    setState(() {
      _selectedFilePath = image.path;
      _isUploading = true;
    });

    final purchaseId = _joinResponse?.purchaseId;
    if (purchaseId == null) {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pembelian tidak ditemukan')),
        );
      }
      return;
    }

    final success = await ref
        .read(marketplaceSessionJoinProvider.notifier)
        .uploadProof(purchaseId, image.path);

    if (!mounted) return;
    setState(() => _isUploading = false);

    if (success) {
      context.go(
        AppRoutes.marketplaceSessionConfirmation(widget.sessionId),
        extra: {'isWaiting': true},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah bukti pembayaran')),
      );
    }
  }

  void _copyAccountNumber(String accountNumber) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nomor rekening disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.extra == null || _tenantPayment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pembayaran')),
        body: const Center(child: Text('Data pembayaran tidak tersedia')),
      );
    }

    final payment = _tenantPayment!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRoutes.marketplaceSession(widget.sessionId)),
        ),
      ),
      body: Column(
        children: [
          // ── Countdown + amount header ────────────────────────
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
                Text(_sessionName, style: AppTypography.bodyMedium),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  Formatters.formatCurrency(
                      _price, ref.watch(tenantCurrencyProvider)),
                  style: AppTypography.priceLarge,
                ),
              ],
            ),
          ),

          // ── Bank transfer details ────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.base),
                  Text('Transfer Bank', style: AppTypography.headingSmall),
                  const SizedBox(height: AppDimensions.base),

                  // Bank info card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.base),
                    decoration: BoxDecoration(
                      color: AppSurfaces.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      boxShadow: AppShadows.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.bankName,
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                payment.accountNumber,
                                style: AppTypography.numberMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () =>
                                  _copyAccountNumber(payment.accountNumber),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'a.n. ${payment.accountHolder}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Payment instructions
                  if (payment.paymentInstructions != null &&
                      payment.paymentInstructions!.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.xl),
                    Text(
                      'Instruksi Pembayaran',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.base),
                      decoration: BoxDecoration(
                        color: AppColors.neutral50,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      child: Text(
                        payment.paymentInstructions!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],

                  // Selected file indicator
                  if (_selectedFilePath != null) ...[
                    const SizedBox(height: AppDimensions.base),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.md),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          Expanded(
                            child: Text(
                              'Bukti pembayaran dipilih',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.successDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppDimensions.xl),
                ],
              ),
            ),
          ),

          // ── Upload button ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_remaining == Duration.zero)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: Text(
                      'Waktu pembayaran habis. Silakan coba bergabung lagi.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    boxShadow: _remaining == Duration.zero ? null : AppShadows.colored,
                  ),
                  child: AppButton(
                    label: _remaining == Duration.zero
                        ? 'Kembali'
                        : 'Upload Bukti Pembayaran',
                    icon: _remaining == Duration.zero ? Icons.arrow_back : Icons.upload_file,
                    isLarge: true,
                    isLoading: _isUploading,
                    onPressed: _remaining == Duration.zero
                        ? () => context.go(AppRoutes.marketplaceSession(widget.sessionId))
                        : _pickAndUploadProof,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
