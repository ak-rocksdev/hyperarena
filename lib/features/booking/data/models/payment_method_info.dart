import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'payment_method_info.freezed.dart';
part 'payment_method_info.g.dart';

@freezed
class PaymentMethodInfo with _$PaymentMethodInfo {
  const factory PaymentMethodInfo({
    required String id,
    required PaymentMethodType type,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? qrisImageUrl,
  }) = _PaymentMethodInfo;

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodInfoFromJson(json);
}
