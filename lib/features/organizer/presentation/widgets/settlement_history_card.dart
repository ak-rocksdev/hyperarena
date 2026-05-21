import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

/// "Riwayat" — settlement history list grouped inside a single white card.
///
/// Each row: 4px status-coded left bar + title + date + status pill + net.
/// Tap → session detail.
class SettlementHistoryCard extends ConsumerWidget {
  const SettlementHistoryCard({super.key, required this.items});

  final List<OrganizerSessionSettlement> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Riwayat', count: items.length),
        const SizedBox(height: AppDimensions.sm),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.base,
              vertical: AppDimensions.lg,
            ),
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 20,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Belum ada sesi pada periode ini',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  _SettlementRow(
                    settlement: items[i],
                    topDivider: i > 0,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SettlementRow extends ConsumerWidget {
  const _SettlementRow({
    required this.settlement,
    required this.topDivider,
  });

  final OrganizerSessionSettlement settlement;
  final bool topDivider;

  Color _statusColor() => switch (settlement.settlementStatus) {
        SessionSettlementStatus.pending => AppColors.warning,
        SessionSettlementStatus.cleared => AppColors.info,
        SessionSettlementStatus.paidOut => AppColors.success,
      };

  Color _statusBg() => switch (settlement.settlementStatus) {
        SessionSettlementStatus.pending => AppColors.warningLight,
        SessionSettlementStatus.cleared => AppColors.infoLight,
        SessionSettlementStatus.paidOut => AppColors.successLight,
      };

  Color _statusFg() => switch (settlement.settlementStatus) {
        SessionSettlementStatus.pending => AppColors.warningDark,
        SessionSettlementStatus.cleared => AppColors.infoDark,
        SessionSettlementStatus.paidOut => AppColors.successDark,
      };

  String _statusLabel() => switch (settlement.settlementStatus) {
        SessionSettlementStatus.pending => 'Tertunda',
        SessionSettlementStatus.cleared => 'Tersedia',
        SessionSettlementStatus.paidOut => 'Dibayarkan',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);

    return Material(
      color: AppSurfaces.surface,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.organizerSessionDetail(settlement.sessionId),
        ),
        child: Container(
          decoration: topDivider
              ? const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.borderLight),
                  ),
                )
              : null,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: _statusColor()),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          settlement.title,
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              Formatters.formatDateShort(settlement.date),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              '·',
                              style: TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _statusBg(),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull,
                                ),
                              ),
                              child: Text(
                                _statusLabel(),
                                style: AppTypography.labelMedium.copyWith(
                                  color: _statusFg(),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.base,
                    vertical: AppDimensions.md,
                  ),
                  child: MoneyText(
                    (settlement.netRevenue >= 0 ? '+' : '') +
                        Formatters.formatCurrency(
                          settlement.netRevenue,
                          currency,
                        ),
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
