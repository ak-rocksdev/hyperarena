// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'session_join_response.freezed.dart';
part 'session_join_response.g.dart';

@freezed
class SessionJoinResponse with _$SessionJoinResponse {
  const factory SessionJoinResponse({
    required String status,
    @JsonKey(name: 'used_credit') required bool usedCredit,
    @JsonKey(name: 'credit_balance_after') int? creditBalanceAfter,
    @JsonKey(name: 'purchase_id') int? purchaseId,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    required String message,
    required JoinBookingInfo booking,
  }) = _SessionJoinResponse;

  factory SessionJoinResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionJoinResponseFromJson(json);
}

@freezed
class JoinBookingInfo with _$JoinBookingInfo {
  const factory JoinBookingInfo({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'session_id', fromJson: idFromJson) required String sessionId,
    @JsonKey(name: 'booked_at') required DateTime bookedAt,
  }) = _JoinBookingInfo;

  factory JoinBookingInfo.fromJson(Map<String, dynamic> json) =>
      _$JoinBookingInfoFromJson(json);
}
