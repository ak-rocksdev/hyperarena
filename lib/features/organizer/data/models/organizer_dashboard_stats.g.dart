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
  totalUnpaidAmount: (json['total_unpaid_amount'] as num?)?.toInt() ?? 0,
  revenueCollectedToday:
      (json['revenue_collected_today'] as num?)?.toInt() ?? 0,
  revenueExpectedToday: (json['revenue_expected_today'] as num?)?.toInt() ?? 0,
  lastMonthEarnings: (json['last_month_earnings'] as num?)?.toInt(),
  sessionsThisMonth: (json['sessions_this_month'] as num?)?.toInt(),
  coachesActiveToday: (json['coaches_active_today'] as num?)?.toInt(),
  coachesTotal: (json['coaches_total'] as num?)?.toInt(),
  playersBookedToday: (json['players_booked_today'] as num?)?.toInt(),
  hoursOnCourtToday: (json['hours_on_court_today'] as num?)?.toInt(),
  unpaidMemberCount: (json['unpaid_member_count'] as num?)?.toInt(),
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
  'total_unpaid_amount': instance.totalUnpaidAmount,
  'revenue_collected_today': instance.revenueCollectedToday,
  'revenue_expected_today': instance.revenueExpectedToday,
  'last_month_earnings': instance.lastMonthEarnings,
  'sessions_this_month': instance.sessionsThisMonth,
  'coaches_active_today': instance.coachesActiveToday,
  'coaches_total': instance.coachesTotal,
  'players_booked_today': instance.playersBookedToday,
  'hours_on_court_today': instance.hoursOnCourtToday,
  'unpaid_member_count': instance.unpaidMemberCount,
};
