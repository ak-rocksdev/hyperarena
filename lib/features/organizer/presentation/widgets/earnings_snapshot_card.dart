import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Tappable earnings card with 4-line breakdown:
/// Tersedia (green), Tertunda pemain (orange), Tertunda venue (orange),
/// Dalam komplain (red).
class EarningsSnapshotCard extends StatelessWidget {
  const EarningsSnapshotCard({super.key, required this.earnings});

  final OrganizerEarningsSummary earnings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.organizerEarnings),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pendapatan', style: AppTypography.titleSmall),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.neutral400,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            _EarningsRow(
              label: 'Tersedia',
              amount: earnings.availableBalance,
              color: AppColors.success,
            ),
            const SizedBox(height: AppDimensions.sm),
            _EarningsRow(
              label: 'Tertunda (pemain)',
              amount: earnings.pendingPlayerBalance,
              color: AppColors.warning,
            ),
            const SizedBox(height: AppDimensions.sm),
            _EarningsRow(
              label: 'Tertunda (venue)',
              amount: earnings.pendingVenueBalance,
              color: AppColors.warning,
            ),
            if (earnings.disputeHoldBalance > 0) ...[
              const SizedBox(height: AppDimensions.sm),
              _EarningsRow(
                label: 'Dalam komplain',
                amount: earnings.disputeHoldBalance,
                color: AppColors.error,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EarningsRow extends ConsumerWidget {
  const _EarningsRow({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(label, style: AppTypography.bodySmall),
          ],
        ),
        Text(
          Formatters.formatCurrency(amount, currency),
          style: AppTypography.titleSmall.copyWith(color: color),
        ),
      ],
    );
  }
}
