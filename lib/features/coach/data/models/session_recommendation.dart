// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'session_recommendation.freezed.dart';
part 'session_recommendation.g.dart';

/// "Fokus yang Disarankan" — backend-suggested focus areas for the session.
/// From `GET /v1/coach/sessions/{id}/recommendations`. Schema is intentionally
/// permissive: backend may evolve the structure; we keep the loose `Map`
/// payload for forward compatibility and only project the fields we render.
@freezed
class SessionRecommendation with _$SessionRecommendation {
  const factory SessionRecommendation({
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'student_name') String? studentName,
    String? title,
    String? description,
    @Default(<String>[]) List<String> skills,
  }) = _SessionRecommendation;

  factory SessionRecommendation.fromJson(Map<String, dynamic> json) =>
      _$SessionRecommendationFromJson(json);
}
