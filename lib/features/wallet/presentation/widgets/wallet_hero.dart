import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

/// The wallet's emotional anchor: a teal gradient hero with the period's
/// total earnings as a display-sized number. Layout uses `splitCurrency` so
/// "Rp" sits small above the figure — keeps the hero readable at glance.
///
/// Decorative circles at top-right add gentle depth without competing with
/// the number. Loading + error states inline so the hero card doesn't blank
/// out and reflow the screen.
class WalletHero extends ConsumerWidget {
  const WalletHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(walletPeriodProvider);
    final summaryAsync = ref.watch(walletSummaryProvider(period));
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppSurfaces.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
          boxShadow: AppShadows.colored,
        ),
        child: Stack(
          children: [
            // Decorative circles — abstract "savings/coin" hint without literal iconography.
            Positioned(
              top: -32,
              right: -32,
              child: _decorativeCircle(120, alpha: 0.08),
            ),
            Positioned(
              top: 24,
              right: 56,
              child: _decorativeCircle(40, alpha: 0.06),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.xl,
                AppDimensions.xl,
                AppDimensions.xl,
                AppDimensions.xl,
              ),
              child: summaryAsync.when(
                data: (summary) => _HeroContent(
                  summary: summary,
                  currency: currency,
                ),
                loading: () => const _HeroSkeleton(),
                error: (_, _) => _HeroError(
                  onRetry: () =>
                      ref.invalidate(walletSummaryProvider(period)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _decorativeCircle(double size, {required double alpha}) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      );
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.summary, required this.currency});
  final dynamic summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final split = Formatters.splitCurrency(
      summary.totalEarnedCents as int,
      currency,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overline label
        Row(
          children: [
            const Icon(
              Icons.account_balance_wallet_rounded,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: AppDimensions.xs),
            Text(
              'TOTAL PENGHASILAN',
              style: AppTypography.overline.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
        // Money: small "Rp" prefix + display-size number.
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                split.prefix,
                style: AppTypography.titleLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomLeft,
                child: Text(
                  split.number,
                  style: AppTypography.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        // Sub-stats: sessions and students inline pills.
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.xs,
          children: [
            _SubPill(
              icon: Icons.event_rounded,
              label: '${summary.sessionCount} sesi',
            ),
            if ((summary.studentCount as int) > 0)
              _SubPill(
                icon: Icons.group_rounded,
                label: '${summary.studentCount} murid',
              ),
          ],
        ),
      ],
    );
  }
}

class _SubPill extends StatelessWidget {
  const _SubPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar(double w, double h, {double opacity = 0.18}) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(120, 10),
        const SizedBox(height: AppDimensions.lg),
        bar(220, 36),
        const SizedBox(height: AppDimensions.md),
        Row(children: [bar(64, 24), const SizedBox(width: 8), bar(72, 24)]),
      ],
    );
  }
}

class _HeroError extends StatelessWidget {
  const _HeroError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.cloud_off_rounded,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gagal memuat penghasilan',
                style: AppTypography.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Periksa koneksi dan coba lagi.',
                style: AppTypography.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.16),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          child: const Text('Ulangi'),
        ),
      ],
    );
  }
}
