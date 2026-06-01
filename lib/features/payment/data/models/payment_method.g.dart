// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      key: json['key'] as String,
      provider: json['provider'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      feeAmount: (json['fee_amount'] as num).toInt(),
      bankDetails: json['bank_details'] == null
          ? null
          : ManualBankDetails.fromJson(
              json['bank_details'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'provider': instance.provider,
      'label': instance.label,
      'description': instance.description,
      'icon': instance.icon,
      'fee_amount': instance.feeAmount,
      'bank_details': instance.bankDetails,
    };

_$ManualBankDetailsImpl _$$ManualBankDetailsImplFromJson(
  Map<String, dynamic> json,
) => _$ManualBankDetailsImpl(
  bankName: json['bank_name'] as String,
  accountNumber: json['account_number'] as String,
  accountHolder: json['account_holder'] as String,
);

Map<String, dynamic> _$$ManualBankDetailsImplToJson(
  _$ManualBankDetailsImpl instance,
) => <String, dynamic>{
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'account_holder': instance.accountHolder,
};
