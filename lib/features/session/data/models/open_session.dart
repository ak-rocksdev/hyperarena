// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'open_session.freezed.dart';
part 'open_session.g.dart';

enum OpenSessionStatus { open, full, confirmed, cancelled, completed }

enum SessionPricingModel { margin, transparent }

enum SessionVisibility { free, invitationOnly, membersOnly }

enum SessionSettlementStatus { pending, cleared, paidOut }

Duration? _healthDurationFromJson(int? microseconds) =>
    microseconds == null ? null : Duration(microseconds: microseconds);
int? _healthDurationToJson(Duration? duration) => duration?.inMicroseconds;

@freezed
class SessionHealth with _$SessionHealth {
  const factory SessionHealth({
    @Default(0) int pendingPayments,
    @Default(false) bool isLowSignupRisk,
    @Default(false) bool isJoinDeadlineAtRisk,
    @Default(0) int trendScore,
    @Default(0) int pendingPaymentAmount,
    @Default(0) int slotsRemaining,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    Duration? timeToStart,
  }) = _SessionHealth;

  factory SessionHealth.fromJson(Map<String, dynamic> json) =>
      _$SessionHealthFromJson(json);
}

@freezed
class OpenSession with _$OpenSession {
  const factory OpenSession({
    required String id,
    required String title,
    required Sport sport,
    required String hostId,
    required String hostName,
    required String venueName,
    required String venueId,
    required DateTime date,
    required String startTime,
    required String endTime,
    @Default(0) int currentPlayers,
    @Default(1) int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    required int pricePerPerson,
    String? description,
    @Default([]) List<String> participantNames,
    @Default(OpenSessionStatus.open) OpenSessionStatus status,
    DateTime? joinDeadline,
    @Default(SessionPricingModel.margin) SessionPricingModel pricingModel,
    @Default(SessionVisibility.free) SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    @Default(SessionSettlementStatus.pending)
    SessionSettlementStatus settlementStatus,
    @Default(SessionHealth()) SessionHealth health,
  }) = _OpenSession;

  factory OpenSession.fromJson(Map<String, dynamic> json) =>
      _$OpenSessionFromJson(json);
}
