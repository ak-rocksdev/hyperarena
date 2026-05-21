import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// "Rincian biaya" — stacked bar + per-category line items.
///
/// Renders nothing when [items] is empty (BE has not deployed the new field
/// yet). Computes percent-of-total client-side.
class ExpenseBreakdownCard extends ConsumerWidget {
  const ExpenseBreakdownCard({super.key, required this.items});

  final List<ExpenseCategory> items;

  /// Fallback color rotation when BE returns no `colorHex`. Reasonable
  /// distinct hues to avoid two adjacent rows looking the same.
  static const _fallbackColors = [
    Color(0xFFEF4444), // red
    Color(0xFFF97316), // orange
    Color(0xFFF59E0B), // amber
    Color(0xFFA78BFA), // violet
    Color(0xFF94A3B8), // slate
    Color(0xFF14B8A6), // teal
    Color(0xFFEC4899), // pink
  ];

  Color _colorFor(int i, String? hex) {
    if (hex != null && hex.length >= 7) {
      try {
        return Color(int.parse('FF${hex.substring(1)}', radix: 16));
      } catch (_) {
        // fall through
      }
    }
    return _fallbackColors[i % _fallbackColors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final total = items.fold<int>(0, (sum, x) => sum + x.amount);

    // Empty / pending — show card with caption rather than vanishing.
    if (items.isEmpty || total <= 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Rincian biaya'),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.all(AppDimensions.base),
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(
                    'Rincian biaya per kategori akan tampil setelah pembaruan backend',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Rincian biaya',
          subtitle: Formatters.formatCurrencyCompact(total, currency),
        ),
        const SizedBox(height: AppDimensions.sm),
        Container(
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stacked horizontal bar
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          flex: items[i].amount,
                          child:
                              ColoredBox(color: _colorFor(i, items[i].colorHex)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              // Line items
              for (var i = 0; i < items.length; i++) ...[
                _ExpenseRow(
                  item: items[i],
                  total: total,
                  color: _colorFor(i, items[i].colorHex),
                  currency: currency,
                ),
                if (i < items.length - 1)
                  const SizedBox(height: AppDimensions.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({
    required this.item,
    required this.total,
    required this.color,
    required this.currency,
  });

  final ExpenseCategory item;
  final int total;
  final Color color;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (item.amount / total * 100).round() : 0;
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          alignment: Alignment.center,
          child: Text(
            item.icon ?? '🧾',
            style: const TextStyle(fontSize: 15, height: 1),
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle!,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            MoneyText(
              Formatters.formatCurrencyCompact(item.amount, currency),
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              maskWidth: 3,
            ),
            const SizedBox(height: 1),
            Text(
              '$pct%',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
