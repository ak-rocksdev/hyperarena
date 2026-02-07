// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodInfoImpl _$$PaymentMethodInfoImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentMethodInfoImpl(
  id: json['id'] as String,
  type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
  bankName: json['bank_name'] as String?,
  accountNumber: json['account_number'] as String?,
  accountHolderName: json['account_holder_name'] as String?,
  qrisImageUrl: json['qris_image_url'] as String?,
);

Map<String, dynamic> _$$PaymentMethodInfoImplToJson(
  _$PaymentMethodInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$PaymentMethodTypeEnumMap[instance.type]!,
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder_name': instance.accountHolderName,
  'qris_image_url': instance.qrisImageUrl,
};

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.qris: 'qris',
  PaymentMethodType.bankTransfer: 'bankTransfer',
};
