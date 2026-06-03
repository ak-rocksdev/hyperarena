import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';

class CoachDashboardAttentionList extends StatelessWidget {
  const CoachDashboardAttentionList({
    super.key,
    required this.result,
    this.onRetry,
  });

  final SectionResult<List<CoachStudentRosterItem>> result;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perlu Perhatian', style: AppTypography.titleMedium),
        Text('Murid belum dinilai', style: AppTypography.bodySmall),
        const SizedBox(height: AppDimensions.md),
        switch (result) {
          SectionFailure() => _retry(),
          SectionSuccess(:final value) when value.isEmpty => const EmptyState(
              icon: Icons.check_circle_outline,
              message: 'Semua murid sudah dinilai',
            ),
          SectionSuccess(:final value) => Column(
              children: value
                  .take(5)
                  .map((s) => _StudentRow(student: s))
                  .toList(),
            ),
        },
      ],
    );
  }

  Widget _retry() => Padding(
        padding: const EdgeInsets.all(AppDimensions.base),
        child: Row(
          children: [
            const Expanded(child: Text('Gagal memuat')),
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student});
  final CoachStudentRosterItem student;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/coach/students/${student.studentProfileId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                student.fullName.isNotEmpty ? student.fullName[0] : '?',
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text(student.fullName, style: AppTypography.bodyMedium),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
