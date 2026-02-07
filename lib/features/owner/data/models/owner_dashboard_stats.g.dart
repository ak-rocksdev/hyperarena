// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OwnerDashboardStatsImpl _$$OwnerDashboardStatsImplFromJson(
  Map<String, dynamic> json,
) => _$OwnerDashboardStatsImpl(
  bookingsToday: (json['bookings_today'] as num?)?.toInt() ?? 0,
  pendingConfirmations: (json['pending_confirmations'] as num?)?.toInt() ?? 0,
  todayRevenue: (json['today_revenue'] as num?)?.toInt() ?? 0,
  monthlyRevenue: (json['monthly_revenue'] as num?)?.toInt() ?? 0,
  occupancyRate: (json['occupancy_rate'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$OwnerDashboardStatsImplToJson(
  _$OwnerDashboardStatsImpl instance,
) => <String, dynamic>{
  'bookings_today': instance.bookingsToday,
  'pending_confirmations': instance.pendingConfirmations,
  'today_revenue': instance.todayRevenue,
  'monthly_revenue': instance.monthlyRevenue,
  'occupancy_rate': instance.occupancyRate,
};
