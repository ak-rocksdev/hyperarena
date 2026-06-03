// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_card_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PurchaseCardSummary _$PurchaseCardSummaryFromJson(Map<String, dynamic> json) {
  return _PurchaseCardSummary.fromJson(json);
}

/// @nodoc
mixin _$PurchaseCardSummary {
  int get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid')
  int get amountPaid => throw _privateConstructorUsedError;
  @JsonKey(name: 'fee_amount')
  int get feeAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_total')
  int get amountTotal => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_provider')
  String get paymentProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_label')
  String? get productLabel => throw _privateConstructorUsedError;
  PurchaseTenantBrief? get tenant => throw _privateConstructorUsedError;
  PurchaseSessionBrief? get session => throw _privateConstructorUsedError;

  /// Serializes this PurchaseCardSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseCardSummaryCopyWith<PurchaseCardSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseCardSummaryCopyWith<$Res> {
  factory $PurchaseCardSummaryCopyWith(
    PurchaseCardSummary value,
    $Res Function(PurchaseCardSummary) then,
  ) = _$PurchaseCardSummaryCopyWithImpl<$Res, PurchaseCardSummary>;
  @useResult
  $Res call({
    int id,
    String reference,
    String status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    String currency,
    @JsonKey(name: 'payment_provider') String paymentProvider,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'product_label') String? productLabel,
    PurchaseTenantBrief? tenant,
    PurchaseSessionBrief? session,
  });

  $PurchaseTenantBriefCopyWith<$Res>? get tenant;
  $PurchaseSessionBriefCopyWith<$Res>? get session;
}

/// @nodoc
class _$PurchaseCardSummaryCopyWithImpl<$Res, $Val extends PurchaseCardSummary>
    implements $PurchaseCardSummaryCopyWith<$Res> {
  _$PurchaseCardSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? amountPaid = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? currency = null,
    Object? paymentProvider = null,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? productLabel = freezed,
    Object? tenant = freezed,
    Object? session = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            reference: null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            amountPaid: null == amountPaid
                ? _value.amountPaid
                : amountPaid // ignore: cast_nullable_to_non_nullable
                      as int,
            feeAmount: null == feeAmount
                ? _value.feeAmount
                : feeAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            amountTotal: null == amountTotal
                ? _value.amountTotal
                : amountTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentProvider: null == paymentProvider
                ? _value.paymentProvider
                : paymentProvider // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            productLabel: freezed == productLabel
                ? _value.productLabel
                : productLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
            tenant: freezed == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as PurchaseTenantBrief?,
            session: freezed == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as PurchaseSessionBrief?,
          )
          as $Val,
    );
  }

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseTenantBriefCopyWith<$Res>? get tenant {
    if (_value.tenant == null) {
      return null;
    }

    return $PurchaseTenantBriefCopyWith<$Res>(_value.tenant!, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseSessionBriefCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $PurchaseSessionBriefCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseCardSummaryImplCopyWith<$Res>
    implements $PurchaseCardSummaryCopyWith<$Res> {
  factory _$$PurchaseCardSummaryImplCopyWith(
    _$PurchaseCardSummaryImpl value,
    $Res Function(_$PurchaseCardSummaryImpl) then,
  ) = __$$PurchaseCardSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String reference,
    String status,
    @JsonKey(name: 'amount_paid') int amountPaid,
    @JsonKey(name: 'fee_amount') int feeAmount,
    @JsonKey(name: 'amount_total') int amountTotal,
    String currency,
    @JsonKey(name: 'payment_provider') String paymentProvider,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
    @JsonKey(name: 'product_label') String? productLabel,
    PurchaseTenantBrief? tenant,
    PurchaseSessionBrief? session,
  });

  @override
  $PurchaseTenantBriefCopyWith<$Res>? get tenant;
  @override
  $PurchaseSessionBriefCopyWith<$Res>? get session;
}

