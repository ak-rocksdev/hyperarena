// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizerDashboardStatsImpl _$$OrganizerDashboardStatsImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerDashboardStatsImpl(
  sessionsToday: (json['sessions_today'] as num?)?.toInt() ?? 0,
  sessionsNext7Days: (json['sessions_next7_days'] as num?)?.toInt() ?? 0,
  pendingPayments: (json['pending_payments'] as num?)?.toInt() ?? 0,
  averageParticipants:
      (json['average_participants'] as num?)?.toDouble() ?? 0.0,
  averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
  monthlyEarnings: (json['monthly_earnings'] as num?)?.toInt() ?? 0,
  atRiskSessions: (json['at_risk_sessions'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$OrganizerDashboardStatsImplToJson(
  _$OrganizerDashboardStatsImpl instance,
) => <String, dynamic>{
  'sessions_today': instance.sessionsToday,
  'sessions_next7_days': instance.sessionsNext7Days,
  'pending_payments': instance.pendingPayments,
  'average_participants': instance.averageParticipants,
  'average_rating': instance.averageRating,
  'monthly_earnings': instance.monthlyEarnings,
  'at_risk_sessions': instance.atRiskSessions,
};
