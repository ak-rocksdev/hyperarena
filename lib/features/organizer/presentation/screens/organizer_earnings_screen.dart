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

/// Period filter for the settlement list AND the hero numeral. `all` is the
/// default — first paint shows lifetime net. Tapping a chip drives both the
/// hero figure and the list together (single source of truth: the chip).
/// `custom` opens a date-range picker; the chosen range is held in
/// `_OrganizerEarningsScreenState._customRange`.
enum _SettlementPeriod { week, month, all, custom }

class _OrganizerEarningsScreenState
    extends ConsumerState<OrganizerEarningsScreen> {
  _SettlementPeriod _period = _SettlementPeriod.all;
  DateTimeRange? _customRange;

  /// Client-side filter over the already-loaded `settlements` list, keyed
  /// off `settlement.date` (which is the session start_at, not the payment
  /// confirmation timestamp). Push this to BE as a query param when
  /// per-period accuracy matters more than approximation.
  List<OrganizerSessionSettlement> _filterSettlements(
    List<OrganizerSessionSettlement> all,
  ) {
    if (_period == _SettlementPeriod.all) return all;
    final now = DateTime.now();
    return switch (_period) {
      _SettlementPeriod.week =>
        all.where((s) => now.difference(s.date).inDays.abs() <= 7).toList(),
      _SettlementPeriod.month =>
        all
            .where((s) => s.date.year == now.year && s.date.month == now.month)
            .toList(),
      _SettlementPeriod.custom =>
        _customRange == null
            ? all
            : all.where((s) {
                // Inclusive on both endpoints — picker returns date-only
                // start/end, so a session on the end date should still match.
                final endInclusive = _customRange!.end.add(
                  const Duration(days: 1),
                );
                return !s.date.isBefore(_customRange!.start) &&
                    s.date.isBefore(endInclusive);
              }).toList(),
      _SettlementPeriod.all => all,
    };
  }

  /// Opens the Material range picker pre-seeded with the last chosen range
  /// (or the last 30 days if none). On confirm, switches to `custom` period.
  /// On cancel, no state change — keeps whatever filter was active.
  Future<void> _openDateRangePicker() async {
    final now = DateTime.now();
    final initial =
        _customRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initial,
      saveText: 'Pilih',
      cancelText: 'Batal',
      confirmText: 'Terapkan',
      helpText: 'Pilih rentang tanggal',
      builder: (context, child) =>
          // Indonesian locale isn't strictly required (the picker still
          // renders), but force black-on-white surface for cohesion with
          // the rest of the screen instead of Material's default purple.
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary900,
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
      _period = _SettlementPeriod.custom;
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(organizerEarningsProvider);
    await ref.read(organizerEarningsProvider.future);
  }

  /// Guarded setter — skip rebuild when the user taps the already-active
  /// chip. Avoids a no-op ListView rebuild.
  void _setPeriod(_SettlementPeriod p) {
    if (_period == p) return;
    setState(() => _period = p);
  }

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(organizerEarningsProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pendapatan')),
      backgroundColor: AppSurfaces.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: AsyncValueWidget(
          value: earningsAsync,
          data: (earnings) {
            final filtered = _filterSettlements(earnings.settlements);
            // Period-aware net: when filter = Semua, this equals the BE
            // `availableBalance` (lifetime net); when filter = period,
            // it's the sum of that period's session nets. The hero
            // shows this value — there is no parallel "TOTAL BERSIH"
            // anywhere on the screen, so no number gets duplicated.
            final periodNet = _period == _SettlementPeriod.all
                ? earnings.availableBalance
                : filtered.fold<int>(0, (sum, s) => sum + s.netRevenue);

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Extra bottom padding clears the StatefulShell bottom nav so
              // the last settlement row isn't tucked behind the tab bar.
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenHorizontal,
                AppDimensions.screenHorizontal,
                AppDimensions.screenHorizontal,
                AppDimensions.massive + AppDimensions.xl,
              ),
              children: [
                _PendapatanHero(
                  period: _period,
                  netAmount: periodNet,
                  sessionCount: filtered.length,
                  pendingAmount: earnings.pendingBalance,
                  currency: currency,
                  customRange: _customRange,
                ),
                // Tighter gap to chips (md) so they read as belonging to
                // the hero — they control its value.
                const SizedBox(height: AppDimensions.md),

                // Period filter chips — drive the hero AND the list.
                // Horizontally scrollable so the four chips fit without
                // squeezing on narrow phones (the custom-range chip's text
                // can grow to "01 Apr – 09 Mei").
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _PeriodChip(
                        label: 'Minggu Ini',
                        isActive: _period == _SettlementPeriod.week,
                        onTap: () => _setPeriod(_SettlementPeriod.week),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      _PeriodChip(
                        label: 'Bulan Ini',
                        isActive: _period == _SettlementPeriod.month,
                        onTap: () => _setPeriod(_SettlementPeriod.month),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      _PeriodChip(
                        label: 'Semua',
                        isActive: _period == _SettlementPeriod.all,
                        onTap: () => _setPeriod(_SettlementPeriod.all),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      _PeriodChip(
                        // Active state shows the chosen range so the user
                        // doesn't need to remember what they picked. Inactive
                        // / unset shows a calendar icon prefix as affordance.
                        label:
                            _period == _SettlementPeriod.custom &&
                                _customRange != null
                            ? Formatters.formatDateRangeShort(
                                _customRange!.start,
                                _customRange!.end,
                              )
                            : 'Pilih Tanggal',
                        isActive: _period == _SettlementPeriod.custom,
                        leadingIcon: Icons.calendar_today_outlined,
                        onTap: _openDateRangePicker,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.xl),

                _RiwayatHeader(count: filtered.length),
                const SizedBox(height: AppDimensions.sm),

                if (filtered.isEmpty)
                  EmptyState(
                    message: switch (_period) {
                      _SettlementPeriod.all => 'Belum ada sesi yang selesai',
                      _SettlementPeriod.custom =>
                        'Tidak ada sesi pada rentang ini',
                      _ => 'Tidak ada sesi pada periode ini',
                    },
                    icon: Icons.receipt_long_outlined,
                  )
                else
                  ...filtered.map(
                    (settlement) => _SettlementRow(settlement: settlement),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Editorial section header for the settlement list. Just label + count +
/// horizontal hairline — the hero above already carries the period total,
/// so no aggregate appears here (avoiding duplicate display).
class _RiwayatHeader extends StatelessWidget {
  const _RiwayatHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'RIWAYAT',
          style: AppTypography.caption.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(width: AppDimensions.xs),
        Text(
          '· $count sesi',
          style: AppTypography.caption.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        const Expanded(
          child: ColoredBox(
            color: AppColors.neutral200,
            child: SizedBox(height: 1),
          ),
        ),
      ],
    );
  }
}

/// The hero of the earnings screen — a single editorial number that answers
/// "berapa pendapatan bersih saya?" for the currently-selected period. Filter
/// chips below the hero drive both this number and the settlement list, so
/// there's exactly one place on the screen where the figure is shown.
///
/// Athletic Field Notebook continuity:
/// - 4px success-tone left accent bar (anchors the screen identity, never
///   changes color across periods)
/// - editorial small-caps period prefix ("PENDAPATAN BERSIH · BULAN INI")
/// - tabular figures, tight line-height
/// - inline pending-payment meta line below a hairline divider, conveyed as
///   a footnote rather than a competing card
class _PendapatanHero extends StatelessWidget {
  const _PendapatanHero({
    required this.period,
    required this.netAmount,
    required this.sessionCount,
    required this.pendingAmount,
    required this.currency,
    this.customRange,
  });

  final _SettlementPeriod period;
  final int netAmount;
  final int sessionCount;
  final int pendingAmount;
  final String currency;

  /// Only used when `period == _SettlementPeriod.custom`. Renders into the
  /// hero prefix as "PENDAPATAN BERSIH · 01 APR – 09 MEI" so the user
  /// always knows what slice the figure represents.
  final DateTimeRange? customRange;

  String get _periodLabel => switch (period) {
    _SettlementPeriod.week => 'MINGGU INI',
    _SettlementPeriod.month => 'BULAN INI',
    _SettlementPeriod.all => 'SEMUA WAKTU',
    _SettlementPeriod.custom =>
      customRange == null
          ? 'PILIHAN'
          : Formatters.formatDateRangeShort(
              customRange!.start,
              customRange!.end,
            ).toUpperCase(),
  };

  String get _countCaption {
    if (sessionCount == 0) {
      return switch (period) {
        _SettlementPeriod.week => 'Belum ada sesi minggu ini',
        _SettlementPeriod.month => 'Belum ada sesi bulan ini',
        _SettlementPeriod.all => 'Belum ada sesi yang selesai',
        _SettlementPeriod.custom => 'Tidak ada sesi pada rentang ini',
      };
    }
    return switch (period) {
      _SettlementPeriod.week => '$sessionCount sesi minggu ini',
      _SettlementPeriod.month => '$sessionCount sesi bulan ini',
      _SettlementPeriod.all => '$sessionCount sesi selesai',
      _SettlementPeriod.custom => '$sessionCount sesi pada rentang ini',
    };
  }

  @override
  Widget build(BuildContext context) {
    final parts = Formatters.splitCurrency(netAmount, currency);
    // Zero-state neutralization — when there's nothing to celebrate, the
    // numeral and accent bar de-saturate to neutral so green stops reading
    // as "money earned" when no money was earned.
    final isZero = netAmount == 0;
    final figureColor = isZero ? AppColors.neutral400 : AppColors.success;
    final prefixColor = isZero
        ? AppColors.neutral400
        : AppColors.success.withValues(alpha: 0.85);
    final accentColor = isZero ? AppColors.neutral300 : AppColors.success;

    final hasPending = pendingAmount > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.neutral200, width: 1),
        boxShadow: AppShadows.xs,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLg),
                  bottomLeft: Radius.circular(AppDimensions.radiusLg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PENDAPATAN BERSIH · $_periodLabel',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${parts.prefix} ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: prefixColor,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          TextSpan(
                            text: parts.number,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                              color: figureColor,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      _countCaption,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.base),
                    Container(height: 1, color: AppColors.neutral100),
                    const SizedBox(height: AppDimensions.base),
                    // Pending meta — shape AND label change with state, so
                    // the signal isn't color-only (WCAG 1.4.1). Filled dot +
                    // amount when there's a tunggakan; check icon + "lunas"
                    // copy when there isn't.
                    Row(
                      children: [
                        if (hasPending)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: AppColors.success,
                          ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          hasPending
                              ? 'Tunggakan pemain'
                              : 'Tidak ada tunggakan',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        if (hasPending)
                          Text(
                            Formatters.formatCurrency(pendingAmount, currency),
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w700,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact text-style period chip — primary-toned solid pill on active key,
/// matches the Athletic Field Notebook language used elsewhere in the app
/// instead of the heavier ChoiceChip Material chrome. Optional `leadingIcon`
/// is used by the custom-range chip as a calendar affordance.
class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final fg = isActive ? Colors.white : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      // Tap area ~44px tall (md vertical pad + 11px text + line-height) to
      // satisfy WCAG 2.5.5 minimum target size on mobile.
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary900 : AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isActive ? AppColors.primary900 : AppColors.neutral200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 13, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: fg,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 11,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Settlement Row ────────────────────────────────────────────────────
/// One settlement row in the RIWAYAT list. Wears the same Athletic Field
/// Notebook chrome as `_MemberRosterCard` and `OrganizerSessionCard`:
/// 4px status-coded left accent bar + 1px border, no shadow (the hero
/// owns the screen's only soft shadow, so the list reads quieter).
class _SettlementRow extends ConsumerWidget {
  const _SettlementRow({required this.settlement});

  final OrganizerSessionSettlement settlement;

  Color _statusColor(SessionSettlementStatus status) => switch (status) {
    SessionSettlementStatus.pending => AppColors.warning,
    SessionSettlementStatus.cleared => AppColors.success,
    SessionSettlementStatus.paidOut => AppColors.primary,
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
      child: Material(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          onTap: () => context.push(
            AppRoutes.organizerSessionDetail(settlement.sessionId),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.neutral200, width: 1),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.radiusMd),
                        bottomLeft: Radius.circular(AppDimensions.radiusMd),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Text(
                                Formatters.formatCurrency(
                                  settlement.netRevenue,
                                  currency,
                                ),
                                style: AppTypography.titleSmall.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.sm,
                              vertical: AppDimensions.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
