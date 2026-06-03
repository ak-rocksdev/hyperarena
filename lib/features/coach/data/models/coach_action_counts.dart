import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_action_counts.freezed.dart';
part 'coach_action_counts.g.dart';

/// Counts the dashboard surfaces as "action items" — unmarked attendance,
/// ungraded assessments for completed sessions, and students who have
/// never received an assessment.
@freezed
class CoachActionCounts with _$CoachActionCounts {
  const factory CoachActionCounts({
    required int absencesUnmarked,
    required int assessmentsUngraded,
    required int studentsUngraded,
  }) = _CoachActionCounts;

  factory CoachActionCounts.fromJson(Map<String, dynamic> json) =>
      _$CoachActionCountsFromJson(json);
}
