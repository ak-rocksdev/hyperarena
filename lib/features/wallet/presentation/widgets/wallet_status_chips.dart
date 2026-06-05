import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_summary.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

/// Three-chip row that breaks total earnings into "Belum / Diproses / Sudah".
/// Per spec §5.4 the invariant is:
///   `totalEarnedCents == pendingCents + diprosesCents + paidCents`
/// where `diprosesCents = requestedCents + approvedCents` (BE keeps the 4
/// buckets for Vue admin — merge happens here on the FE).
class WalletStatusChips extends ConsumerWidget {
  const WalletStatusChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(walletPeriodProvider);
    final summaryAsync = ref.watch(walletSummaryProvider(period));
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: summaryAsync.when(
        data: (summary) => _row(summary, currency),
        loading: () => _skeletonRow(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _row(CoachPayoutSummary summary, String currency) {
    if (summary.totalEarnedCents == 0) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Expanded(
          child: _Chip(
            label: 'Belum dicairkan',
            amount: summary.pendingCents,
            currency: currency,
            dotColor: AppColors.warning,
            isLeading: true,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Chip(
            label: 'Diproses',
            amount: summary.diprosesCents,
            currency: currency,
            dotColor: AppColors.neutral400,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _Chip(
            label: 'Sudah dicairkan',
            amount: summary.paidCents,
            currency: currency,
            dotColor: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _skeletonRow() {
    Widget block() => Expanded(
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppSurfaces.shimmerBase,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
          ),
        );
    return Row(
      children: [
        block(),
        const SizedBox(width: AppDimensions.sm),
        block(),
        const SizedBox(width: AppDimensions.sm),
        block(),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.amount,
    required this.currency,
    required this.dotColor,
    this.isLeading = false,
  });

  final String label;
  final int amount;
  final String currency;
  final Color dotColor;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    final isZero = amount == 0;
    final foreground = isZero ? AppColors.textTertiary : AppColors.textPrimary;
    final money = Formatters.formatCurrencyCompact(amount, currency);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        // The first chip uses the warm orange-tint surface to signal "action
        // possible". Others stay neutral — they're informational only.
        color: isLeading && !isZero
            ? AppSurfaces.surfaceAccent
            : AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isLeading && !isZero
              ? AppColors.accent.withValues(alpha: 0.18)
              : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: foreground,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              money,
              style: AppTypography.titleSmall.copyWith(
                color: foreground,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
