// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method.freezed.dart';
part 'payment_method.g.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String key,
    required String provider,
    required String label,
    required String description,
    required String icon,
    @JsonKey(name: 'fee_amount') required int feeAmount,
    @JsonKey(name: 'bank_details') ManualBankDetails? bankDetails,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

@freezed
class ManualBankDetails with _$ManualBankDetails {
  const factory ManualBankDetails({
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_holder') required String accountHolder,
  }) = _ManualBankDetails;

  factory ManualBankDetails.fromJson(Map<String, dynamic> json) =>
      _$ManualBankDetailsFromJson(json);
}
