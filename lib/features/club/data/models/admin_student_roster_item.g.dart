// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_student_roster_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminStudentRosterItemImpl _$$AdminStudentRosterItemImplFromJson(
  Map<String, dynamic> json,
) => _$AdminStudentRosterItemImpl(
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
  assignedCoach: json['assigned_coach'] == null
      ? null
      : AssignedCoachSummary.fromJson(
          json['assigned_coach'] as Map<String, dynamic>,
        ),
  lastSessionAt: json['last_session_at'] == null
      ? null
      : DateTime.parse(json['last_session_at'] as String),
  totalSessions: (json['total_sessions'] as num?)?.toInt() ?? 0,
  attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
  latestProgress: json['latest_progress'] == null
      ? null
      : LatestProgress.fromJson(
          json['latest_progress'] as Map<String, dynamic>,
        ),
  outstandingAmount: (json['outstanding_amount'] as num?)?.toInt() ?? 0,
  outstandingCount: (json['outstanding_count'] as num?)?.toInt() ?? 0,
  oldestOutstandingAt: json['oldest_outstanding_at'] == null
      ? null
      : DateTime.parse(json['oldest_outstanding_at'] as String),
);

Map<String, dynamic> _$$AdminStudentRosterItemImplToJson(
  _$AdminStudentRosterItemImpl instance,
) => <String, dynamic>{
  'student_profile_id': instance.studentProfileId,
  'full_name': instance.fullName,
  'age': instance.age,
  'photo_urls': instance.photoUrls,
  'enrollment': instance.enrollment,
  'assigned_coach': instance.assignedCoach,
  'last_session_at': instance.lastSessionAt?.toIso8601String(),
  'total_sessions': instance.totalSessions,
  'attendance_rate': instance.attendanceRate,
  'latest_progress': instance.latestProgress,
  'outstanding_amount': instance.outstandingAmount,
  'outstanding_count': instance.outstandingCount,
  'oldest_outstanding_at': instance.oldestOutstandingAt?.toIso8601String(),
};

_$AssignedCoachSummaryImpl _$$AssignedCoachSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AssignedCoachSummaryImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String?,
);

Map<String, dynamic> _$$AssignedCoachSummaryImplToJson(
  _$AssignedCoachSummaryImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};
