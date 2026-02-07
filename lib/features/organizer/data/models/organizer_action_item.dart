import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_action_item.freezed.dart';
part 'organizer_action_item.g.dart';

enum OrganizerActionType {
  confirmPayment,
  waitlistDecision,
  sessionRisk,
  refundRequest,
  dispute,
  ownerIssue,
}

enum OrganizerActionSeverity { low, medium, high }

@freezed
class OrganizerActionItem with _$OrganizerActionItem {
  const factory OrganizerActionItem({
    required String id,
    required OrganizerActionType type,
    @Default(OrganizerActionSeverity.medium) OrganizerActionSeverity severity,
    required String title,
    required String subtitle,
    String? sessionId,
    String? participantId,
    DateTime? dueAt,
    String? actionableRoute,
  }) = _OrganizerActionItem;

  factory OrganizerActionItem.fromJson(Map<String, dynamic> json) =>
      _$OrganizerActionItemFromJson(json);
}
