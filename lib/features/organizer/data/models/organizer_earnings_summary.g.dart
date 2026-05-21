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
  pendingPlayerBalance: (json['pending_player_balance'] as num?)?.toInt() ?? 0,
  pendingVenueBalance: (json['pending_venue_balance'] as num?)?.toInt() ?? 0,
  disputeHoldBalance: (json['dispute_hold_balance'] as num?)?.toInt() ?? 0,
  grossRevenue: (json['gross_revenue'] as num?)?.toInt(),
  totalExpenses: (json['total_expenses'] as num?)?.toInt(),
  netRevenueThisPeriod: (json['net_revenue_this_period'] as num?)?.toInt(),
  sessionCount: (json['session_count'] as num?)?.toInt(),
  prevPeriodNet: (json['prev_period_net'] as num?)?.toInt(),
  weeklyChart:
      (json['weekly_chart'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [],
  expenseBreakdown:
      (json['expense_breakdown'] as List<dynamic>?)
          ?.map((e) => ExpenseCategory.fromJson(e as Map<String, dynamic>))
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
  'pending_player_balance': instance.pendingPlayerBalance,
  'pending_venue_balance': instance.pendingVenueBalance,
  'dispute_hold_balance': instance.disputeHoldBalance,
  'gross_revenue': instance.grossRevenue,
  'total_expenses': instance.totalExpenses,
  'net_revenue_this_period': instance.netRevenueThisPeriod,
  'session_count': instance.sessionCount,
  'prev_period_net': instance.prevPeriodNet,
  'weekly_chart': instance.weeklyChart,
  'expense_breakdown': instance.expenseBreakdown,
};

_$ExpenseCategoryImpl _$$ExpenseCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseCategoryImpl(
  label: json['label'] as String,
  subtitle: json['subtitle'] as String?,
  amount: (json['amount'] as num).toInt(),
  colorHex: json['color_hex'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$$ExpenseCategoryImplToJson(
  _$ExpenseCategoryImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'subtitle': instance.subtitle,
  'amount': instance.amount,
  'color_hex': instance.colorHex,
  'icon': instance.icon,
};
