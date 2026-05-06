// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'level_skill.freezed.dart';
part 'level_skill.g.dart';

/// One skill attached to a level (or to a student as a personal override).
///
/// From `GET /v1/coach/levels/{levelId}/skills` (standard skills, no
/// `student_profile_id`) or `GET /v1/coach/students/{id}/skill-overrides`
/// (per-student personal skills, `student_profile_id` matches the student).
///
/// FE merges both lists when rendering the grading panel; `isOverride` is
/// `true` for entries from the overrides endpoint so the UI can label them.
@freezed
class LevelSkill with _$LevelSkill {
  const factory LevelSkill({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'level_id', fromJson: idFromJson)
    required String levelId,
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    Skill? skill,
    @Default(false) bool isOverride,
  }) = _LevelSkill;

  factory LevelSkill.fromJson(Map<String, dynamic> json) =>
      _$LevelSkillFromJson(json);
}

@freezed
class Skill with _$Skill {
  const factory Skill({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? category,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}
