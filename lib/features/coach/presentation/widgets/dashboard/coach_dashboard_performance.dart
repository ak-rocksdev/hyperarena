import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

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
              label: 'Earnings',
              value: Formatters.formatCurrency(value.earningsThisMonthCents, currency),
              sub: '${value.sessionsThisMonth} sesi bulan ini',
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
  const _Card({required this.label, required this.value, required this.sub});
  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
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
          Text(value, style: AppTypography.numberMedium),
          const SizedBox(height: AppDimensions.xxs),
          Text(sub, style: AppTypography.caption
              .copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
