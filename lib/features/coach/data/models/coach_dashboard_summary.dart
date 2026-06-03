import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

part 'coach_dashboard_summary.freezed.dart';

/// All data the dashboard summary provider produces. Each section is a
/// `SectionResult<T>` so one failing fetch does not invalidate the rest.
/// `sessionsTomorrow` is derived from `coachScheduleProvider` (no separate
/// fetch) and therefore stays a plain int.
@freezed
class CoachDashboardSummary with _$CoachDashboardSummary {
  const factory CoachDashboardSummary({
    required SectionResult<CoachPerformance> performance,
    required SectionResult<CoachActionCounts> actions,
    required SectionResult<List<CoachStudentRosterItem>> attentionList,
    required SectionResult<Map<Sport, int>> sportBreakdown,
    required int sessionsTomorrow,
  }) = _CoachDashboardSummary;
}
