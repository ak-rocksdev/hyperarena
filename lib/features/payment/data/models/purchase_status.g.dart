// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseStatusImpl _$$PurchaseStatusImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseStatusImpl(
      purchaseId: (json['purchase_id'] as num).toInt(),
      status: json['status'] as String,
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
    );

Map<String, dynamic> _$$PurchaseStatusImplToJson(
  _$PurchaseStatusImpl instance,
) => <String, dynamic>{
  'purchase_id': instance.purchaseId,
  'status': instance.status,
  'paid_at': instance.paidAt?.toIso8601String(),
};
