// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout_balance.freezed.dart';
part 'coach_payout_balance.g.dart';

/// Cumulative (all-months) wallet balance. Unlike [CoachPayoutSummary] which is
/// per-period, this drives the always-visible hero / chips / withdraw CTA.
///
/// `outstandingCents` is "withdrawable now" — pending, unrequested, and NOT in a
/// period that already has an active request (design K1). So it is not a plain
/// sum of each month's `summary.pendingCents`.
@freezed
class CoachPayoutBalance with _$CoachPayoutBalance {
  const factory CoachPayoutBalance({
    @JsonKey(name: 'outstanding_cents') @Default(0) int outstandingCents,
    @JsonKey(name: 'requested_cents') @Default(0) int requestedCents,
    @JsonKey(name: 'approved_cents') @Default(0) int approvedCents,
    @JsonKey(name: 'paid_cents') @Default(0) int paidCents,
    @JsonKey(name: 'outstanding_session_count')
    @Default(0)
    int outstandingSessionCount,
    @JsonKey(name: 'outstanding_periods')
    @Default(<String>[])
    List<String> outstandingPeriods,
  }) = _CoachPayoutBalance;

  const CoachPayoutBalance._();

  /// "Diproses" chip — money out of the coach's hands (requested or approved).
  int get diprosesCents => requestedCents + approvedCents;

  bool get canWithdraw => outstandingCents > 0;

  /// True if the coach has ANY lifetime payout activity — distinguishes the
  /// "all withdrawn" hero state from the "never earned" state.
  bool get hasAnyActivity =>
      outstandingCents + requestedCents + approvedCents + paidCents > 0;

  factory CoachPayoutBalance.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutBalanceFromJson(json);
}
