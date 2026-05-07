import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OrganizerEarningsScreen extends ConsumerStatefulWidget {
  const OrganizerEarningsScreen({super.key});

  @override
  ConsumerState<OrganizerEarningsScreen> createState() =>
      _OrganizerEarningsScreenState();
}

class _OrganizerEarningsScreenState
    extends ConsumerState<OrganizerEarningsScreen> {
  int _selectedFilter = 1; // 0=Minggu Ini, 1=Bulan Ini, 2=Semua

  static const _filterLabels = ['Minggu Ini', 'Bulan Ini', 'Semua'];

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(organizerEarningsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pendapatan')),
      backgroundColor: AppSurfaces.background,
      body: AsyncValueWidget(
        value: earningsAsync,
        data: (earnings) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            children: [
              // ── Summary Cards ──────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Tersedia',
                      amount: earnings.availableBalance,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Tertunda',
                      amount: earnings.pendingBalance,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Dibayarkan',
                      amount: earnings.paidOutThisMonth,
                      color: AppColors.neutral600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.lg),

              // ── Period Filter Chips ────────────────────────────
              Row(
                children: List.generate(_filterLabels.length, (i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: i < _filterLabels.length - 1
                          ? AppDimensions.sm
                          : 0,
                    ),
                    child: ChoiceChip(
                      label: Text(_filterLabels[i]),
                      selected: _selectedFilter == i,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedFilter = i);
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppDimensions.lg),

              // ── Settlement List ────────────────────────────────
              if (earnings.settlements.isEmpty)
                const EmptyState(
                  message: 'Belum ada sesi yang selesai',
                  icon: Icons.receipt_long_outlined,
                )
              else
                ...earnings.settlements.map((settlement) {
                  return _SettlementRow(settlement: settlement);
                }),
            ],
          );
        },
      ),
    );
  }
}

// ── Summary Card ──────────────────────────────────────────────────────
class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({
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
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(height: AppDimensions.xs),
          Text(
            Formatters.formatCurrency(amount, currency),
            style: AppTypography.titleMedium.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Settlement Row ────────────────────────────────────────────────────
class _SettlementRow extends ConsumerWidget {
  const _SettlementRow({required this.settlement});

  final OrganizerSessionSettlement settlement;

  Color _statusColor(SessionSettlementStatus status) => switch (status) {
        SessionSettlementStatus.pending => AppColors.accent,
        SessionSettlementStatus.cleared => AppColors.info,
        SessionSettlementStatus.paidOut => AppColors.success,
      };

  String _statusLabel(SessionSettlementStatus status) => switch (status) {
        SessionSettlementStatus.pending => 'Tertunda',
        SessionSettlementStatus.cleared => 'Selesai',
        SessionSettlementStatus.paidOut => 'Dibayarkan',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(settlement.settlementStatus);
    final statusLabel = _statusLabel(settlement.settlementStatus);
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: GestureDetector(
        onTap: () => context.push(
          AppRoutes.organizerSessionDetail(settlement.sessionId),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Left: title + date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settlement.title,
                          style: AppTypography.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.xxs),
                        Text(
                          Formatters.formatDate(settlement.date),
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  // Right: net revenue
                  Text(
                    Formatters.formatCurrency(settlement.netRevenue, currency),
                    style: AppTypography.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xxs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.labelSmall.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
