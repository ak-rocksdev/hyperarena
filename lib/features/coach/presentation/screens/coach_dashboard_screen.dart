import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';
import 'package:hyperarena/features/coach/providers/assessment_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_dashboard_summary_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_schedule_provider.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(coachDashboardSummaryProvider);
    ref.invalidate(coachScheduleProvider);
    ref.invalidate(assessmentListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(coachDashboardSummaryProvider);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.base),
                const CoachDashboardGreeting(),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardActionItems(
                    result: s.actions,
                    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
                  ),
                  loading: () => const SizedBox(height: 60),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimensions.xl),
                const _QuickStatsRow(), // TEMPORARY — replaced in Phase 8
                const SizedBox(height: AppDimensions.xl),
                const CoachDashboardTodaySchedule(),
                const SizedBox(height: AppDimensions.xl),
                const CoachDashboardRecentAssessments(),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardAttentionList(
                    result: s.attentionList,
                    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
                  ),
                  loading: () => const SizedBox(height: 60),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimensions.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats Row — TEMPORARY, replaced by CoachDashboardPerformance in Phase 8
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard(icon: Icons.people_outline, value: '120', label: 'Total Murid')),
        SizedBox(width: AppDimensions.sm),
        Expanded(child: _StatCard(icon: Icons.calendar_today, value: '8', label: 'Sesi Minggu Ini')),
        SizedBox(width: AppDimensions.sm),
        Expanded(child: _StatCard(icon: Icons.star_rounded, value: '4.8', label: 'Rating')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

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
        children: [
          Icon(icon, color: AppColors.primary, size: AppDimensions.iconMd),
          const SizedBox(height: AppDimensions.sm),
          Text(value, style: AppTypography.numberMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
