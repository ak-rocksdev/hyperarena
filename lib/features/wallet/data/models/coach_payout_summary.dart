// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout_summary.freezed.dart';
part 'coach_payout_summary.g.dart';

/// BE returns 4 amount buckets; the FE merges `requested + approved` into the
/// "Diproses" chip (§5.4 of spec) — both mean "out of coach's hands".
/// Invariant: `total_earned_cents == pendingCents + diprosesCents + paidCents`.
@freezed
class CoachPayoutSummary with _$CoachPayoutSummary {
  const factory CoachPayoutSummary({
    required String period,
    @JsonKey(name: 'total_earned_cents') @Default(0) int totalEarnedCents,
    @JsonKey(name: 'session_count') @Default(0) int sessionCount,
    @JsonKey(name: 'student_count') @Default(0) int studentCount,
    @JsonKey(name: 'pending_cents') @Default(0) int pendingCents,
    @JsonKey(name: 'requested_cents') @Default(0) int requestedCents,
    @JsonKey(name: 'approved_cents') @Default(0) int approvedCents,
    @JsonKey(name: 'paid_cents') @Default(0) int paidCents,
    @JsonKey(name: 'active_request_id') int? activeRequestId,
  }) = _CoachPayoutSummary;

  const CoachPayoutSummary._();

  int get diprosesCents => requestedCents + approvedCents;
  bool get hasActiveRequest => activeRequestId != null;
  bool get canRequestWithdrawal => pendingCents > 0 && !hasActiveRequest;

  factory CoachPayoutSummary.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutSummaryFromJson(json);
}
