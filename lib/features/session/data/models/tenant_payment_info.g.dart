// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_payment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantPaymentInfoImpl _$$TenantPaymentInfoImplFromJson(
  Map<String, dynamic> json,
) => _$TenantPaymentInfoImpl(
  bankName: json['bank_name'] as String? ?? '',
  accountNumber: json['account_number'] as String? ?? '',
  accountHolder: json['account_holder'] as String? ?? '',
  paymentInstructions: json['payment_instructions'] as String?,
);

Map<String, dynamic> _$$TenantPaymentInfoImplToJson(
  _$TenantPaymentInfoImpl instance,
) => <String, dynamic>{
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder': instance.accountHolder,
  'payment_instructions': instance.paymentInstructions,
};
