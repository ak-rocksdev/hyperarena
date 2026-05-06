// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item.freezed.dart';
part 'activity_item.g.dart';

/// Stable enum (matches BE contract — keep in sync with
/// `ActivityController::resolveType` in HyperCoach).
enum ActivityType {
  @JsonValue('session_completed')
  sessionCompleted,
  @JsonValue('attendance_filled')
  attendanceFilled,
  @JsonValue('assessment_submitted')
  assessmentSubmitted,
  @JsonValue('profile_updated')
  profileUpdated,
  @JsonValue('review_sent')
  reviewSent,
  @JsonValue('unknown')
  unknown,
}

@freezed
class ActivitySubject with _$ActivitySubject {
  const factory ActivitySubject({
    required String type,
    required int id,
    String? name,
  }) = _ActivitySubject;

  factory ActivitySubject.fromJson(Map<String, dynamic> json) =>
      _$ActivitySubjectFromJson(json);
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required int id,
    required ActivityType type,
    required String description,
    ActivitySubject? subject,
    @JsonKey(name: 'occurred_at') DateTime? occurredAt,
  }) = _ActivityItem;

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityItemFromJson(json);
}
