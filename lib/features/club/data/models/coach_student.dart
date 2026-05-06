// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'coach_student.freezed.dart';
part 'coach_student.g.dart';

/// One row in the coach's roster (`GET /v1/coach/students`, Issue 19.1).
@freezed
class CoachStudentRosterItem with _$CoachStudentRosterItem {
  const factory CoachStudentRosterItem({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'full_name') required String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions_with_coach')
    @Default(0)
    int totalSessionsWithCoach,
    @JsonKey(name: 'attendance_rate') @Default(0.0) double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
  }) = _CoachStudentRosterItem;

  factory CoachStudentRosterItem.fromJson(Map<String, dynamic> json) =>
      _$CoachStudentRosterItemFromJson(json);
}

@freezed
class StudentEnrollmentSummary with _$StudentEnrollmentSummary {
  const factory StudentEnrollmentSummary({
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
  }) = _StudentEnrollmentSummary;

  factory StudentEnrollmentSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentEnrollmentSummaryFromJson(json);
}

@freezed
class LatestProgress with _$LatestProgress {
  const factory LatestProgress({
    String? status,
    int? score,
  }) = _LatestProgress;

  factory LatestProgress.fromJson(Map<String, dynamic> json) =>
      _$LatestProgressFromJson(json);
}
