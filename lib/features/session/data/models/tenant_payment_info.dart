// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant_payment_info.freezed.dart';
part 'tenant_payment_info.g.dart';

@freezed
class TenantPaymentInfo with _$TenantPaymentInfo {
  const factory TenantPaymentInfo({
    @JsonKey(name: 'bank_name') required String bankName,
    @JsonKey(name: 'account_number') required String accountNumber,
    @JsonKey(name: 'account_holder') required String accountHolder,
    @JsonKey(name: 'payment_instructions') String? paymentInstructions,
  }) = _TenantPaymentInfo;

  factory TenantPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$TenantPaymentInfoFromJson(json);
}
