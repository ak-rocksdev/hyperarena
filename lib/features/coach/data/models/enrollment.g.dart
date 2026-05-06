// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnrollmentImpl _$$EnrollmentImplFromJson(Map<String, dynamic> json) =>
    _$EnrollmentImpl(
      id: idFromJson(json['id']),
      studentProfileId: idFromJson(json['student_profile_id']),
      programId: idFromJson(json['program_id']),
      currentLevelId: nullableIdFromJson(json['current_level_id']),
      status: json['status'] as String? ?? 'active',
      program: json['program'] == null
          ? null
          : EnrolledProgram.fromJson(json['program'] as Map<String, dynamic>),
      currentLevel: json['current_level'] == null
          ? null
          : EnrolledLevel.fromJson(
              json['current_level'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$EnrollmentImplToJson(_$EnrollmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_profile_id': instance.studentProfileId,
      'program_id': instance.programId,
      'current_level_id': instance.currentLevelId,
      'status': instance.status,
      'program': instance.program,
      'current_level': instance.currentLevel,
    };

_$EnrolledProgramImpl _$$EnrolledProgramImplFromJson(
  Map<String, dynamic> json,
) => _$EnrolledProgramImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String,
);

Map<String, dynamic> _$$EnrolledProgramImplToJson(
  _$EnrolledProgramImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$EnrolledLevelImpl _$$EnrolledLevelImplFromJson(Map<String, dynamic> json) =>
    _$EnrolledLevelImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$EnrolledLevelImplToJson(_$EnrolledLevelImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
