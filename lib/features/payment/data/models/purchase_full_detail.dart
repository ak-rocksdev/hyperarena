// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_full_detail.freezed.dart';
part 'purchase_full_detail.g.dart';

@freezed
class PurchaseFullDetail with _$PurchaseFullDetail {
  const factory PurchaseFullDetail({
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
    @JsonKey(name: 'va_number') String? vaNumber,
    @JsonKey(name: 'va_bank') String? vaBank,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    @JsonKey(name: 'payment_proof_path') String? paymentProofPath,
    DetailTenant? tenant,
    DetailSession? session,
  }) = _PurchaseFullDetail;

  factory PurchaseFullDetail.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFullDetailFromJson(json);
}

@freezed
class DetailTenant with _$DetailTenant {
  const factory DetailTenant({
    required int id,
    required String name,
    required String slug,
  }) = _DetailTenant;

  factory DetailTenant.fromJson(Map<String, dynamic> json) =>
      _$DetailTenantFromJson(json);
}

@freezed
class DetailSession with _$DetailSession {
  const factory DetailSession({
    required int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    DetailVenue? venue,
  }) = _DetailSession;

  factory DetailSession.fromJson(Map<String, dynamic> json) =>
      _$DetailSessionFromJson(json);
}

@freezed
class DetailVenue with _$DetailVenue {
  const factory DetailVenue({
    required String name,
    String? address,
  }) = _DetailVenue;

  factory DetailVenue.fromJson(Map<String, dynamic> json) =>
      _$DetailVenueFromJson(json);
}

@freezed
class RebookEligibility with _$RebookEligibility {
  const factory RebookEligibility({
    required bool eligible,
    @JsonKey(name: 'session_id') int? sessionId,
    String? reason,
  }) = _RebookEligibility;

  factory RebookEligibility.fromJson(Map<String, dynamic> json) =>
      _$RebookEligibilityFromJson(json);
}

@freezed
class PurchaseDetailResponse with _$PurchaseDetailResponse {
  const factory PurchaseDetailResponse({
    required PurchaseFullDetail purchase,
    @JsonKey(name: 'rebook_eligibility') required RebookEligibility rebookEligibility,
  }) = _PurchaseDetailResponse;

  factory PurchaseDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PurchaseDetailResponseFromJson(json);
}
