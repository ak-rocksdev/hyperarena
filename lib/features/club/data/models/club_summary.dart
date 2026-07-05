// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'club_summary.freezed.dart';
part 'club_summary.g.dart';

/// `GET /v1/admin/club/summary` (Issue 19.4) — drives the Klub tab hero +
/// vital stats strip on the organizer side.
@freezed
class ClubSummary with _$ClubSummary {
  const factory ClubSummary({
    required ClubTenant tenant,
    required ClubStats stats,
  }) = _ClubSummary;

  factory ClubSummary.fromJson(Map<String, dynamic> json) =>
      _$ClubSummaryFromJson(json);
}

@freezed
class ClubTenant with _$ClubTenant {
  const factory ClubTenant({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    required String slug,
    @JsonKey(name: 'sport_name') String? sportName,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
    String? city,
    @JsonKey(name: 'brand_color') String? brandColor,
  }) = _ClubTenant;

  factory ClubTenant.fromJson(Map<String, dynamic> json) =>
      _$ClubTenantFromJson(json);
}

@freezed
class ClubStats with _$ClubStats {
  const factory ClubStats({
    @JsonKey(name: 'total_members_count') @Default(0) int totalMembersCount,
    @JsonKey(name: 'active_members_count') @Default(0) int activeMembersCount,
    @JsonKey(name: 'active_coaches_count') @Default(0) int activeCoachesCount,
    @JsonKey(name: 'sessions_this_month') @Default(0) int sessionsThisMonth,
    @JsonKey(name: 'outstanding_total') @Default(0) int outstandingTotal,
    @JsonKey(name: 'outstanding_count') @Default(0) int outstandingCount,
  }) = _ClubStats;

  factory ClubStats.fromJson(Map<String, dynamic> json) =>
      _$ClubStatsFromJson(json);
}
