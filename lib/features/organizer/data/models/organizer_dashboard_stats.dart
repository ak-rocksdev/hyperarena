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
    @Default(0) int totalUnpaidAmount,
    @Default(0) int revenueCollectedToday,
    @Default(0) int revenueExpectedToday,

    // ── Dashboard v2 fields (spec: docs/PRD-organizer-dashboard-be-fields.md) ──
    // Nullable on purpose: BE may not return them yet. UI hides
    // corresponding tiles when null instead of showing zeros.
    int? lastMonthEarnings,
    int? sessionsThisMonth,
    int? coachesActiveToday,
    int? coachesTotal,
    int? playersBookedToday,
    int? hoursOnCourtToday,
    int? unpaidMemberCount,
  }) = _OrganizerDashboardStats;

  factory OrganizerDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$OrganizerDashboardStatsFromJson(json);
}
