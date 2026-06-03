import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_greeting.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_recent_assessments.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_dashboard_today_schedule.dart';

class CoachDashboardScreen extends ConsumerWidget {
  const CoachDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),

              // ── 1. Greeting + Notification Bell ─────────────────
              const CoachDashboardGreeting(),
              const SizedBox(height: AppDimensions.xl),

              // ── 2. Quick Stats Row ───────────────────────────────
              const _QuickStatsRow(),
              const SizedBox(height: AppDimensions.xl),

              // ── 3. Jadwal Hari Ini ───────────────────────────────
              const CoachDashboardTodaySchedule(),
              const SizedBox(height: AppDimensions.xl),

              // ── 4. Penilaian Terbaru ─────────────────────────────
              const CoachDashboardRecentAssessments(),
              // "Ulasan Terbaru" intentionally absent — design forbids coach
              // visibility into student reviews. Admin communicates feedback
              // manually.
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people_outline,
            value: '120',
            label: 'Total Murid',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            value: '8',
            label: 'Sesi Minggu Ini',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            value: '4.8',
            label: 'Rating',
          ),
        ),
      ],
    );
  }
}

// ── Single Stat Card ───────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

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
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


