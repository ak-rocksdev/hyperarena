// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_card_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseCardSummaryImpl _$$PurchaseCardSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseCardSummaryImpl(
  id: (json['id'] as num).toInt(),
  reference: json['reference'] as String,
  status: json['status'] as String,
  amountPaid: (json['amount_paid'] as num).toInt(),
  feeAmount: (json['fee_amount'] as num).toInt(),
  amountTotal: (json['amount_total'] as num).toInt(),
  currency: json['currency'] as String,
  paymentProvider: json['payment_provider'] as String,
  paymentMethod: json['payment_method'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  confirmedAt: json['confirmed_at'] == null
      ? null
      : DateTime.parse(json['confirmed_at'] as String),
  productLabel: json['product_label'] as String?,
  tenant: json['tenant'] == null
      ? null
      : PurchaseTenantBrief.fromJson(json['tenant'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : PurchaseSessionBrief.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PurchaseCardSummaryImplToJson(
  _$PurchaseCardSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'reference': instance.reference,
  'status': instance.status,
  'amount_paid': instance.amountPaid,
  'fee_amount': instance.feeAmount,
  'amount_total': instance.amountTotal,
  'currency': instance.currency,
  'payment_provider': instance.paymentProvider,
  'payment_method': instance.paymentMethod,
  'created_at': instance.createdAt?.toIso8601String(),
  'confirmed_at': instance.confirmedAt?.toIso8601String(),
  'product_label': instance.productLabel,
  'tenant': instance.tenant,
  'session': instance.session,
};

_$PurchaseTenantBriefImpl _$$PurchaseTenantBriefImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseTenantBriefImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  logoUrls: json['logo_urls'] as Map<String, dynamic>?,
  brandColor: json['brand_color'] as String?,
);

Map<String, dynamic> _$$PurchaseTenantBriefImplToJson(
  _$PurchaseTenantBriefImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'logo_urls': instance.logoUrls,
  'brand_color': instance.brandColor,
};

_$PurchaseSessionBriefImpl _$$PurchaseSessionBriefImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseSessionBriefImpl(
  id: (json['id'] as num).toInt(),
  displayTitle: json['display_title'] as String?,
  startAt: json['start_at'] == null
      ? null
      : DateTime.parse(json['start_at'] as String),
);

Map<String, dynamic> _$$PurchaseSessionBriefImplToJson(
  _$PurchaseSessionBriefImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'display_title': instance.displayTitle,
  'start_at': instance.startAt?.toIso8601String(),
};
