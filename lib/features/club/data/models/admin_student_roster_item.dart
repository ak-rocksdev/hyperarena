// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'admin_student_roster_item.freezed.dart';
part 'admin_student_roster_item.g.dart';

/// One row in the organizer's tenant-wide roster (`GET /v1/admin/students/
/// roster`, Issue 19.5). Mirrors the coach-scoped 19.1 row plus three
/// organizer-only signals: `assigned_coach`, `outstanding_*`, and
/// `oldest_outstanding_at`. `total_sessions` is tenant-wide here (vs
/// `total_sessions_with_coach` on 19.1).
@freezed
class AdminStudentRosterItem with _$AdminStudentRosterItem {
  const factory AdminStudentRosterItem({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'full_name') required String fullName,
    int? age,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    StudentEnrollmentSummary? enrollment,
    @JsonKey(name: 'assigned_coach') AssignedCoachSummary? assignedCoach,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'total_sessions') @Default(0) int totalSessions,
    @JsonKey(name: 'attendance_rate') @Default(0.0) double attendanceRate,
    @JsonKey(name: 'latest_progress') LatestProgress? latestProgress,
    @JsonKey(name: 'outstanding_amount') @Default(0) int outstandingAmount,
    @JsonKey(name: 'outstanding_count') @Default(0) int outstandingCount,
    @JsonKey(name: 'oldest_outstanding_at') DateTime? oldestOutstandingAt,
  }) = _AdminStudentRosterItem;

  factory AdminStudentRosterItem.fromJson(Map<String, dynamic> json) =>
      _$AdminStudentRosterItemFromJson(json);
}

@freezed
class AssignedCoachSummary with _$AssignedCoachSummary {
  const factory AssignedCoachSummary({
    @JsonKey(fromJson: idFromJson) required String id,
    String? name,
  }) = _AssignedCoachSummary;

  factory AssignedCoachSummary.fromJson(Map<String, dynamic> json) =>
      _$AssignedCoachSummaryFromJson(json);
}
