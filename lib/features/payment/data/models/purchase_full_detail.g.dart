// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_full_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseFullDetailImpl _$$PurchaseFullDetailImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseFullDetailImpl(
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
  vaNumber: json['va_number'] as String?,
  vaBank: json['va_bank'] as String?,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  paymentProofPath: json['payment_proof_path'] as String?,
  tenant: json['tenant'] == null
      ? null
      : DetailTenant.fromJson(json['tenant'] as Map<String, dynamic>),
  session: json['session'] == null
      ? null
      : DetailSession.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PurchaseFullDetailImplToJson(
  _$PurchaseFullDetailImpl instance,
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
  'va_number': instance.vaNumber,
  'va_bank': instance.vaBank,
  'expires_at': instance.expiresAt?.toIso8601String(),
  'payment_proof_path': instance.paymentProofPath,
  'tenant': instance.tenant,
  'session': instance.session,
};

_$DetailTenantImpl _$$DetailTenantImplFromJson(Map<String, dynamic> json) =>
    _$DetailTenantImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$$DetailTenantImplToJson(_$DetailTenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_$DetailSessionImpl _$$DetailSessionImplFromJson(Map<String, dynamic> json) =>
    _$DetailSessionImpl(
      id: (json['id'] as num).toInt(),
      displayTitle: json['display_title'] as String?,
      startAt: json['start_at'] == null
          ? null
          : DateTime.parse(json['start_at'] as String),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      venue: json['venue'] == null
          ? null
          : DetailVenue.fromJson(json['venue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DetailSessionImplToJson(_$DetailSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_title': instance.displayTitle,
      'start_at': instance.startAt?.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'venue': instance.venue,
    };

_$DetailVenueImpl _$$DetailVenueImplFromJson(Map<String, dynamic> json) =>
    _$DetailVenueImpl(
      name: json['name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$DetailVenueImplToJson(_$DetailVenueImpl instance) =>
    <String, dynamic>{'name': instance.name, 'address': instance.address};

_$RebookEligibilityImpl _$$RebookEligibilityImplFromJson(
  Map<String, dynamic> json,
) => _$RebookEligibilityImpl(
  eligible: json['eligible'] as bool,
  sessionId: (json['session_id'] as num?)?.toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$$RebookEligibilityImplToJson(
  _$RebookEligibilityImpl instance,
) => <String, dynamic>{
  'eligible': instance.eligible,
  'session_id': instance.sessionId,
  'reason': instance.reason,
};

_$PurchaseDetailResponseImpl _$$PurchaseDetailResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseDetailResponseImpl(
  purchase: PurchaseFullDetail.fromJson(
    json['purchase'] as Map<String, dynamic>,
  ),
  rebookEligibility: RebookEligibility.fromJson(
    json['rebook_eligibility'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$PurchaseDetailResponseImplToJson(
  _$PurchaseDetailResponseImpl instance,
) => <String, dynamic>{
  'purchase': instance.purchase,
  'rebook_eligibility': instance.rebookEligibility,
};
