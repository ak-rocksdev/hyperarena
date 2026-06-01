// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_card_summary.freezed.dart';
part 'purchase_card_summary.g.dart';

@freezed
class PurchaseCardSummary with _$PurchaseCardSummary {
  const factory PurchaseCardSummary({
    required int id,
    required String reference,
    required String status,
    @JsonKey(name: 'amount_paid') required int amountPaid,
    @JsonKey(name: 'fee_amount') required int feeAmount,
    @JsonKey(name: 'amount_total') required int amountTotal,
    required String currency,
    @JsonKey(name: 'payment_provider') required String paymentProvider,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'product_label') String? productLabel,
    PurchaseTenantBrief? tenant,
    PurchaseSessionBrief? session,
  }) = _PurchaseCardSummary;

  factory PurchaseCardSummary.fromJson(Map<String, dynamic> json) =>
      _$PurchaseCardSummaryFromJson(json);
}

@freezed
class PurchaseTenantBrief with _$PurchaseTenantBrief {
  const factory PurchaseTenantBrief({
    required int id,
    required String name,
    required String slug,
    @JsonKey(name: 'logo_urls') Map<String, dynamic>? logoUrls,
    @JsonKey(name: 'brand_color') String? brandColor,
  }) = _PurchaseTenantBrief;

  factory PurchaseTenantBrief.fromJson(Map<String, dynamic> json) =>
      _$PurchaseTenantBriefFromJson(json);
}

@freezed
class PurchaseSessionBrief with _$PurchaseSessionBrief {
  const factory PurchaseSessionBrief({
    required int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
  }) = _PurchaseSessionBrief;

  factory PurchaseSessionBrief.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSessionBriefFromJson(json);
}
