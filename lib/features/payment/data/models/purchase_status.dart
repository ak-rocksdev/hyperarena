// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_status.freezed.dart';
part 'purchase_status.g.dart';

@freezed
class PurchaseStatus with _$PurchaseStatus {
  const factory PurchaseStatus({
    @JsonKey(name: 'purchase_id') required int purchaseId,
    required String status,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
  }) = _PurchaseStatus;

  factory PurchaseStatus.fromJson(Map<String, dynamic> json) =>
      _$PurchaseStatusFromJson(json);
}
