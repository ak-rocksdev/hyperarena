// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'program.freezed.dart';
part 'program.g.dart';

/// Tenant-scoped coaching program (e.g. "Class Newbie to Beginner").
/// Used for the enrollment dialog dropdowns. From `GET /v1/coach/programs`.
@freezed
class Program with _$Program {
  const factory Program({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}

/// One level within a program (e.g. "Newbie to Lower Beginner").
/// From `GET /v1/coach/programs/{id}/levels`.
@freezed
class ProgramLevel with _$ProgramLevel {
  const factory ProgramLevel({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'program_id', fromJson: idFromJson)
    required String programId,
    required String name,
    String? description,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _ProgramLevel;

  factory ProgramLevel.fromJson(Map<String, dynamic> json) =>
      _$ProgramLevelFromJson(json);
}
