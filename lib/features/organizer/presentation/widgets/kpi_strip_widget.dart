import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

class KpiStripWidget extends ConsumerWidget {
  const KpiStripWidget({super.key, required this.stats});

  final OrganizerDashboardStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(dashboardFilterProvider);

    final tiles = [
      _KpiTile(
        label: 'Sesi Hari Ini',
        value: '${stats.sessionsToday}',
        icon: Icons.today,
        isActive: activeFilter == DashboardFilter.none,
        onTap: () =>
            ref.read(dashboardFilterProvider.notifier).state = DashboardFilter.none,
      ),
      _KpiTile(
        label: 'Belum Bayar',
        value: '${stats.pendingPayments}',
        subtitle: stats.totalUnpaidAmount > 0
            ? '(${Formatters.formatRupiahCompact(stats.totalUnpaidAmount)})'
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
        label: 'Pendapatan',
        value: Formatters.formatRupiahCompact(stats.monthlyEarnings),
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
          color: isActive ? tileColor.withValues(alpha: 0.08) : AppSurfaces.surface,
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
