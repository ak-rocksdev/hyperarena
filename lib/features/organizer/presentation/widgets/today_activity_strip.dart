import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/section_header.dart';
import 'package:intl/intl.dart';

/// "Hari ini · {date}" strip with up to 3 mini KPI cards.
///
/// Sources:
///   - Sesi:         stats.sessionsToday (always present)
///   - Pelatih aktif: stats.coachesActiveToday / coachesTotal (BE-pending)
///   - Pemain:       stats.playersBookedToday (BE-pending)
///
/// Hides individual tiles whose value is null. Hides the entire strip
/// when only `sessionsToday` is available AND it equals zero (idle day).
class TodayActivityStrip extends StatelessWidget {
  const TodayActivityStrip({super.key, required this.stats});

  final OrganizerDashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    final s = stats;
    if (s == null) return const SizedBox.shrink();

    final sessions = s.sessionsToday;
    final coachesActive = s.coachesActiveToday;
    final coachesTotal = s.coachesTotal;
    final players = s.playersBookedToday;

    // Always render all 3 tiles for visual consistency. BE-pending values
    // show "—" placeholder; once the dashboard spec fields deploy, the
    // tiles fill in automatically.
    final tiles = <Widget>[
      _MiniKpi(label: 'Sesi', value: '$sessions sesi'),
      _MiniKpi(
        label: 'Pelatih aktif',
        value: (coachesActive != null && coachesTotal != null)
            ? '$coachesActive/$coachesTotal'
            : '—',
      ),
      _MiniKpi(
        label: 'Pemain',
        value: players != null ? '$players' : '—',
      ),
    ];

    final dateLabel = DateFormat('EEEE, d MMM', 'id').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.lg,
        AppDimensions.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Hari ini', subtitle: dateLabel),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0) const SizedBox(width: AppDimensions.sm),
                Expanded(child: tiles[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
