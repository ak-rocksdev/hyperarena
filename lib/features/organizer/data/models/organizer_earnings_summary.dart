import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

part 'organizer_earnings_summary.freezed.dart';
part 'organizer_earnings_summary.g.dart';

@freezed
class OrganizerSessionSettlement with _$OrganizerSessionSettlement {
  const factory OrganizerSessionSettlement({
    required String sessionId,
    required String title,
    required DateTime date,
    required int grossRevenue,
    @Default(0) int organizerFee,
    @Default(0) int estimatedCost,
    required int netRevenue,
    @Default(SessionSettlementStatus.pending)
    SessionSettlementStatus settlementStatus,
  }) = _OrganizerSessionSettlement;

  factory OrganizerSessionSettlement.fromJson(Map<String, dynamic> json) =>
      _$OrganizerSessionSettlementFromJson(json);
}

@freezed
class OrganizerEarningsSummary with _$OrganizerEarningsSummary {
  const factory OrganizerEarningsSummary({
    @Default(0) int availableBalance,
    @Default(0) int pendingBalance,
    @Default(0) int paidOutThisMonth,
    @Default([]) List<OrganizerSessionSettlement> settlements,
  }) = _OrganizerEarningsSummary;

  factory OrganizerEarningsSummary.fromJson(Map<String, dynamic> json) =>
      _$OrganizerEarningsSummaryFromJson(json);
}
