import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/utils/formatters.dart';

import 'package:hyperarena/core/theme/app_animations.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';

class MarketplaceSessionConfirmationScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final Map<String, dynamic>? extra;

  const MarketplaceSessionConfirmationScreen({
    super.key,
    required this.sessionId,
    this.extra,
  });

  @override
  ConsumerState<MarketplaceSessionConfirmationScreen> createState() =>
      _MarketplaceSessionConfirmationScreenState();
}

class _MarketplaceSessionConfirmationScreenState
    extends ConsumerState<MarketplaceSessionConfirmationScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isWaiting => widget.extra?['isWaiting'] == true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.slow,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.elastic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: _isWaiting ? _buildWaitingState() : _buildCreditState(),
        ),
      ),
    );
  }

  // ── State A: Credit confirmation ──────────────────────────────
  Widget _buildCreditState() {
    final extra = widget.extra;
    final sessionName = extra?['sessionName'] as String? ?? '';
    final price = extra?['price'] as int? ?? 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        // Animated success icon
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              shape: BoxShape.circle,
              boxShadow: AppShadows.md,
            ),
            child: const Icon(
              Icons.check,
              size: 48,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),

        Text(
          'Berhasil Bergabung!',
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.sm),

        Text(
          '1 kredit telah digunakan.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.xl),

        // Session summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            children: [
              Text(
                sessionName,
                style: AppTypography.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                Formatters.formatCurrency(
                    price, ref.read(tenantCurrencyProvider)),
                style: AppTypography.priceLarge,
              ),
            ],
          ),
        ),

        const Spacer(),

        // "Kembali ke Explore" button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            boxShadow: AppShadows.colored,
          ),
          child: AppButton(
            label: 'Kembali ke Explore',
            isLarge: true,
            onPressed: () => context.go('/player/explore'),
          ),
        ),
        const SizedBox(height: AppDimensions.md),

        // "Kembali ke Beranda" button
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Kembali ke Beranda',
            variant: AppButtonVariant.outlined,
            isLarge: true,
            onPressed: () => context.go('/player/home'),
          ),
        ),
      ],
    );
  }

  // ── State B: Payment waiting ──────────────────────────────────
  Widget _buildWaitingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        // Animated icon
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              shape: BoxShape.circle,
              boxShadow: AppShadows.md,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 48,
              color: AppColors.info,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.xl),

        Text(
          'Bukti Pembayaran Terkirim',
          style: AppTypography.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.sm),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.xl,
          ),
          child: Text(
            'Menunggu konfirmasi dari penyelenggara. '
            'Kami akan memberitahu kamu setelah pembayaran dikonfirmasi.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(),

        // "Kembali ke Explore" button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            boxShadow: AppShadows.colored,
          ),
          child: AppButton(
            label: 'Kembali ke Explore',
            isLarge: true,
            onPressed: () => context.go('/player/explore'),
          ),
        ),
      ],
    );
  }
}
