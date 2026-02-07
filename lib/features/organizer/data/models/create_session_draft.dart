import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

part 'create_session_draft.freezed.dart';
part 'create_session_draft.g.dart';

@freezed
class CreateSessionDraft with _$CreateSessionDraft {
  const factory CreateSessionDraft({
    String? title,
    String? description,
    Sport? sport,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    String? venueId,
    String? venueName,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? pricePerPerson,
    @Default(2) int minParticipants,
    @Default(8) int maxParticipants,
    DateTime? joinDeadline,
    @Default(SessionPricingModel.margin) SessionPricingModel pricingModel,
    @Default(SessionVisibility.free) SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    String? templateId,
  }) = _CreateSessionDraft;

  factory CreateSessionDraft.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionDraftFromJson(json);
}
