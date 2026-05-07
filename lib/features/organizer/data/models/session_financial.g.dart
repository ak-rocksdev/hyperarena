// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_financial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionFinancialImpl _$$SessionFinancialImplFromJson(
  Map<String, dynamic> json,
) => _$SessionFinancialImpl(
  revenue: FinancialSide.fromJson(json['revenue'] as Map<String, dynamic>),
  cost: FinancialSide.fromJson(json['cost'] as Map<String, dynamic>),
  net: FinancialNet.fromJson(json['net'] as Map<String, dynamic>),
  currency: json['currency'] as String? ?? 'IDR',
);

Map<String, dynamic> _$$SessionFinancialImplToJson(
  _$SessionFinancialImpl instance,
) => <String, dynamic>{
  'revenue': instance.revenue,
  'cost': instance.cost,
  'net': instance.net,
  'currency': instance.currency,
};

_$FinancialSideImpl _$$FinancialSideImplFromJson(Map<String, dynamic> json) =>
    _$FinancialSideImpl(
      total: (json['total'] as num?)?.toInt() ?? 0,
      systemTracked: json['system_tracked'] == null
          ? const SystemTrackedBlock()
          : SystemTrackedBlock.fromJson(
              json['system_tracked'] as Map<String, dynamic>,
            ),
      custom: json['custom'] == null
          ? const CustomBlock()
          : CustomBlock.fromJson(json['custom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FinancialSideImplToJson(_$FinancialSideImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'system_tracked': instance.systemTracked,
      'custom': instance.custom,
    };

_$SystemTrackedBlockImpl _$$SystemTrackedBlockImplFromJson(
  Map<String, dynamic> json,
) => _$SystemTrackedBlockImpl(
  total: (json['total'] as num?)?.toInt() ?? 0,
  streams:
      (json['streams'] as List<dynamic>?)
          ?.map((e) => FinancialStream.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FinancialStream>[],
);

Map<String, dynamic> _$$SystemTrackedBlockImplToJson(
  _$SystemTrackedBlockImpl instance,
) => <String, dynamic>{'total': instance.total, 'streams': instance.streams};

_$FinancialStreamImpl _$$FinancialStreamImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialStreamImpl(
  key: json['key'] as String,
  amount: (json['amount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$FinancialStreamImplToJson(
  _$FinancialStreamImpl instance,
) => <String, dynamic>{'key': instance.key, 'amount': instance.amount};

_$CustomBlockImpl _$$CustomBlockImplFromJson(Map<String, dynamic> json) =>
    _$CustomBlockImpl(
      total: (json['total'] as num?)?.toInt() ?? 0,
      entries:
          (json['entries'] as List<dynamic>?)
              ?.map((e) => FinancialEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FinancialEntry>[],
    );

Map<String, dynamic> _$$CustomBlockImplToJson(_$CustomBlockImpl instance) =>
    <String, dynamic>{'total': instance.total, 'entries': instance.entries};

_$FinancialEntryImpl _$$FinancialEntryImplFromJson(Map<String, dynamic> json) =>
    _$FinancialEntryImpl(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      recordedByName: json['recorded_by_name'] as String?,
      category: json['category'] == null
          ? null
          : FinancialEntryCategory.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
      student: json['student'] == null
          ? null
          : FinancialEntryStudent.fromJson(
              json['student'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$FinancialEntryImplToJson(
  _$FinancialEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'notes': instance.notes,
  'created_at': instance.createdAt?.toIso8601String(),
  'recorded_by_name': instance.recordedByName,
  'category': instance.category,
  'student': instance.student,
};

_$FinancialEntryCategoryImpl _$$FinancialEntryCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialEntryCategoryImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  icon: json['icon'] as String?,
  isArchived: json['is_archived'] as bool? ?? false,
);

Map<String, dynamic> _$$FinancialEntryCategoryImplToJson(
  _$FinancialEntryCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'is_archived': instance.isArchived,
};

_$FinancialEntryStudentImpl _$$FinancialEntryStudentImplFromJson(
  Map<String, dynamic> json,
) => _$FinancialEntryStudentImpl(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
);

Map<String, dynamic> _$$FinancialEntryStudentImplToJson(
  _$FinancialEntryStudentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
};

_$FinancialNetImpl _$$FinancialNetImplFromJson(Map<String, dynamic> json) =>
    _$FinancialNetImpl(
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      marginPercent: (json['margin_percent'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FinancialNetImplToJson(_$FinancialNetImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'margin_percent': instance.marginPercent,
    };
