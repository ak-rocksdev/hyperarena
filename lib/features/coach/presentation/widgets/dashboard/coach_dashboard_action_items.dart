import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';

class CoachDashboardActionItems extends StatelessWidget {
  const CoachDashboardActionItems({
    super.key,
    required this.result,
    this.onRetry,
  });

  final SectionResult<CoachActionCounts> result;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SectionFailure() => _RetryBanner(onRetry: onRetry),
      SectionSuccess(:final value) when _allZero(value) => const SizedBox.shrink(),
      SectionSuccess(:final value) => _Card(counts: value),
    };
  }

  static bool _allZero(CoachActionCounts c) =>
      c.absencesUnmarked == 0 &&
      c.assessmentsUngraded == 0 &&
      c.studentsUngraded == 0;
}

class _Card extends StatelessWidget {
  const _Card({required this.counts});
  final CoachActionCounts counts;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    if (counts.absencesUnmarked > 0) {
      rows.add(_Row(
        icon: Icons.warning_amber_rounded,
        count: counts.absencesUnmarked,
        label: 'absensi belum di-mark',
        onTap: () => context.go('/coach/schedule?filter=unmarked'),
      ));
    }
    if (counts.assessmentsUngraded > 0) {
      rows.add(_Row(
        icon: Icons.assignment_late_outlined,
        count: counts.assessmentsUngraded,
        label: 'penilaian sesi belum diisi',
        onTap: () => context.go('/coach/schedule?filter=ungraded'),
      ));
    }
    if (counts.studentsUngraded > 0) {
      rows.add(_Row(
        icon: Icons.person_search,
        count: counts.studentsUngraded,
        label: 'murid belum dinilai',
        onTap: () => context.go('/coach/students?filter=ungraded'),
      ));
    }
    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
        border: const Border(
          left: BorderSide(color: AppColors.warning, width: 4),
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.count,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final int count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Row(
          children: [
            Icon(icon, color: AppColors.warning),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '$count ',
                  style: AppTypography.titleSmall,
                  children: [
                    TextSpan(text: label, style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _RetryBanner extends StatelessWidget {
  const _RetryBanner({this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppDimensions.sm),
          const Expanded(child: Text('Gagal memuat item perhatian')),
          TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
