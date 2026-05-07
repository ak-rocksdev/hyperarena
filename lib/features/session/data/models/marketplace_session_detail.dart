// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/tenant_payment_info.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

export 'package:hyperarena/features/session/data/models/open_session.dart' show SessionPricing, SessionPricingX;

part 'marketplace_session_detail.freezed.dart';
part 'marketplace_session_detail.g.dart';

@freezed
class MarketplaceSessionDetail with _$MarketplaceSessionDetail {
  const factory MarketplaceSessionDetail({
    required MarketplaceSession session,
    required SessionPricing pricing,
    /// Display label for the resolved product — appears next to the price
    /// in the join CTA (e.g. "Group Single"). Sibling of `pricing` on the
    /// wire because it's presentational, not part of the price contract.
    @JsonKey(name: 'product_label') String? productLabel,
    @JsonKey(name: 'user_status') required UserSessionStatus userStatus,
    @JsonKey(name: 'tenant_payment') required TenantPaymentInfo tenantPayment,
  }) = _MarketplaceSessionDetail;

  factory MarketplaceSessionDetail.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSessionDetailFromJson(json);
}

@freezed
class UserSessionStatus with _$UserSessionStatus {
  const factory UserSessionStatus({
    @JsonKey(name: 'credit_balance') @Default(0) int creditBalance,
    @JsonKey(name: 'is_booked') @Default(false) bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson) String? bookingId,
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'can_review') @Default(false) bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
  }) = _UserSessionStatus;

  factory UserSessionStatus.fromJson(Map<String, dynamic> json) =>
      _$UserSessionStatusFromJson(json);
}
