// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_payout.freezed.dart';
part 'coach_payout.g.dart';

/// One row in the coach's per-session earnings list. Amount is in the
/// currency's smallest unit (IDR rupiah, MYR sen) — match `Formatters.formatCurrency`.
@freezed
class CoachPayout with _$CoachPayout {
  const factory CoachPayout({
    required int id,
    @JsonKey(name: 'session_id') int? sessionId,
    required int amount,
    required String currency,
    required String period,
    required String status, // 'pending' | 'approved' | 'paid'
    @JsonKey(name: 'request_id') int? requestId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    /// Server-side join shape: `session: { id, type, start_at, duration_minutes }`.
    @JsonKey(name: 'session') Map<String, dynamic>? sessionMeta,
  }) = _CoachPayout;

  factory CoachPayout.fromJson(Map<String, dynamic> json) =>
      _$CoachPayoutFromJson(json);
}
