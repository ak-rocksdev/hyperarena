import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_performance.freezed.dart';
part 'coach_performance.g.dart';

/// Performance metrics for a coach. Currency fields are in the smallest
/// unit (IDR uses whole rupiah, MYR uses cents — multiply by tenant
/// currency multiplier when formatting). Earnings are club-side only;
/// marketplace earnings are not part of this iteration.
@freezed
class CoachPerformance with _$CoachPerformance {
  const factory CoachPerformance({
    required int earningsThisWeekCents,
    required int earningsThisMonthCents,
    required int sessionsThisWeek,
    required int sessionsThisMonth,
    required int activeStudentCount,
  }) = _CoachPerformance;

  factory CoachPerformance.fromJson(Map<String, dynamic> json) =>
      _$CoachPerformanceFromJson(json);
}
