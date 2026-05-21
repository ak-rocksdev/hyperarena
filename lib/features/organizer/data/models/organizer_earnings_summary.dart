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
    @Default(0) int pendingPlayerBalance,
    @Default(0) int pendingVenueBalance,
    @Default(0) int disputeHoldBalance,

    // ── Earnings v2 fields (spec: docs/PRD-organizer-dashboard-be-fields.md) ──
    // All nullable — UI hides corresponding sections when BE has not yet
    // populated them. Once BE deploys, the P&L card + expense breakdown +
    // bar chart + delta caption light up automatically.
    int? grossRevenue,
    int? totalExpenses,
    int? netRevenueThisPeriod,
    int? sessionCount,
    int? prevPeriodNet,
    @Default([]) List<double> weeklyChart,
    @Default([]) List<ExpenseCategory> expenseBreakdown,
  }) = _OrganizerEarningsSummary;

  factory OrganizerEarningsSummary.fromJson(Map<String, dynamic> json) =>
      _$OrganizerEarningsSummaryFromJson(json);
}

/// One row in the "Rincian biaya" expense breakdown. BE provides label +
/// subtitle + amount; optional [colorHex] and [icon] (emoji or icon name)
/// let BE override the client default for that category.
@freezed
class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    required String label,
    String? subtitle,
    required int amount,

    /// 7-char hex like `#EF4444` — optional override. When null, the client
    /// picks a color from a fixed rotation based on row index.
    String? colorHex,

    /// Emoji or icon-name override. When null, the client falls back to a
    /// generic receipt glyph.
    String? icon,
  }) = _ExpenseCategory;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
}
