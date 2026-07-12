// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_method.dart';

part 'payment_intent.freezed.dart';
part 'payment_intent.g.dart';

@freezed
class PaymentIntent with _$PaymentIntent {
  const factory PaymentIntent({
    @JsonKey(name: 'purchase_id') required int purchaseId,
    required String status,
    required String provider,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'amount_base') required int amountBase,
    @JsonKey(name: 'fee_amount') required int feeAmount,
    @JsonKey(name: 'amount_total') required int amountTotal,
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'qr_string') String? qrString,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
    @JsonKey(name: 'proof_upload_url') String? proofUploadUrl,
  }) = _PaymentIntent;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentFromJson(json);
}
