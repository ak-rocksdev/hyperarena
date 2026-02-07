// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_earnings_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizerSessionSettlementImpl _$$OrganizerSessionSettlementImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerSessionSettlementImpl(
  sessionId: json['session_id'] as String,
  title: json['title'] as String,
  date: DateTime.parse(json['date'] as String),
  grossRevenue: (json['gross_revenue'] as num).toInt(),
  organizerFee: (json['organizer_fee'] as num?)?.toInt() ?? 0,
  estimatedCost: (json['estimated_cost'] as num?)?.toInt() ?? 0,
  netRevenue: (json['net_revenue'] as num).toInt(),
  settlementStatus:
      $enumDecodeNullable(
        _$SessionSettlementStatusEnumMap,
        json['settlement_status'],
      ) ??
      SessionSettlementStatus.pending,
);

Map<String, dynamic> _$$OrganizerSessionSettlementImplToJson(
  _$OrganizerSessionSettlementImpl instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'title': instance.title,
  'date': instance.date.toIso8601String(),
  'gross_revenue': instance.grossRevenue,
  'organizer_fee': instance.organizerFee,
  'estimated_cost': instance.estimatedCost,
  'net_revenue': instance.netRevenue,
  'settlement_status':
      _$SessionSettlementStatusEnumMap[instance.settlementStatus]!,
};

const _$SessionSettlementStatusEnumMap = {
  SessionSettlementStatus.pending: 'pending',
  SessionSettlementStatus.cleared: 'cleared',
  SessionSettlementStatus.paidOut: 'paidOut',
};

_$OrganizerEarningsSummaryImpl _$$OrganizerEarningsSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$OrganizerEarningsSummaryImpl(
  availableBalance: (json['available_balance'] as num?)?.toInt() ?? 0,
  pendingBalance: (json['pending_balance'] as num?)?.toInt() ?? 0,
  paidOutThisMonth: (json['paid_out_this_month'] as num?)?.toInt() ?? 0,
  settlements:
      (json['settlements'] as List<dynamic>?)
          ?.map(
            (e) =>
                OrganizerSessionSettlement.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrganizerEarningsSummaryImplToJson(
  _$OrganizerEarningsSummaryImpl instance,
) => <String, dynamic>{
  'available_balance': instance.availableBalance,
  'pending_balance': instance.pendingBalance,
  'paid_out_this_month': instance.paidOutThisMonth,
  'settlements': instance.settlements,
};
