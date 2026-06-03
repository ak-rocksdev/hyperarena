// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_action_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachActionCountsImpl _$$CoachActionCountsImplFromJson(
  Map<String, dynamic> json,
) => _$CoachActionCountsImpl(
  absencesUnmarked: (json['absences_unmarked'] as num).toInt(),
  assessmentsUngraded: (json['assessments_ungraded'] as num).toInt(),
  studentsUngraded: (json['students_ungraded'] as num).toInt(),
);

Map<String, dynamic> _$$CoachActionCountsImplToJson(
  _$CoachActionCountsImpl instance,
) => <String, dynamic>{
  'absences_unmarked': instance.absencesUnmarked,
  'assessments_ungraded': instance.assessmentsUngraded,
  'students_ungraded': instance.studentsUngraded,
};
