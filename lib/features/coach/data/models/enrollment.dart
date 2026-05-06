// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'enrollment.freezed.dart';
part 'enrollment.g.dart';

/// Student enrollment in a coaching program. From `GET /v1/coach/enrollments`.
/// One row per (student, program). `currentLevel` may be null when the program
/// has no levels or the student hasn't been placed yet.
@freezed
class Enrollment with _$Enrollment {
  const factory Enrollment({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required String studentProfileId,
    @JsonKey(name: 'program_id', fromJson: idFromJson)
    required String programId,
    @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
    String? currentLevelId,
    @Default('active') String status,
    EnrolledProgram? program,
    @JsonKey(name: 'current_level') EnrolledLevel? currentLevel,
  }) = _Enrollment;

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);
}

@freezed
class EnrolledProgram with _$EnrolledProgram {
  const factory EnrolledProgram({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
  }) = _EnrolledProgram;

  factory EnrolledProgram.fromJson(Map<String, dynamic> json) =>
      _$EnrolledProgramFromJson(json);
}

@freezed
class EnrolledLevel with _$EnrolledLevel {
  const factory EnrolledLevel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
  }) = _EnrolledLevel;

  factory EnrolledLevel.fromJson(Map<String, dynamic> json) =>
      _$EnrolledLevelFromJson(json);
}
