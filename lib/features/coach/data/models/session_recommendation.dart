// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'session_recommendation.freezed.dart';
part 'session_recommendation.g.dart';

/// Per-student curriculum recommendations for a session.
/// From `GET /v1/coach/sessions/{id}/recommendations`.
///
/// Each entry exposes three skill buckets driven by the student's most-recent
/// `skill_progress` against their current level's `level_skills`:
/// - **focus**: skills last marked `in_progress` (most-recent first).
/// - **introduce**: skills never started (capped to 3 by BE).
/// - **review**: skills already `achieved` (oldest-first, spaced repetition).
///
/// `studentName` is intentionally NOT on the wire — callers look it up from
/// the session's participants list. Web uses the same pattern.
@freezed
class SessionRecommendation with _$SessionRecommendation {
  const SessionRecommendation._();

  const factory SessionRecommendation({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'has_enrollment') @Default(false) bool hasEnrollment,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    @Default(<RecommendationSkill>[]) List<RecommendationSkill> focus,
    @Default(<RecommendationSkill>[]) List<RecommendationSkill> introduce,
    @Default(<RecommendationSkill>[]) List<RecommendationSkill> review,
  }) = _SessionRecommendation;

  factory SessionRecommendation.fromJson(Map<String, dynamic> json) =>
      _$SessionRecommendationFromJson(json);

  bool get hasAny =>
      focus.isNotEmpty || introduce.isNotEmpty || review.isNotEmpty;
}

@freezed
class RecommendationSkill with _$RecommendationSkill {
  const factory RecommendationSkill({
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required String levelSkillId,
    @JsonKey(name: 'skill_name') required String skillName,
    String? category,
    @JsonKey(name: 'last_status') String? lastStatus,
    int? score,
    @JsonKey(name: 'last_practiced_at') String? lastPracticedAt,
  }) = _RecommendationSkill;

  factory RecommendationSkill.fromJson(Map<String, dynamic> json) =>
      _$RecommendationSkillFromJson(json);
}
