import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/earnings_hero.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/expense_breakdown_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/pnl_card.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/settlement_history_card.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:intl/intl.dart';

/// Organizer earnings (Pendapatan) detail — redesigned per
/// `docs/PRD-organizer-ui-improvement.md` (PR 3).
///
/// Composition:
///   1. [EarningsHero] — period chips + uppercase label + big net + caption + bar chart
///   2. [PnlCard] — Pendapatan kotor / Total biaya / Pendapatan bersih + margin
///   3. [ExpenseBreakdownCard] — stacked bar + per-category line items
///   4. [SettlementHistoryCard] — riwayat rows with status pills
///
/// P&L card, expense breakdown, bar chart, and delta caption are gated on
/// BE-pending fields and hide gracefully when null/empty.
class OrganizerEarningsScreen extends ConsumerStatefulWidget {
  const OrganizerEarningsScreen({super.key});

  @override
  ConsumerState<OrganizerEarningsScreen> createState() =>
      _OrganizerEarningsScreenState();
}

class _OrganizerEarningsScreenState
    extends ConsumerState<OrganizerEarningsScreen> {
  EarningsPeriod _period = EarningsPeriod.month;
  DateTimeRange? _customRange;

  /// Client-side filter over the already-loaded settlements list, keyed on
  /// `settlement.date` (session start). Push to BE as a query param when
  /// per-period accuracy matters more than approximation.
  List<OrganizerSessionSettlement> _filterSettlements(
    List<OrganizerSessionSettlement> all,
  ) {
    if (_period == EarningsPeriod.all) return all;
    final now = DateTime.now();
    return switch (_period) {
      EarningsPeriod.week =>
        all.where((s) => now.difference(s.date).inDays.abs() <= 7).toList(),
      EarningsPeriod.month => all
          .where((s) => s.date.year == now.year && s.date.month == now.month)
          .toList(),
      EarningsPeriod.custom => _customRange == null
          ? all
          : all.where((s) {
              final endInclusive =
                  _customRange!.end.add(const Duration(days: 1));
              return !s.date.isBefore(_customRange!.start) &&
                  s.date.isBefore(endInclusive);
            }).toList(),
      EarningsPeriod.all => all,
    };
  }

  Future<void> _openDateRangePicker() async {
    final now = DateTime.now();
    final initial = _customRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initial,
      saveText: 'Pilih',
      cancelText: 'Batal',
      confirmText: 'Terapkan',
      helpText: 'Pilih rentang tanggal',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                surface: AppSurfaces.surface,
              ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _customRange = picked;
      _period = EarningsPeriod.custom;
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(organizerEarningsProvider);
    await ref.read(organizerEarningsProvider.future);
  }

  String _periodLabel() {
    return switch (_period) {
      EarningsPeriod.week => 'Minggu ini',
      EarningsPeriod.month => DateFormat('MMMM yyyy', 'id').format(DateTime.now()),
      EarningsPeriod.all => 'Semua waktu',
      EarningsPeriod.custom => _customRange == null
          ? 'Pilihan'
          : Formatters.formatDateRangeShort(
              _customRange!.start,
              _customRange!.end,
            ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(organizerEarningsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendapatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: 'Bagikan',
            onPressed: () {
              // Phase 5+: share period summary as image/text.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur bagikan akan datang'),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: AppSurfaces.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: AsyncValueWidget(
          value: earningsAsync,
          data: (earnings) {
            final filtered = _filterSettlements(earnings.settlements);
            // Prefer BE-aggregated net when available; fall back to lifetime
            // available balance / per-period fold when not. The hero number
            // is always meaningful even pre-BE-deploy.
            final periodNet = earnings.netRevenueThisPeriod ??
                (_period == EarningsPeriod.all
                    ? earnings.availableBalance
                    : filtered.fold<int>(0, (sum, s) => sum + s.netRevenue));
            final periodSessionCount = earnings.sessionCount ?? filtered.length;

            final lastNet = earnings.prevPeriodNet;
            final delta = (lastNet != null && lastNet > 0)
                ? ((periodNet - lastNet) / lastNet * 100)
                : null;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontal,
                AppDimensions.base,
                AppDimensions.screenHorizontal,
                AppDimensions.massive + AppDimensions.xl,
              ),
              children: [
                EarningsHero(
                  period: _period,
                  netAmount: periodNet,
                  periodLabel: _periodLabel(),
                  sessionCount: periodSessionCount > 0
                      ? periodSessionCount
                      : null,
                  deltaVsPrev: delta,
                  weeklyChart: earnings.weeklyChart,
                  customRangeLabel: _customRange != null
                      ? Formatters.formatDateRangeShort(
                          _customRange!.start,
                          _customRange!.end,
                        )
                      : null,
                  onPeriodChange: (p) {
                    if (p == _period) return;
                    setState(() => _period = p);
                  },
                  onPickCustomRange: _openDateRangePicker,
                ),
                const SizedBox(height: AppDimensions.lg),
                PnlCard(
                  grossRevenue: earnings.grossRevenue,
                  totalExpenses: earnings.totalExpenses,
                  netRevenue: earnings.netRevenueThisPeriod,
                  sessionCount: earnings.sessionCount,
                ),
                const SizedBox(height: AppDimensions.lg),
                ExpenseBreakdownCard(items: earnings.expenseBreakdown),
                const SizedBox(height: AppDimensions.lg),
                SettlementHistoryCard(items: filtered),
              ],
            );
          },
        ),
      ),
    );
  }
}
