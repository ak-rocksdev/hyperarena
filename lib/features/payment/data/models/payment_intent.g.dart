// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentIntentImpl _$$PaymentIntentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentIntentImpl(
      purchaseId: (json['purchase_id'] as num).toInt(),
      status: json['status'] as String,
      provider: json['provider'] as String,
      paymentMethod: json['payment_method'] as String,
      amountBase: (json['amount_base'] as num).toInt(),
      feeAmount: (json['fee_amount'] as num).toInt(),
      amountTotal: (json['amount_total'] as num).toInt(),
      vaNumber: json['va_number'] as String?,
      vaBank: json['va_bank'] as String?,
      qrString: json['qr_string'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      bankDetails: json['bank_details'] == null
          ? null
          : ManualBankDetails.fromJson(
              json['bank_details'] as Map<String, dynamic>,
            ),
      proofUploadUrl: json['proof_upload_url'] as String?,
    );

Map<String, dynamic> _$$PaymentIntentImplToJson(_$PaymentIntentImpl instance) =>
    <String, dynamic>{
      'purchase_id': instance.purchaseId,
      'status': instance.status,
      'provider': instance.provider,
      'payment_method': instance.paymentMethod,
      'amount_base': instance.amountBase,
      'fee_amount': instance.feeAmount,
      'amount_total': instance.amountTotal,
      'va_number': instance.vaNumber,
      'va_bank': instance.vaBank,
      'qr_string': instance.qrString,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'bank_details': instance.bankDetails,
      'proof_upload_url': instance.proofUploadUrl,
    };
