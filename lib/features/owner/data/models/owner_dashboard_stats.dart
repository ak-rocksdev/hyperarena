import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_dashboard_stats.freezed.dart';
part 'owner_dashboard_stats.g.dart';

@freezed
class OwnerDashboardStats with _$OwnerDashboardStats {
  const factory OwnerDashboardStats({
    @Default(0) int bookingsToday,
    @Default(0) int pendingConfirmations,
    @Default(0) int todayRevenue,
    @Default(0) int monthlyRevenue,
    @Default(0.0) double occupancyRate,
  }) = _OwnerDashboardStats;

  factory OwnerDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardStatsFromJson(json);
}
