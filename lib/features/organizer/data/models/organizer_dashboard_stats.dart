import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_dashboard_stats.freezed.dart';
part 'organizer_dashboard_stats.g.dart';

@freezed
class OrganizerDashboardStats with _$OrganizerDashboardStats {
  const factory OrganizerDashboardStats({
    @Default(0) int sessionsToday,
    @Default(0) int sessionsNext7Days,
    @Default(0) int pendingPayments,
    @Default(0.0) double averageParticipants,
    @Default(0.0) double averageRating,
    @Default(0) int monthlyEarnings,
    @Default(0) int atRiskSessions,
  }) = _OrganizerDashboardStats;

  factory OrganizerDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$OrganizerDashboardStatsFromJson(json);
}
