import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// Headline tile that answers the organizer's first-glance question:
/// "How much have I collected today vs how much I expected?". Renders a
/// progress bar + currency-big number, color-coded by collection rate.
/// Hidden entirely when both today values are zero (no sessions today).
class TodaysCollectionsHero extends ConsumerWidget {
  const TodaysCollectionsHero({super.key, required this.stats});

  final OrganizerDashboardStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expected = stats.revenueExpectedToday;
    final collected = stats.revenueCollectedToday;

    if (expected == 0 && collected == 0) return const SizedBox.shrink();

    final currency = ref.watch(tenantCurrencyProvider);
    final rate = expected > 0 ? (collected / expected).clamp(0.0, 1.0) : 0.0;
    final color = rate >= 0.8
        ? AppColors.success
        : rate >= 0.5
        ? AppColors.warning
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.18), width: 1),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                'PENAGIHAN HARI INI',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const Spacer(),
              if (expected > 0)
                Text(
                  '${(rate * 100).round()}%',
                  style: AppTypography.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          Text.rich(
            TextSpan(
              children: [
                MoneyText.span(
                  ref,
                  Formatters.formatCurrency(collected, currency),
                  style: AppTypography.headingLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const TextSpan(text: '  / '),
                MoneyText.span(
                  ref,
                  Formatters.formatCurrency(expected, currency),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: LinearProgressIndicator(
              value: rate,
              minHeight: 6,
              backgroundColor: AppColors.neutral100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
