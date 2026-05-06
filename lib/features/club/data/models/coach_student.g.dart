// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachStudentRosterItemImpl _$$CoachStudentRosterItemImplFromJson(
  Map<String, dynamic> json,
) => _$CoachStudentRosterItemImpl(
  studentProfileId: idFromJson(json['student_profile_id']),
  fullName: json['full_name'] as String,
  age: (json['age'] as num?)?.toInt(),
  photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  enrollment: json['enrollment'] == null
      ? null
      : StudentEnrollmentSummary.fromJson(
          json['enrollment'] as Map<String, dynamic>,
        ),
  lastSessionAt: json['last_session_at'] == null
      ? null
      : DateTime.parse(json['last_session_at'] as String),
  totalSessionsWithCoach:
      (json['total_sessions_with_coach'] as num?)?.toInt() ?? 0,
  attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
  latestProgress: json['latest_progress'] == null
      ? null
      : LatestProgress.fromJson(
          json['latest_progress'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$CoachStudentRosterItemImplToJson(
  _$CoachStudentRosterItemImpl instance,
) => <String, dynamic>{
  'student_profile_id': instance.studentProfileId,
  'full_name': instance.fullName,
  'age': instance.age,
  'photo_urls': instance.photoUrls,
  'enrollment': instance.enrollment,
  'last_session_at': instance.lastSessionAt?.toIso8601String(),
  'total_sessions_with_coach': instance.totalSessionsWithCoach,
  'attendance_rate': instance.attendanceRate,
  'latest_progress': instance.latestProgress,
};

_$StudentEnrollmentSummaryImpl _$$StudentEnrollmentSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$StudentEnrollmentSummaryImpl(
  programName: json['program_name'] as String?,
  levelName: json['level_name'] as String?,
);

Map<String, dynamic> _$$StudentEnrollmentSummaryImplToJson(
  _$StudentEnrollmentSummaryImpl instance,
) => <String, dynamic>{
  'program_name': instance.programName,
  'level_name': instance.levelName,
};

_$LatestProgressImpl _$$LatestProgressImplFromJson(Map<String, dynamic> json) =>
    _$LatestProgressImpl(
      status: json['status'] as String?,
      score: (json['score'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LatestProgressImplToJson(
  _$LatestProgressImpl instance,
) => <String, dynamic>{'status': instance.status, 'score': instance.score};
