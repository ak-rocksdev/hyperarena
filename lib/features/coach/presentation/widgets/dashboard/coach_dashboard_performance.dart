import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachDashboardPerformance extends ConsumerWidget {
  const CoachDashboardPerformance({
    super.key,
    required this.result,
    required this.sportCount,
    this.onRetry,
  });
  final SectionResult<CoachPerformance> result;
  final int sportCount;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    return switch (result) {
      SectionFailure() => _retry(),
      SectionSuccess(:final value) => Row(
          children: [
            Expanded(child: _Card(
              label: 'Penghasilan',
              value: Formatters.formatCurrency(value.earningsThisMonthCents, currency),
              sub: '${value.sessionsThisMonth} sesi bulan ini',
              accent: true,
              onTap: () => context.push(AppRoutes.coachWallet),
            )),
            const SizedBox(width: AppDimensions.sm),
            Expanded(child: _Card(
              label: 'Sesi',
              value: '${value.sessionsThisWeek}',
              sub: '${value.sessionsThisMonth} bulan ini',
            )),
            const SizedBox(width: AppDimensions.sm),
            Expanded(child: _Card(
              label: 'Murid Aktif',
              value: '${value.activeStudentCount}',
              sub: '$sportCount sport',
            )),
          ],
        ),
    };
  }

  Widget _retry() => Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Row(
          children: [
            const Expanded(child: Text('Gagal memuat performa')),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
}

class _Card extends StatelessWidget {
  const _Card({
    required this.label,
    required this.value,
    required this.sub,
    this.onTap,
    this.accent = false,
  });
  final String label;
  final String value;
  final String sub;
  final VoidCallback? onTap;
  // When true, hints "tappable — opens wallet" via a subtle chevron + tint.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
        border: accent
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTypography.caption)),
              if (accent)
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: accent
                  ? AppTypography.numberMedium.copyWith(color: AppColors.primary)
                  : AppTypography.numberMedium,
            ),
          ),
          const SizedBox(height: AppDimensions.xxs),
          Text(
            sub,
            style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
