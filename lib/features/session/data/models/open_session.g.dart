// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionHealthImpl _$$SessionHealthImplFromJson(Map<String, dynamic> json) =>
    _$SessionHealthImpl(
      pendingPayments: (json['pending_payments'] as num?)?.toInt() ?? 0,
      isLowSignupRisk: json['is_low_signup_risk'] as bool? ?? false,
      isJoinDeadlineAtRisk: json['is_join_deadline_at_risk'] as bool? ?? false,
      trendScore: (json['trend_score'] as num?)?.toInt() ?? 0,
      pendingPaymentAmount:
          (json['pending_payment_amount'] as num?)?.toInt() ?? 0,
      slotsRemaining: (json['slots_remaining'] as num?)?.toInt() ?? 0,
      timeToStart: _healthDurationFromJson(
        (json['time_to_start'] as num?)?.toInt(),
      ),
    );

Map<String, dynamic> _$$SessionHealthImplToJson(_$SessionHealthImpl instance) =>
    <String, dynamic>{
      'pending_payments': instance.pendingPayments,
      'is_low_signup_risk': instance.isLowSignupRisk,
      'is_join_deadline_at_risk': instance.isJoinDeadlineAtRisk,
      'trend_score': instance.trendScore,
      'pending_payment_amount': instance.pendingPaymentAmount,
      'slots_remaining': instance.slotsRemaining,
      'time_to_start': _healthDurationToJson(instance.timeToStart),
    };

_$OpenSessionImpl _$$OpenSessionImplFromJson(Map<String, dynamic> json) =>
    _$OpenSessionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      sport: $enumDecode(_$SportEnumMap, json['sport']),
      hostId: json['host_id'] as String,
      hostName: json['host_name'] as String,
      venueName: json['venue_name'] as String,
      venueId: json['venue_id'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      currentPlayers: (json['current_players'] as num?)?.toInt() ?? 0,
      maxPlayers: (json['max_players'] as num).toInt(),
      minLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['min_level']),
      maxLevel: $enumDecodeNullable(_$LevelTierEnumMap, json['max_level']),
      pricePerPerson: (json['price_per_person'] as num).toInt(),
      description: json['description'] as String?,
      participantNames:
          (json['participant_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status:
          $enumDecodeNullable(_$OpenSessionStatusEnumMap, json['status']) ??
          OpenSessionStatus.open,
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
      organizerFeePerPerson: (json['organizer_fee_per_person'] as num?)
          ?.toInt(),
      settlementStatus:
          $enumDecodeNullable(
            _$SessionSettlementStatusEnumMap,
            json['settlement_status'],
          ) ??
          SessionSettlementStatus.pending,
      health: json['health'] == null
          ? const SessionHealth()
          : SessionHealth.fromJson(json['health'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpenSessionImplToJson(_$OpenSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sport': _$SportEnumMap[instance.sport]!,
      'host_id': instance.hostId,
      'host_name': instance.hostName,
      'venue_name': instance.venueName,
      'venue_id': instance.venueId,
      'date': instance.date.toIso8601String(),
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'current_players': instance.currentPlayers,
      'max_players': instance.maxPlayers,
      'min_level': _$LevelTierEnumMap[instance.minLevel],
      'max_level': _$LevelTierEnumMap[instance.maxLevel],
      'price_per_person': instance.pricePerPerson,
      'description': instance.description,
      'participant_names': instance.participantNames,
      'status': _$OpenSessionStatusEnumMap[instance.status]!,
      'join_deadline': instance.joinDeadline?.toIso8601String(),
      'pricing_model': _$SessionPricingModelEnumMap[instance.pricingModel]!,
      'visibility': _$SessionVisibilityEnumMap[instance.visibility]!,
      'court_cost': instance.courtCost,
      'coach_cost': instance.coachCost,
      'organizer_fee_per_person': instance.organizerFeePerPerson,
      'settlement_status':
          _$SessionSettlementStatusEnumMap[instance.settlementStatus]!,
      'health': instance.health,
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

const _$OpenSessionStatusEnumMap = {
  OpenSessionStatus.open: 'open',
  OpenSessionStatus.full: 'full',
  OpenSessionStatus.confirmed: 'confirmed',
  OpenSessionStatus.cancelled: 'cancelled',
  OpenSessionStatus.completed: 'completed',
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

const _$SessionSettlementStatusEnumMap = {
  SessionSettlementStatus.pending: 'pending',
  SessionSettlementStatus.cleared: 'cleared',
  SessionSettlementStatus.paidOut: 'paidOut',
};
