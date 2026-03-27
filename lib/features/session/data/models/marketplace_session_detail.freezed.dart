// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_session_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketplaceSessionDetail _$MarketplaceSessionDetailFromJson(
  Map<String, dynamic> json,
) {
  return _MarketplaceSessionDetail.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceSessionDetail {
  MarketplaceSession get session => throw _privateConstructorUsedError;
  SessionPricing get pricing => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_status')
  UserSessionStatus get userStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_payment')
  TenantPaymentInfo get tenantPayment => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceSessionDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceSessionDetailCopyWith<MarketplaceSessionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceSessionDetailCopyWith<$Res> {
  factory $MarketplaceSessionDetailCopyWith(
    MarketplaceSessionDetail value,
    $Res Function(MarketplaceSessionDetail) then,
  ) = _$MarketplaceSessionDetailCopyWithImpl<$Res, MarketplaceSessionDetail>;
  @useResult
  $Res call({
    MarketplaceSession session,
    SessionPricing pricing,
    @JsonKey(name: 'user_status') UserSessionStatus userStatus,
    @JsonKey(name: 'tenant_payment') TenantPaymentInfo tenantPayment,
  });

  $MarketplaceSessionCopyWith<$Res> get session;
  $SessionPricingCopyWith<$Res> get pricing;
  $UserSessionStatusCopyWith<$Res> get userStatus;
  $TenantPaymentInfoCopyWith<$Res> get tenantPayment;
}

/// @nodoc
class _$MarketplaceSessionDetailCopyWithImpl<
  $Res,
  $Val extends MarketplaceSessionDetail
>
    implements $MarketplaceSessionDetailCopyWith<$Res> {
  _$MarketplaceSessionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? pricing = null,
    Object? userStatus = null,
    Object? tenantPayment = null,
  }) {
    return _then(
      _value.copyWith(
            session: null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                      as MarketplaceSession,
            pricing: null == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as SessionPricing,
            userStatus: null == userStatus
                ? _value.userStatus
                : userStatus // ignore: cast_nullable_to_non_nullable
                      as UserSessionStatus,
            tenantPayment: null == tenantPayment
                ? _value.tenantPayment
                : tenantPayment // ignore: cast_nullable_to_non_nullable
                      as TenantPaymentInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarketplaceSessionCopyWith<$Res> get session {
    return $MarketplaceSessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionPricingCopyWith<$Res> get pricing {
    return $SessionPricingCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSessionStatusCopyWith<$Res> get userStatus {
    return $UserSessionStatusCopyWith<$Res>(_value.userStatus, (value) {
      return _then(_value.copyWith(userStatus: value) as $Val);
    });
  }

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TenantPaymentInfoCopyWith<$Res> get tenantPayment {
    return $TenantPaymentInfoCopyWith<$Res>(_value.tenantPayment, (value) {
      return _then(_value.copyWith(tenantPayment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceSessionDetailImplCopyWith<$Res>
    implements $MarketplaceSessionDetailCopyWith<$Res> {
  factory _$$MarketplaceSessionDetailImplCopyWith(
    _$MarketplaceSessionDetailImpl value,
    $Res Function(_$MarketplaceSessionDetailImpl) then,
  ) = __$$MarketplaceSessionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MarketplaceSession session,
    SessionPricing pricing,
    @JsonKey(name: 'user_status') UserSessionStatus userStatus,
    @JsonKey(name: 'tenant_payment') TenantPaymentInfo tenantPayment,
  });

  @override
  $MarketplaceSessionCopyWith<$Res> get session;
  @override
  $SessionPricingCopyWith<$Res> get pricing;
  @override
  $UserSessionStatusCopyWith<$Res> get userStatus;
  @override
  $TenantPaymentInfoCopyWith<$Res> get tenantPayment;
}

/// @nodoc
class __$$MarketplaceSessionDetailImplCopyWithImpl<$Res>
    extends
        _$MarketplaceSessionDetailCopyWithImpl<
          $Res,
          _$MarketplaceSessionDetailImpl
        >
    implements _$$MarketplaceSessionDetailImplCopyWith<$Res> {
  __$$MarketplaceSessionDetailImplCopyWithImpl(
    _$MarketplaceSessionDetailImpl _value,
    $Res Function(_$MarketplaceSessionDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? pricing = null,
    Object? userStatus = null,
    Object? tenantPayment = null,
  }) {
    return _then(
      _$MarketplaceSessionDetailImpl(
        session: null == session
            ? _value.session
            : session // ignore: cast_nullable_to_non_nullable
                  as MarketplaceSession,
        pricing: null == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as SessionPricing,
        userStatus: null == userStatus
            ? _value.userStatus
            : userStatus // ignore: cast_nullable_to_non_nullable
                  as UserSessionStatus,
        tenantPayment: null == tenantPayment
            ? _value.tenantPayment
            : tenantPayment // ignore: cast_nullable_to_non_nullable
                  as TenantPaymentInfo,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceSessionDetailImpl implements _MarketplaceSessionDetail {
  const _$MarketplaceSessionDetailImpl({
    required this.session,
    required this.pricing,
    @JsonKey(name: 'user_status') required this.userStatus,
    @JsonKey(name: 'tenant_payment') required this.tenantPayment,
  });

  factory _$MarketplaceSessionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceSessionDetailImplFromJson(json);

  @override
  final MarketplaceSession session;
  @override
  final SessionPricing pricing;
  @override
  @JsonKey(name: 'user_status')
  final UserSessionStatus userStatus;
  @override
  @JsonKey(name: 'tenant_payment')
  final TenantPaymentInfo tenantPayment;

  @override
  String toString() {
    return 'MarketplaceSessionDetail(session: $session, pricing: $pricing, userStatus: $userStatus, tenantPayment: $tenantPayment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceSessionDetailImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.tenantPayment, tenantPayment) ||
                other.tenantPayment == tenantPayment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, session, pricing, userStatus, tenantPayment);

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceSessionDetailImplCopyWith<_$MarketplaceSessionDetailImpl>
  get copyWith =>
      __$$MarketplaceSessionDetailImplCopyWithImpl<
        _$MarketplaceSessionDetailImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceSessionDetailImplToJson(this);
  }
}

abstract class _MarketplaceSessionDetail implements MarketplaceSessionDetail {
  const factory _MarketplaceSessionDetail({
    required final MarketplaceSession session,
    required final SessionPricing pricing,
    @JsonKey(name: 'user_status') required final UserSessionStatus userStatus,
    @JsonKey(name: 'tenant_payment')
    required final TenantPaymentInfo tenantPayment,
  }) = _$MarketplaceSessionDetailImpl;

  factory _MarketplaceSessionDetail.fromJson(Map<String, dynamic> json) =
      _$MarketplaceSessionDetailImpl.fromJson;

  @override
  MarketplaceSession get session;
  @override
  SessionPricing get pricing;
  @override
  @JsonKey(name: 'user_status')
  UserSessionStatus get userStatus;
  @override
  @JsonKey(name: 'tenant_payment')
  TenantPaymentInfo get tenantPayment;

  /// Create a copy of MarketplaceSessionDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceSessionDetailImplCopyWith<_$MarketplaceSessionDetailImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SessionPricing _$SessionPricingFromJson(Map<String, dynamic> json) {
  return _SessionPricing.fromJson(json);
}

/// @nodoc
mixin _$SessionPricing {
  @JsonKey(name: 'product_id', fromJson: idFromJson)
  String get productId => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this SessionPricing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionPricingCopyWith<SessionPricing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionPricingCopyWith<$Res> {
  factory $SessionPricingCopyWith(
    SessionPricing value,
    $Res Function(SessionPricing) then,
  ) = _$SessionPricingCopyWithImpl<$Res, SessionPricing>;
  @useResult
  $Res call({
    @JsonKey(name: 'product_id', fromJson: idFromJson) String productId,
    int price,
    String currency,
    String label,
  });
}

/// @nodoc
class _$SessionPricingCopyWithImpl<$Res, $Val extends SessionPricing>
    implements $SessionPricingCopyWith<$Res> {
  _$SessionPricingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? price = null,
    Object? currency = null,
    Object? label = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionPricingImplCopyWith<$Res>
    implements $SessionPricingCopyWith<$Res> {
  factory _$$SessionPricingImplCopyWith(
    _$SessionPricingImpl value,
    $Res Function(_$SessionPricingImpl) then,
  ) = __$$SessionPricingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'product_id', fromJson: idFromJson) String productId,
    int price,
    String currency,
    String label,
  });
}

/// @nodoc
class __$$SessionPricingImplCopyWithImpl<$Res>
    extends _$SessionPricingCopyWithImpl<$Res, _$SessionPricingImpl>
    implements _$$SessionPricingImplCopyWith<$Res> {
  __$$SessionPricingImplCopyWithImpl(
    _$SessionPricingImpl _value,
    $Res Function(_$SessionPricingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? price = null,
    Object? currency = null,
    Object? label = null,
  }) {
    return _then(
      _$SessionPricingImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionPricingImpl implements _SessionPricing {
  const _$SessionPricingImpl({
    @JsonKey(name: 'product_id', fromJson: idFromJson) required this.productId,
    required this.price,
    required this.currency,
    this.label = '',
  });

  factory _$SessionPricingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionPricingImplFromJson(json);

  @override
  @JsonKey(name: 'product_id', fromJson: idFromJson)
  final String productId;
  @override
  final int price;
  @override
  final String currency;
  @override
  @JsonKey()
  final String label;

  @override
  String toString() {
    return 'SessionPricing(productId: $productId, price: $price, currency: $currency, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionPricingImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, price, currency, label);

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionPricingImplCopyWith<_$SessionPricingImpl> get copyWith =>
      __$$SessionPricingImplCopyWithImpl<_$SessionPricingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionPricingImplToJson(this);
  }
}

abstract class _SessionPricing implements SessionPricing {
  const factory _SessionPricing({
    @JsonKey(name: 'product_id', fromJson: idFromJson)
    required final String productId,
    required final int price,
    required final String currency,
    final String label,
  }) = _$SessionPricingImpl;

  factory _SessionPricing.fromJson(Map<String, dynamic> json) =
      _$SessionPricingImpl.fromJson;

  @override
  @JsonKey(name: 'product_id', fromJson: idFromJson)
  String get productId;
  @override
  int get price;
  @override
  String get currency;
  @override
  String get label;

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionPricingImplCopyWith<_$SessionPricingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSessionStatus _$UserSessionStatusFromJson(Map<String, dynamic> json) {
  return _UserSessionStatus.fromJson(json);
}

/// @nodoc
mixin _$UserSessionStatus {
  @JsonKey(name: 'credit_balance')
  int get creditBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_booked')
  bool get isBooked => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
  String? get bookingId => throw _privateConstructorUsedError;

  /// Serializes this UserSessionStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionStatusCopyWith<UserSessionStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionStatusCopyWith<$Res> {
  factory $UserSessionStatusCopyWith(
    UserSessionStatus value,
    $Res Function(UserSessionStatus) then,
  ) = _$UserSessionStatusCopyWithImpl<$Res, UserSessionStatus>;
  @useResult
  $Res call({
    @JsonKey(name: 'credit_balance') int creditBalance,
    @JsonKey(name: 'is_booked') bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
    String? bookingId,
  });
}

/// @nodoc
class _$UserSessionStatusCopyWithImpl<$Res, $Val extends UserSessionStatus>
    implements $UserSessionStatusCopyWith<$Res> {
  _$UserSessionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditBalance = null,
    Object? isBooked = null,
    Object? bookingId = freezed,
  }) {
    return _then(
      _value.copyWith(
            creditBalance: null == creditBalance
                ? _value.creditBalance
                : creditBalance // ignore: cast_nullable_to_non_nullable
                      as int,
            isBooked: null == isBooked
                ? _value.isBooked
                : isBooked // ignore: cast_nullable_to_non_nullable
                      as bool,
            bookingId: freezed == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserSessionStatusImplCopyWith<$Res>
    implements $UserSessionStatusCopyWith<$Res> {
  factory _$$UserSessionStatusImplCopyWith(
    _$UserSessionStatusImpl value,
    $Res Function(_$UserSessionStatusImpl) then,
  ) = __$$UserSessionStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'credit_balance') int creditBalance,
    @JsonKey(name: 'is_booked') bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
    String? bookingId,
  });
}

/// @nodoc
class __$$UserSessionStatusImplCopyWithImpl<$Res>
    extends _$UserSessionStatusCopyWithImpl<$Res, _$UserSessionStatusImpl>
    implements _$$UserSessionStatusImplCopyWith<$Res> {
  __$$UserSessionStatusImplCopyWithImpl(
    _$UserSessionStatusImpl _value,
    $Res Function(_$UserSessionStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditBalance = null,
    Object? isBooked = null,
    Object? bookingId = freezed,
  }) {
    return _then(
      _$UserSessionStatusImpl(
        creditBalance: null == creditBalance
            ? _value.creditBalance
            : creditBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        isBooked: null == isBooked
            ? _value.isBooked
            : isBooked // ignore: cast_nullable_to_non_nullable
                  as bool,
        bookingId: freezed == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSessionStatusImpl implements _UserSessionStatus {
  const _$UserSessionStatusImpl({
    @JsonKey(name: 'credit_balance') this.creditBalance = 0,
    @JsonKey(name: 'is_booked') this.isBooked = false,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson) this.bookingId,
  });

  factory _$UserSessionStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSessionStatusImplFromJson(json);

  @override
  @JsonKey(name: 'credit_balance')
  final int creditBalance;
  @override
  @JsonKey(name: 'is_booked')
  final bool isBooked;
  @override
  @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
  final String? bookingId;

  @override
  String toString() {
    return 'UserSessionStatus(creditBalance: $creditBalance, isBooked: $isBooked, bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionStatusImpl &&
            (identical(other.creditBalance, creditBalance) ||
                other.creditBalance == creditBalance) &&
            (identical(other.isBooked, isBooked) ||
                other.isBooked == isBooked) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, creditBalance, isBooked, bookingId);

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionStatusImplCopyWith<_$UserSessionStatusImpl> get copyWith =>
      __$$UserSessionStatusImplCopyWithImpl<_$UserSessionStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSessionStatusImplToJson(this);
  }
}

abstract class _UserSessionStatus implements UserSessionStatus {
  const factory _UserSessionStatus({
    @JsonKey(name: 'credit_balance') final int creditBalance,
    @JsonKey(name: 'is_booked') final bool isBooked,
    @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
    final String? bookingId,
  }) = _$UserSessionStatusImpl;

  factory _UserSessionStatus.fromJson(Map<String, dynamic> json) =
      _$UserSessionStatusImpl.fromJson;

  @override
  @JsonKey(name: 'credit_balance')
  int get creditBalance;
  @override
  @JsonKey(name: 'is_booked')
  bool get isBooked;
  @override
  @JsonKey(name: 'booking_id', fromJson: nullableIdFromJson)
  String? get bookingId;

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionStatusImplCopyWith<_$UserSessionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
