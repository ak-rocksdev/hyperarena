import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// "Ringkasan bulan ini" P&L card.
///
/// Renders nothing when [grossRevenue] OR [totalExpenses] is null (BE has
/// not deployed the new fields yet). Margin and session count footer are
/// hidden individually if their inputs are null.
class PnlCard extends ConsumerWidget {
  const PnlCard({
    super.key,
    required this.grossRevenue,
    required this.totalExpenses,
    required this.netRevenue,
    this.sessionCount,
  });

  final int? grossRevenue;
  final int? totalExpenses;
  final int? netRevenue;
  final int? sessionCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Card always renders. When any field is BE-pending, show "—" rows +
    // small caption explaining the gap. Keeps layout stable.
    final currency = ref.watch(tenantCurrencyProvider);
    final isPending =
        grossRevenue == null || totalExpenses == null || netRevenue == null;
    final marginPct = (!isPending && grossRevenue! > 0)
        ? (netRevenue! / grossRevenue! * 100).round()
        : null;

    String formatOrDash(int? value, {String prefix = ''}) {
      if (value == null) return '—';
      return '$prefix${Formatters.formatCurrency(value, currency)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Ringkasan bulan ini'),
        const SizedBox(height: AppDimensions.sm),
        Container(
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _PnLRow(
                label: 'Pendapatan kotor',
                amount: formatOrDash(grossRevenue),
                amountColor: AppColors.textPrimary,
              ),
              _PnLRow(
                label: 'Total biaya',
                amount: totalExpenses != null
                    ? '− ${Formatters.formatCurrency(totalExpenses!, currency)}'
                    : '—',
                amountColor: AppColors.errorDark,
              ),
              const SizedBox(height: AppDimensions.sm),
              const _DashedDivider(),
              const SizedBox(height: AppDimensions.sm),
              _PnLRow(
                label: 'Pendapatan bersih',
                amount: formatOrDash(netRevenue),
                amountColor: AppColors.textPrimary,
                emphasize: true,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isPending
                      ? 'Tersedia setelah pembaruan backend'
                      : [
                          if (marginPct != null) 'Margin $marginPct%',
                          if (sessionCount != null) '$sessionCount sesi',
                        ].join(' · '),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PnLRow extends StatelessWidget {
  const _PnLRow({
    required this.label,
    required this.amount,
    required this.amountColor,
    this.emphasize = false,
  });

  final String label;
  final String amount;
  final Color amountColor;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasize
                  ? AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    )
                  : AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
          MoneyText(
            amount,
            style: (emphasize
                    ? AppTypography.titleMedium
                    : AppTypography.titleSmall)
                .copyWith(
              color: amountColor,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, c) {
          final dashWidth = 4.0;
          final gap = 4.0;
          final dashCount = (c.maxWidth / (dashWidth + gap)).floor();
          return Row(
            children: List.generate(dashCount, (_) {
              return Padding(
                padding: EdgeInsets.only(right: gap),
                child: SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: const ColoredBox(color: AppColors.border),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
