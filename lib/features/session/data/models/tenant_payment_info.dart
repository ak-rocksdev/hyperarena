// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_payment_info.freezed.dart';
part 'tenant_payment_info.g.dart';

@freezed
class TenantPaymentInfo with _$TenantPaymentInfo {
  const TenantPaymentInfo._();

  const factory TenantPaymentInfo({
    @JsonKey(name: 'bank_name') @Default('') String bankName,
    @JsonKey(name: 'account_number') @Default('') String accountNumber,
    @JsonKey(name: 'account_holder') @Default('') String accountHolder,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
  }) = _TenantPaymentInfo;

  factory TenantPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$TenantPaymentInfoFromJson(json);

  bool get isComplete =>
      bankName.isNotEmpty && accountNumber.isNotEmpty && accountHolder.isNotEmpty;
}
