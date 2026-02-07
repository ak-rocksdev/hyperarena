// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateSessionDraftImpl _$$CreateSessionDraftImplFromJson(
  Map<String, dynamic> json,
) => _$CreateSessionDraftImpl(
  title: json['title'] as String?,
  description: json['description'] as String?,
  sport: $enumDecodeNullable(_$SportEnumMap, json['sport']),
  minLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['min_level']),
  maxLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['max_level']),
  venueId: json['venue_id'] as String?,
  venueName: json['venue_name'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  pricePerPerson: (json['price_per_person'] as num?)?.toInt(),
  minParticipants: (json['min_participants'] as num?)?.toInt() ?? 2,
  maxParticipants: (json['max_participants'] as num?)?.toInt() ?? 8,
  joinDeadline: json['join_deadline'] == null
      ? null
      : DateTime.parse(json['join_deadline'] as String),
  pricingModel:
      $enumDecodeNullable(
        _$SessionPricingModelEnumMap,
        json['pricing_model'],
      ) ??
      SessionPricingModel.margin,
  visibility:
      $enumDecodeNullable(_$SessionVisibilityEnumMap, json['visibility']) ??
      SessionVisibility.free,
  courtCost: (json['court_cost'] as num?)?.toInt(),
  coachCost: (json['coach_cost'] as num?)?.toInt(),
  organizerFeePerPerson: (json['organizer_fee_per_person'] as num?)?.toInt(),
  templateId: json['template_id'] as String?,
);

Map<String, dynamic> _$$CreateSessionDraftImplToJson(
  _$CreateSessionDraftImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'sport': _$SportEnumMap[instance.sport],
  'min_level': _$LevelTierEnumMap[instance.minLevel],
  'max_level': _$LevelTierEnumMap[instance.maxLevel],
  'venue_id': instance.venueId,
  'venue_name': instance.venueName,
  'date': instance.date?.toIso8601String(),
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'price_per_person': instance.pricePerPerson,
  'min_participants': instance.minParticipants,
  'max_participants': instance.maxParticipants,
  'join_deadline': instance.joinDeadline?.toIso8601String(),
  'pricing_model': _$SessionPricingModelEnumMap[instance.pricingModel]!,
  'visibility': _$SessionVisibilityEnumMap[instance.visibility]!,
  'court_cost': instance.courtCost,
  'coach_cost': instance.coachCost,
  'organizer_fee_per_person': instance.organizerFeePerPerson,
  'template_id': instance.templateId,
};

const _$SportEnumMap = {
  Sport.tennis: 'tennis',
  Sport.padel: 'padel',
  Sport.badminton: 'badminton',
  Sport.futsal: 'futsal',
  Sport.basketball: 'basketball',
  Sport.volleyball: 'volleyball',
  Sport.tableTennis: 'tableTennis',
};

const _$LevelTierEnumMap = {
  LevelTier.rookie: 'rookie',
  LevelTier.amateur: 'amateur',
  LevelTier.intermediate: 'intermediate',
  LevelTier.advanced: 'advanced',
  LevelTier.pro: 'pro',
};

const _$SessionPricingModelEnumMap = {
  SessionPricingModel.margin: 'margin',
  SessionPricingModel.transparent: 'transparent',
};

const _$SessionVisibilityEnumMap = {
  SessionVisibility.free: 'free',
  SessionVisibility.invitationOnly: 'invitationOnly',
  SessionVisibility.membersOnly: 'membersOnly',
};
