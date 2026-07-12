// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_session_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceSessionDetailImpl _$$MarketplaceSessionDetailImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceSessionDetailImpl(
  session: MarketplaceSession.fromJson(json['session'] as Map<String, dynamic>),
  pricing: SessionPricing.fromJson(json['pricing'] as Map<String, dynamic>),
  productLabel: json['product_label'] as String?,
  userStatus: UserSessionStatus.fromJson(
    json['user_status'] as Map<String, dynamic>,
  ),
  tenantPayment: TenantPaymentInfo.fromJson(
    json['tenant_payment'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$MarketplaceSessionDetailImplToJson(
  _$MarketplaceSessionDetailImpl instance,
) => <String, dynamic>{
  'session': instance.session,
  'pricing': instance.pricing,
  'product_label': instance.productLabel,
  'user_status': instance.userStatus,
  'tenant_payment': instance.tenantPayment,
};

_$UserSessionStatusImpl _$$UserSessionStatusImplFromJson(
  Map<String, dynamic> json,
) => _$UserSessionStatusImpl(
  creditBalance: (json['credit_balance'] as num?)?.toInt() ?? 0,
  isBooked: json['is_booked'] as bool? ?? false,
  bookingId: nullableIdFromJson(json['booking_id']),
  paymentStatus: json['payment_status'] as String?,
  canReview: json['can_review'] as bool? ?? false,
  reviewBlockedReason: json['review_blocked_reason'] as String?,
  priorFailedPurchase: json['prior_failed_purchase'] == null
      ? null
      : PriorFailedPurchase.fromJson(
          json['prior_failed_purchase'] as Map<String, dynamic>,
        ),
  pendingPurchase: json['pending_purchase'] == null
      ? null
      : PendingPurchase.fromJson(
          json['pending_purchase'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$UserSessionStatusImplToJson(
  _$UserSessionStatusImpl instance,
) => <String, dynamic>{
  'credit_balance': instance.creditBalance,
  'is_booked': instance.isBooked,
  'booking_id': instance.bookingId,
  'payment_status': instance.paymentStatus,
  'can_review': instance.canReview,
  'review_blocked_reason': instance.reviewBlockedReason,
  'prior_failed_purchase': instance.priorFailedPurchase,
  'pending_purchase': instance.pendingPurchase,
};

_$PriorFailedPurchaseImpl _$$PriorFailedPurchaseImplFromJson(
  Map<String, dynamic> json,
) => _$PriorFailedPurchaseImpl(
  purchaseId: (json['purchase_id'] as num).toInt(),
  status: PriorFailedPurchaseStatus.fromJson(json['status'] as String),
  failedAt: json['failed_at'] == null
      ? null
      : DateTime.parse(json['failed_at'] as String),
);

Map<String, dynamic> _$$PriorFailedPurchaseImplToJson(
  _$PriorFailedPurchaseImpl instance,
) => <String, dynamic>{
  'purchase_id': instance.purchaseId,
  'status': _statusToJson(instance.status),
  'failed_at': instance.failedAt?.toIso8601String(),
};

_$PendingPurchaseImpl _$$PendingPurchaseImplFromJson(
  Map<String, dynamic> json,
) => _$PendingPurchaseImpl(
  purchaseId: (json['purchase_id'] as num).toInt(),
  method: json['method'] as String,
  provider: json['provider'] as String,
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

Map<String, dynamic> _$$PendingPurchaseImplToJson(
  _$PendingPurchaseImpl instance,
) => <String, dynamic>{
  'purchase_id': instance.purchaseId,
  'method': instance.method,
  'provider': instance.provider,
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
