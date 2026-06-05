// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';

part 'payout_request.freezed.dart';
part 'payout_request.g.dart';

@freezed
class PayoutRequest with _$PayoutRequest {
  const factory PayoutRequest({
    required int id,
    required String period,
    @JsonKey(name: 'total_amount_cents') required int totalAmountCents,
    required String status, // 'pending'|'approved'|'rejected'|'cancelled'
    @JsonKey(name: 'requested_at') required DateTime requestedAt,
    @JsonKey(name: 'processed_at') DateTime? processedAt,
    @JsonKey(name: 'rejection_note') String? rejectionNote,
    /// Linked Payout list (eager-loaded by show endpoint, summary fields only
    /// on list). Counted in MVP for "X sesi" display in the History row.
    @Default([]) List<CoachPayout> payouts,
    @JsonKey(name: 'processed_by') Map<String, dynamic>? processedBy,
  }) = _PayoutRequest;

  const PayoutRequest._();

  int get linkedSessionCount => payouts.length;

  factory PayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestFromJson(json);
}
