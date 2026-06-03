// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_performance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachPerformanceImpl _$$CoachPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$CoachPerformanceImpl(
  earningsThisWeekCents: (json['earnings_this_week_cents'] as num).toInt(),
  earningsThisMonthCents: (json['earnings_this_month_cents'] as num).toInt(),
  sessionsThisWeek: (json['sessions_this_week'] as num).toInt(),
  sessionsThisMonth: (json['sessions_this_month'] as num).toInt(),
  activeStudentCount: (json['active_student_count'] as num).toInt(),
);

Map<String, dynamic> _$$CoachPerformanceImplToJson(
  _$CoachPerformanceImpl instance,
) => <String, dynamic>{
  'earnings_this_week_cents': instance.earningsThisWeekCents,
  'earnings_this_month_cents': instance.earningsThisMonthCents,
  'sessions_this_week': instance.sessionsThisWeek,
  'sessions_this_month': instance.sessionsThisMonth,
  'active_student_count': instance.activeStudentCount,
};
