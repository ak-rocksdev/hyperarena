// lib/features/coach/data/models/coach_session.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'coach_session.freezed.dart';
part 'coach_session.g.dart';

/// Session model from the coach sessions API (`GET /v1/coach/sessions`).
///
/// The list endpoint returns basic fields; the detail endpoint also includes
/// `sessionStudents` and `attendances`.
@freezed
class CoachSession with _$CoachSession {
  const factory CoachSession({
    @JsonKey(fromJson: idFromJson) required String id,
    String? type,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'duration_minutes') @Default(0) int durationMinutes,
    @Default(0) int capacity,
    String? status,
    String? notes,
    @Default('Sesi Latihan') String name,
    /// Backend-derived quality flag — independent of `status`.
    /// Values: `not_yet | needs_attendance | needs_grading | complete`.
    /// `not_yet` = future session; the other three surface warning chips on
    /// the coach dashboard (e.g. "Kehadiran Belum Lengkap").
    @JsonKey(name: 'completion_state')
    @Default('not_yet')
    String completionState,
    @JsonKey(name: 'booked_students_count') @Default(0) int bookedStudentsCount,
    CoachSessionVenue? venue,
    @Default([]) List<CoachSessionCoach> coaches,
    // Detail-only fields
    @JsonKey(name: 'session_students')
    @Default([])
    List<CoachSessionStudent> sessionStudents,
    @Default([]) List<CoachSessionAttendance> attendances,
  }) = _CoachSession;

  factory CoachSession.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionFromJson(json);
}

@freezed
class CoachSessionVenue with _$CoachSessionVenue {
  const factory CoachSessionVenue({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    CoachSessionVenueLocation? location,
  }) = _CoachSessionVenue;

  factory CoachSessionVenue.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionVenueFromJson(json);
}

@freezed
class CoachSessionVenueLocation with _$CoachSessionVenueLocation {
  const factory CoachSessionVenueLocation({
    required String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  }) = _CoachSessionVenueLocation;

  factory CoachSessionVenueLocation.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionVenueLocationFromJson(json);
}

@freezed
class CoachSessionCoach with _$CoachSessionCoach {
  const factory CoachSessionCoach({
    @JsonKey(fromJson: idFromJson) required String id,
    CoachSessionUser? user,
  }) = _CoachSessionCoach;

  factory CoachSessionCoach.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionCoachFromJson(json);
}

@freezed
class CoachSessionUser with _$CoachSessionUser {
  const factory CoachSessionUser({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? email,
  }) = _CoachSessionUser;

  factory CoachSessionUser.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionUserFromJson(json);
}

@freezed
class CoachSessionStudent with _$CoachSessionStudent {
  const factory CoachSessionStudent({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
    @JsonKey(name: 'student_profile') StudentProfile? studentProfile,
  }) = _CoachSessionStudent;

  factory CoachSessionStudent.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionStudentFromJson(json);
}

@freezed
class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  }) = _StudentProfile;

  factory StudentProfile.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileFromJson(json);
}

@freezed
class CoachSessionAttendance with _$CoachSessionAttendance {
  const factory CoachSessionAttendance({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    required String status,
    @JsonKey(name: 'marked_by_user') CoachSessionUser? markedByUser,
  }) = _CoachSessionAttendance;

  factory CoachSessionAttendance.fromJson(Map<String, dynamic> json) =>
      _$CoachSessionAttendanceFromJson(json);
}
