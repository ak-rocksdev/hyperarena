import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_action_items.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_attention_list.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_performance.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_sport_breakdown.dart';
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
    await Future.wait([
      ref
          .read(coachDashboardSummaryProvider.future)
          .then<void>((_) {})
          .catchError((_) {}),
      ref
          .read(coachScheduleProvider.future)
          .then<void>((_) {})
          .catchError((_) {}),
      ref
          .read(assessmentListProvider.future)
          .then<void>((_) {})
          .catchError((_) {}),
    ]);
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
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardPerformance(
                    result: s.performance,
                    sportCount: s.sportBreakdown.valueOrNull?.length ?? 0,
                    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
                  ),
                  loading: () => const SizedBox(height: 100),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardTodaySchedule(sessionsTomorrow: s.sessionsTomorrow),
                  loading: () => const CoachDashboardTodaySchedule(),
                  error: (_, _) => const CoachDashboardTodaySchedule(),
                ),
                const SizedBox(height: AppDimensions.xl),
                const CoachDashboardRecentAssessments(),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardAttentionList(
                    result: s.attentionList,
                    onRetry: () => ref.invalidate(coachDashboardSummaryProvider),
                  ),
                  loading: () => const SizedBox(height: 60),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppDimensions.xl),
                summaryAsync.when(
                  data: (s) => CoachDashboardSportBreakdown(result: s.sportBreakdown),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
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

