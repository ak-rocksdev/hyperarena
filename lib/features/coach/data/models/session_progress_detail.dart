// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'session_progress_detail.freezed.dart';
part 'session_progress_detail.g.dart';

/// Existing progress for a session, keyed for hydration on render.
/// From `GET /v1/coach/sessions/{id}/progress`.
@freezed
class SessionProgressDetail with _$SessionProgressDetail {
  const factory SessionProgressDetail({
    @JsonKey(name: 'session_progress')
    @Default(<SessionProgressEntry>[])
    List<SessionProgressEntry> sessionProgress,
    @JsonKey(name: 'skill_progress')
    @Default(<SkillProgressEntry>[])
    List<SkillProgressEntry> skillProgress,
  }) = _SessionProgressDetail;

  factory SessionProgressDetail.fromJson(Map<String, dynamic> json) =>
      _$SessionProgressDetailFromJson(json);
}

/// Overall session-level progress for one student. Status enum is
/// `needs_work | progressing | good | excellent`. `score` is set in numeric
/// scoring tenants (0-10), null in status tenants.
@freezed
class SessionProgressEntry with _$SessionProgressEntry {
  const factory SessionProgressEntry({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    String? status,
    int? score,
    String? notes,
  }) = _SessionProgressEntry;

  factory SessionProgressEntry.fromJson(Map<String, dynamic> json) =>
      _$SessionProgressEntryFromJson(json);
}

/// Per-skill progress within a session. Status enum is distinct from
/// session-level: `not_started | in_progress | achieved`.
@freezed
class SkillProgressEntry with _$SkillProgressEntry {
  const factory SkillProgressEntry({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required String levelSkillId,
    String? status,
    int? score,
    String? notes,
  }) = _SkillProgressEntry;

  factory SkillProgressEntry.fromJson(Map<String, dynamic> json) =>
      _$SkillProgressEntryFromJson(json);
}