/// @nodoc
class __$$PurchaseCardSummaryImplCopyWithImpl<$Res>
    extends _$PurchaseCardSummaryCopyWithImpl<$Res, _$PurchaseCardSummaryImpl>
    implements _$$PurchaseCardSummaryImplCopyWith<$Res> {
  __$$PurchaseCardSummaryImplCopyWithImpl(
    _$PurchaseCardSummaryImpl _value,
    $Res Function(_$PurchaseCardSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? status = null,
    Object? amountPaid = null,
    Object? feeAmount = null,
    Object? amountTotal = null,
    Object? currency = null,
    Object? paymentProvider = null,
    Object? paymentMethod = freezed,
    Object? createdAt = freezed,
    Object? confirmedAt = freezed,
    Object? productLabel = freezed,
    Object? tenant = freezed,
    Object? session = freezed,
  }) {
    return _then(
      _$PurchaseCardSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        reference: null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        amountPaid: null == amountPaid
            ? _value.amountPaid
            : amountPaid // ignore: cast_nullable_to_non_nullable
                  as int,
        feeAmount: null == feeAmount
            ? _value.feeAmount
            : feeAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        amountTotal: null == amountTotal
            ? _value.amountTotal
            : amountTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentProvider: null == paymentProvider
            ? _value.paymentProvider
            : paymentProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        productLabel: freezed == productLabel
            ? _value.productLabel
            : productLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
        tenant: freezed == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as PurchaseTenantBrief?,
        session: freezed == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as PurchaseSessionBrief?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseCardSummaryImpl implements _PurchaseCardSummary {
  const _$PurchaseCardSummaryImpl({
    required this.id,
    required this.reference,
    required this.status,
    @JsonKey(name: 'amount_paid') required this.amountPaid,
    @JsonKey(name: 'fee_amount') required this.feeAmount,
    @JsonKey(name: 'amount_total') required this.amountTotal,
    required this.currency,
    @JsonKey(name: 'payment_provider') required this.paymentProvider,
    @JsonKey(name: 'payment_method') this.paymentMethod,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'confirmed_at') this.confirmedAt,
    @JsonKey(name: 'product_label') this.productLabel,
    this.tenant,
    this.session,
  });

  factory _$PurchaseCardSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseCardSummaryImplFromJson(json);

  @override
  final int id;
  @override
  final String reference;
  @override
  final String status;
  @override
  @JsonKey(name: 'amount_paid')
  final int amountPaid;
  @override
  @JsonKey(name: 'fee_amount')
  final int feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  final int amountTotal;
  @override
  final String currency;
  @override
  @JsonKey(name: 'payment_provider')
  final String paymentProvider;
  @override
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  final DateTime? confirmedAt;
  @override
  @JsonKey(name: 'product_label')
  final String? productLabel;
  @override
  final PurchaseTenantBrief? tenant;
  @override
  final PurchaseSessionBrief? session;

  @override
  String toString() {
    return 'PurchaseCardSummary(id: $id, reference: $reference, status: $status, amountPaid: $amountPaid, feeAmount: $feeAmount, amountTotal: $amountTotal, currency: $currency, paymentProvider: $paymentProvider, paymentMethod: $paymentMethod, createdAt: $createdAt, confirmedAt: $confirmedAt, productLabel: $productLabel, tenant: $tenant, session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseCardSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid) &&
            (identical(other.feeAmount, feeAmount) ||
                other.feeAmount == feeAmount) &&
            (identical(other.amountTotal, amountTotal) ||
                other.amountTotal == amountTotal) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentProvider, paymentProvider) ||
                other.paymentProvider == paymentProvider) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.productLabel, productLabel) ||
                other.productLabel == productLabel) &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reference,
    status,
    amountPaid,
    feeAmount,
    amountTotal,
    currency,
    paymentProvider,
    paymentMethod,
    createdAt,
    confirmedAt,
    productLabel,
    tenant,
    session,
  );

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseCardSummaryImplCopyWith<_$PurchaseCardSummaryImpl> get copyWith =>
      __$$PurchaseCardSummaryImplCopyWithImpl<_$PurchaseCardSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseCardSummaryImplToJson(this);
  }
}

abstract class _PurchaseCardSummary implements PurchaseCardSummary {
  const factory _PurchaseCardSummary({
    required final int id,
    required final String reference,
    required final String status,
    @JsonKey(name: 'amount_paid') required final int amountPaid,
    @JsonKey(name: 'fee_amount') required final int feeAmount,
    @JsonKey(name: 'amount_total') required final int amountTotal,
    required final String currency,
    @JsonKey(name: 'payment_provider') required final String paymentProvider,
    @JsonKey(name: 'payment_method') final String? paymentMethod,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'confirmed_at') final DateTime? confirmedAt,
    @JsonKey(name: 'product_label') final String? productLabel,
    final PurchaseTenantBrief? tenant,
    final PurchaseSessionBrief? session,
  }) = _$PurchaseCardSummaryImpl;

  factory _PurchaseCardSummary.fromJson(Map<String, dynamic> json) =
      _$PurchaseCardSummaryImpl.fromJson;

  @override
  int get id;
  @override
  String get reference;
  @override
  String get status;
  @override
  @JsonKey(name: 'amount_paid')
  int get amountPaid;
  @override
  @JsonKey(name: 'fee_amount')
  int get feeAmount;
  @override
  @JsonKey(name: 'amount_total')
  int get amountTotal;
  @override
  String get currency;
  @override
  @JsonKey(name: 'payment_provider')
  String get paymentProvider;
  @override
  @JsonKey(name: 'payment_method')
  String? get paymentMethod;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'confirmed_at')
  DateTime? get confirmedAt;
  @override
  @JsonKey(name: 'product_label')
  String? get productLabel;
  @override
  PurchaseTenantBrief? get tenant;
  @override
  PurchaseSessionBrief? get session;

  /// Create a copy of PurchaseCardSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseCardSummaryImplCopyWith<_$PurchaseCardSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseTenantBrief _$PurchaseTenantBriefFromJson(Map<String, dynamic> json) {
  return _PurchaseTenantBrief.fromJson(json);
}

