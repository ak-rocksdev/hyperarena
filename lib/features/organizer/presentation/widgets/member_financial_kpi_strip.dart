import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// Member-detail financial KPI strip — three small white cards.
///
/// Cards:
///   1. Bayar bulan ini (success-toned)
///   2. Total transaksi
///   3. Lifetime (hidden if `lifetimeSpend` null)
///
/// This is intentionally simpler than the existing inline strip on
/// `organizer_member_detail_screen.dart` — the outstanding amount has been
/// promoted into [MemberHeroWithOutstanding] so it doesn't compete here.
class MemberFinancialKpiStrip extends ConsumerWidget {
  const MemberFinancialKpiStrip({super.key, required this.financial});

  final FinancialStats financial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final lifetime = financial.lifetimeSpend;

    final tiles = <Widget>[
      _MiniKpi(
        label: 'Bayar bulan ini',
        value: Formatters.formatCurrencyCompact(
            financial.paidThisMonth, currency),
        accent: AppColors.successDark,
      ),
      _MiniKpi(
        label: 'Total transaksi',
        value: '${financial.totalTransactions}',
      ),
      _MiniKpi(
        label: 'Lifetime',
        // Placeholder when BE-pending `lifetime_spend` arrives.
        value: lifetime != null
            ? Formatters.formatCurrencyCompact(lifetime, currency)
            : '—',
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: AppDimensions.sm),
          Expanded(child: tiles[i]),
        ],
      ],
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi({required this.label, required this.value, this.accent});

  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          MoneyText(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: accent ?? AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maskWidth: 3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
