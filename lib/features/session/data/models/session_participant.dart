import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'session_participant.freezed.dart';
part 'session_participant.g.dart';

enum SessionParticipantStatus {
  pendingPayment,
  confirmed,
  rejected,
  cancelledByPlayer,
  refunded,
  noShow,
  disputed,
}

@freezed
class SessionParticipant with _$SessionParticipant {
  const factory SessionParticipant({
    required String id,
    required String sessionId,
    required String playerId,
    required String playerName,
    String? bookingId,
    @Default(SessionParticipantStatus.pendingPayment)
    SessionParticipantStatus status,
    @Default(PaymentMethodType.qris) PaymentMethodType paymentMethod,
    @Default(0) int paidAmount,
    DateTime? paidAt,
    DateTime? confirmedAt,
    String? note,
    String? rejectionReason,
    String? refundReason,
    String? disputeReason,
    String? evidenceUrl,
    required DateTime joinedAt,
  }) = _SessionParticipant;

  factory SessionParticipant.fromJson(Map<String, dynamic> json) =>
      _$SessionParticipantFromJson(json);
}