/// @nodoc
mixin _$PurchaseTenantBrief {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_urls')
  Map<String, dynamic>? get logoUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_color')
  String? get brandColor => throw _privateConstructorUsedError;

  /// Serializes this PurchaseTenantBrief to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseTenantBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseTenantBriefCopyWith<PurchaseTenantBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseTenantBriefCopyWith<$Res> {
  factory $PurchaseTenantBriefCopyWith(
    PurchaseTenantBrief value,
    $Res Function(PurchaseTenantBrief) then,
  ) = _$PurchaseTenantBriefCopyWithImpl<$Res, PurchaseTenantBrief>;
  @useResult
  $Res call({
    int id,
    String name,
    String slug,
    @JsonKey(name: 'logo_urls') Map<String, dynamic>? logoUrls,
    @JsonKey(name: 'brand_color') String? brandColor,
  });
}

/// @nodoc
class _$PurchaseTenantBriefCopyWithImpl<$Res, $Val extends PurchaseTenantBrief>
    implements $PurchaseTenantBriefCopyWith<$Res> {
  _$PurchaseTenantBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseTenantBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? logoUrls = freezed,
    Object? brandColor = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrls: freezed == logoUrls
                ? _value.logoUrls
                : logoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            brandColor: freezed == brandColor
                ? _value.brandColor
                : brandColor // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseTenantBriefImplCopyWith<$Res>
    implements $PurchaseTenantBriefCopyWith<$Res> {
  factory _$$PurchaseTenantBriefImplCopyWith(
    _$PurchaseTenantBriefImpl value,
    $Res Function(_$PurchaseTenantBriefImpl) then,
  ) = __$$PurchaseTenantBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String slug,
    @JsonKey(name: 'logo_urls') Map<String, dynamic>? logoUrls,
    @JsonKey(name: 'brand_color') String? brandColor,
  });
}

/// @nodoc
class __$$PurchaseTenantBriefImplCopyWithImpl<$Res>
    extends _$PurchaseTenantBriefCopyWithImpl<$Res, _$PurchaseTenantBriefImpl>
    implements _$$PurchaseTenantBriefImplCopyWith<$Res> {
  __$$PurchaseTenantBriefImplCopyWithImpl(
    _$PurchaseTenantBriefImpl _value,
    $Res Function(_$PurchaseTenantBriefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseTenantBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? logoUrls = freezed,
    Object? brandColor = freezed,
  }) {
    return _then(
      _$PurchaseTenantBriefImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrls: freezed == logoUrls
            ? _value._logoUrls
            : logoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        brandColor: freezed == brandColor
            ? _value.brandColor
            : brandColor // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseTenantBriefImpl implements _PurchaseTenantBrief {
  const _$PurchaseTenantBriefImpl({
    required this.id,
    required this.name,
    required this.slug,
    @JsonKey(name: 'logo_urls') final Map<String, dynamic>? logoUrls,
    @JsonKey(name: 'brand_color') this.brandColor,
  }) : _logoUrls = logoUrls;

  factory _$PurchaseTenantBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseTenantBriefImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  final Map<String, dynamic>? _logoUrls;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, dynamic>? get logoUrls {
    final value = _logoUrls;
    if (value == null) return null;
    if (_logoUrls is EqualUnmodifiableMapView) return _logoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'brand_color')
  final String? brandColor;

  @override
  String toString() {
    return 'PurchaseTenantBrief(id: $id, name: $name, slug: $slug, logoUrls: $logoUrls, brandColor: $brandColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseTenantBriefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            const DeepCollectionEquality().equals(other._logoUrls, _logoUrls) &&
            (identical(other.brandColor, brandColor) ||
                other.brandColor == brandColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    const DeepCollectionEquality().hash(_logoUrls),
    brandColor,
  );

  /// Create a copy of PurchaseTenantBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseTenantBriefImplCopyWith<_$PurchaseTenantBriefImpl> get copyWith =>
      __$$PurchaseTenantBriefImplCopyWithImpl<_$PurchaseTenantBriefImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseTenantBriefImplToJson(this);
  }
}

abstract class _PurchaseTenantBrief implements PurchaseTenantBrief {
  const factory _PurchaseTenantBrief({
    required final int id,
    required final String name,
    required final String slug,
    @JsonKey(name: 'logo_urls') final Map<String, dynamic>? logoUrls,
    @JsonKey(name: 'brand_color') final String? brandColor,
  }) = _$PurchaseTenantBriefImpl;

  factory _PurchaseTenantBrief.fromJson(Map<String, dynamic> json) =
      _$PurchaseTenantBriefImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, dynamic>? get logoUrls;
  @override
  @JsonKey(name: 'brand_color')
  String? get brandColor;

  /// Create a copy of PurchaseTenantBrief
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseTenantBriefImplCopyWith<_$PurchaseTenantBriefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseSessionBrief _$PurchaseSessionBriefFromJson(Map<String, dynamic> json) {
  return _PurchaseSessionBrief.fromJson(json);
}

/// @nodoc
mixin _$PurchaseSessionBrief {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_title')
  String? get displayTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_at')
  DateTime? get startAt => throw _privateConstructorUsedError;

  /// Serializes this PurchaseSessionBrief to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PurchaseSessionBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PurchaseSessionBriefCopyWith<PurchaseSessionBrief> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseSessionBriefCopyWith<$Res> {
  factory $PurchaseSessionBriefCopyWith(
    PurchaseSessionBrief value,
    $Res Function(PurchaseSessionBrief) then,
  ) = _$PurchaseSessionBriefCopyWithImpl<$Res, PurchaseSessionBrief>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
  });
}

/// @nodoc
class _$PurchaseSessionBriefCopyWithImpl<
  $Res,
  $Val extends PurchaseSessionBrief
>
    implements $PurchaseSessionBriefCopyWith<$Res> {
  _$PurchaseSessionBriefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseSessionBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayTitle = freezed,
    Object? startAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            displayTitle: freezed == displayTitle
                ? _value.displayTitle
                : displayTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            startAt: freezed == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PurchaseSessionBriefImplCopyWith<$Res>
    implements $PurchaseSessionBriefCopyWith<$Res> {
  factory _$$PurchaseSessionBriefImplCopyWith(
    _$PurchaseSessionBriefImpl value,
    $Res Function(_$PurchaseSessionBriefImpl) then,
  ) = __$$PurchaseSessionBriefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'start_at') DateTime? startAt,
  });
}

