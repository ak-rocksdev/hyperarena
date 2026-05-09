import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/shared/providers/money_visibility_provider.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';

// Hoisted: intl caches ICU data internally, but constructing a fresh
// formatter on every rebuild is still a per-tile allocation we can avoid.
final _monthShortFormat = DateFormat('MMM', 'id');

class KpiStripWidget extends ConsumerWidget {
  const KpiStripWidget({super.key, required this.stats});

  final OrganizerDashboardStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(dashboardFilterProvider);
    final currency = ref.watch(tenantCurrencyProvider);
    final moneyVisible = ref.watch(moneyVisibilityProvider);
    String maskMoney(String formatted) =>
        moneyVisible ? formatted : MoneyText.maskFormatted(formatted);
    final monthShort = _monthShortFormat.format(DateTime.now());

    final tiles = [
      _KpiTile(
        // 7-day window reads more honestly than "Sesi Hari Ini" — the
        // organizer's planning lens is the upcoming week, not just today
        // (which is often empty after morning sessions wrap).
        label: 'Sesi Minggu Ini',
        value: '${stats.sessionsNext7Days}',
        icon: Icons.calendar_view_week,
        isActive: activeFilter == DashboardFilter.none,
        onTap: () => ref.read(dashboardFilterProvider.notifier).state =
            DashboardFilter.none,
      ),
      _KpiTile(
        // Currency promoted to headline — "Rp 1.5jt tertunda" is more
        // decision-driving than "3 transaksi tertunda". Falls back to
        // count when there's no outstanding amount.
        label: 'Belum Bayar',
        value: stats.totalUnpaidAmount > 0
            ? maskMoney(
                Formatters.formatCurrencyCompact(
                  stats.totalUnpaidAmount,
                  currency,
                ),
              )
            : '${stats.pendingPayments}',
        subtitle: stats.totalUnpaidAmount > 0
            ? '${stats.pendingPayments} pemain'
            : null,
        icon: Icons.payment,
        color: AppColors.warning,
        isActive: activeFilter == DashboardFilter.pendingPayment,
        onTap: () => ref.read(dashboardFilterProvider.notifier).state =
            activeFilter == DashboardFilter.pendingPayment
            ? DashboardFilter.none
            : DashboardFilter.pendingPayment,
      ),
      _KpiTile(
        label: 'Sesi Berisiko',
        value: '${stats.atRiskSessions}',
        icon: Icons.warning_amber_rounded,
        color: AppColors.error,
        isActive: activeFilter == DashboardFilter.lowQuota,
        onTap: () => ref.read(dashboardFilterProvider.notifier).state =
            activeFilter == DashboardFilter.lowQuota
            ? DashboardFilter.none
            : DashboardFilter.lowQuota,
      ),
      _KpiTile(
        // Period-explicit single-line label ("Income Mei") disambiguates
        // scope vs the lifetime "Pendapatan Bersih" shown in
        // EarningsSnapshotCard below the dashboard.
        label: 'Income $monthShort',
        value: maskMoney(
          Formatters.formatCurrencyCompact(stats.monthlyEarnings, currency),
        ),
        icon: Icons.account_balance_wallet,
        color: AppColors.success,
        isActive: false,
        onTap: null,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // 2x2 grid on narrow screens, single row on wider screens
        if (constraints.maxWidth < 360) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: tiles[0]),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(child: tiles[1]),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  Expanded(child: tiles[2]),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(child: tiles[3]),
                ],
              ),
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              Expanded(child: tiles[i]),
              if (i < tiles.length - 1) const SizedBox(width: AppDimensions.sm),
            ],
          ],
        );
      },
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? tileColor.withValues(alpha: 0.08)
              : AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: isActive
              ? Border.all(color: tileColor.withValues(alpha: 0.3), width: 1.5)
              : Border.all(color: AppColors.border, width: 1),
          boxShadow: AppShadows.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: tileColor),
            const SizedBox(height: AppDimensions.xs),
            Text(
              value,
              style: AppTypography.numberSmall.copyWith(color: tileColor),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTypography.caption.copyWith(
                  color: tileColor,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: AppDimensions.xxs),
            Text(
              label,
              style: AppTypography.caption.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
