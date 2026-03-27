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
  'user_status': instance.userStatus,
  'tenant_payment': instance.tenantPayment,
};

_$SessionPricingImpl _$$SessionPricingImplFromJson(Map<String, dynamic> json) =>
    _$SessionPricingImpl(
      productId: idFromJson(json['product_id']),
      price: (json['price'] as num).toInt(),
      currency: json['currency'] as String,
      label: json['label'] as String? ?? '',
    );

Map<String, dynamic> _$$SessionPricingImplToJson(
  _$SessionPricingImpl instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'price': instance.price,
  'currency': instance.currency,
  'label': instance.label,
};

_$UserSessionStatusImpl _$$UserSessionStatusImplFromJson(
  Map<String, dynamic> json,
) => _$UserSessionStatusImpl(
  creditBalance: (json['credit_balance'] as num?)?.toInt() ?? 0,
  isBooked: json['is_booked'] as bool? ?? false,
  bookingId: nullableIdFromJson(json['booking_id']),
);

Map<String, dynamic> _$$UserSessionStatusImplToJson(
  _$UserSessionStatusImpl instance,
) => <String, dynamic>{
  'credit_balance': instance.creditBalance,
  'is_booked': instance.isBooked,
  'booking_id': instance.bookingId,
};