/// @nodoc
class __$$PurchaseSessionBriefImplCopyWithImpl<$Res>
    extends _$PurchaseSessionBriefCopyWithImpl<$Res, _$PurchaseSessionBriefImpl>
    implements _$$PurchaseSessionBriefImplCopyWith<$Res> {
  __$$PurchaseSessionBriefImplCopyWithImpl(
    _$PurchaseSessionBriefImpl _value,
    $Res Function(_$PurchaseSessionBriefImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseSessionBrief
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayTitle = freezed,
    Object? startAt = freezed,
  }) {
    return _then(
      _$PurchaseSessionBriefImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        displayTitle: freezed == displayTitle
            ? _value.displayTitle
            : displayTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        startAt: freezed == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseSessionBriefImpl implements _PurchaseSessionBrief {
  const _$PurchaseSessionBriefImpl({
    required this.id,
    @JsonKey(name: 'display_title') this.displayTitle,
    @JsonKey(name: 'start_at') this.startAt,
  });

  factory _$PurchaseSessionBriefImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseSessionBriefImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'display_title')
  final String? displayTitle;
  @override
  @JsonKey(name: 'start_at')
  final DateTime? startAt;

  @override
  String toString() {
    return 'PurchaseSessionBrief(id: $id, displayTitle: $displayTitle, startAt: $startAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseSessionBriefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.startAt, startAt) || other.startAt == startAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, displayTitle, startAt);

  /// Create a copy of PurchaseSessionBrief
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseSessionBriefImplCopyWith<_$PurchaseSessionBriefImpl>
  get copyWith =>
      __$$PurchaseSessionBriefImplCopyWithImpl<_$PurchaseSessionBriefImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseSessionBriefImplToJson(this);
  }
}

abstract class _PurchaseSessionBrief implements PurchaseSessionBrief {
  const factory _PurchaseSessionBrief({
    required final int id,
    @JsonKey(name: 'display_title') final String? displayTitle,
    @JsonKey(name: 'start_at') final DateTime? startAt,
  }) = _$PurchaseSessionBriefImpl;

  factory _PurchaseSessionBrief.fromJson(Map<String, dynamic> json) =
      _$PurchaseSessionBriefImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'display_title')
  String? get displayTitle;
  @override
  @JsonKey(name: 'start_at')
  DateTime? get startAt;

  /// Create a copy of PurchaseSessionBrief
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseSessionBriefImplCopyWith<_$PurchaseSessionBriefImpl>
  get copyWith => throw _privateConstructorUsedError;
}
