import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

/// Date toggle + filter chips for the session list.
/// Shares state with KpiStripWidget via [dashboardDateRangeProvider] and
/// [dashboardFilterProvider].
class SessionFilterBar extends ConsumerWidget {
  const SessionFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dashboardDateRangeProvider);
    final filter = ref.watch(dashboardFilterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Date toggle ───────────────────────────────────────
        Row(
          children: [
            for (final range in DashboardDateRange.values) ...[
              _DateChip(
                label: _dateLabel(range),
                isActive: dateRange == range,
                onTap: () =>
                    ref.read(dashboardDateRangeProvider.notifier).state = range,
              ),
              const SizedBox(width: AppDimensions.xs),
            ],
          ],
        ),
        const SizedBox(height: AppDimensions.sm),

        // ── Filter chips ──────────────────────────────────────
        Wrap(
          spacing: AppDimensions.xs,
          runSpacing: AppDimensions.xs,
          children: [
            for (final f in DashboardFilter.values)
              if (f != DashboardFilter.none)
                _FilterChip(
                  label: _filterLabel(f),
                  color: _filterColor(f),
                  isActive: filter == f,
                  onTap: () => ref.read(dashboardFilterProvider.notifier).state =
                      filter == f ? DashboardFilter.none : f,
                ),
          ],
        ),
      ],
    );
  }

  static String _dateLabel(DashboardDateRange range) => switch (range) {
        DashboardDateRange.today => 'Hari Ini',
        DashboardDateRange.tomorrow => 'Besok',
        DashboardDateRange.thisWeek => 'Minggu Ini',
      };

  static String _filterLabel(DashboardFilter f) => switch (f) {
        DashboardFilter.none => '',
        DashboardFilter.pendingPayment => 'Belum Bayar',
        DashboardFilter.lowQuota => 'Kuota Rendah',
        DashboardFilter.dispute => 'Komplain',
        DashboardFilter.confirmed => 'Terkonfirmasi',
      };

  static Color _filterColor(DashboardFilter f) => switch (f) {
        DashboardFilter.none => AppColors.neutral400,
        DashboardFilter.pendingPayment => AppColors.warning,
        DashboardFilter.lowQuota => AppColors.accent,
        DashboardFilter.dispute => AppColors.error,
        DashboardFilter.confirmed => AppColors.success,
      };
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm + 2,
          vertical: AppDimensions.xs + 1,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isActive ? color : AppColors.neutral200,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? color : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
