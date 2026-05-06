// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'admin_student_summary.freezed.dart';
part 'admin_student_summary.g.dart';

/// Thin row from the existing `GET /v1/admin/students` endpoint. Used as a
/// fallback for the organizer Klub list until BE Issue 19.5 (`/admin/
/// students/roster`) ships with engagement + payment aggregates.
@freezed
class AdminStudentSummary with _$AdminStudentSummary {
  const factory AdminStudentSummary({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AdminStudentSummary;

  factory AdminStudentSummary.fromJson(Map<String, dynamic> json) =>
      _$AdminStudentSummaryFromJson(json);
}
