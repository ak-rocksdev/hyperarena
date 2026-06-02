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

  /// Display label for the resolved product — appears next to the price
  /// in the join CTA (e.g. "Group Single"). Sibling of `pricing` on the
  /// wire because it's presentational, not part of the price contract.
  @JsonKey(name: 'product_label')
  String? get productLabel => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'product_label') String? productLabel,
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
    Object? productLabel = freezed,
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
            productLabel: freezed == productLabel
                ? _value.productLabel
                : productLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    @JsonKey(name: 'product_label') String? productLabel,
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
    Object? productLabel = freezed,
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
        productLabel: freezed == productLabel
            ? _value.productLabel
            : productLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    @JsonKey(name: 'product_label') this.productLabel,
    @JsonKey(name: 'user_status') required this.userStatus,
    @JsonKey(name: 'tenant_payment') required this.tenantPayment,
  });

  factory _$MarketplaceSessionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceSessionDetailImplFromJson(json);

  @override
  final MarketplaceSession session;
  @override
  final SessionPricing pricing;

  /// Display label for the resolved product — appears next to the price
  /// in the join CTA (e.g. "Group Single"). Sibling of `pricing` on the
  /// wire because it's presentational, not part of the price contract.
  @override
  @JsonKey(name: 'product_label')
  final String? productLabel;
  @override
  @JsonKey(name: 'user_status')
  final UserSessionStatus userStatus;
  @override
  @JsonKey(name: 'tenant_payment')
  final TenantPaymentInfo tenantPayment;

  @override
  String toString() {
    return 'MarketplaceSessionDetail(session: $session, pricing: $pricing, productLabel: $productLabel, userStatus: $userStatus, tenantPayment: $tenantPayment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceSessionDetailImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.productLabel, productLabel) ||
                other.productLabel == productLabel) &&
            (identical(other.userStatus, userStatus) ||
                other.userStatus == userStatus) &&
            (identical(other.tenantPayment, tenantPayment) ||
                other.tenantPayment == tenantPayment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    session,
    pricing,
    productLabel,
    userStatus,
    tenantPayment,
  );

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
    @JsonKey(name: 'product_label') final String? productLabel,
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

  /// Display label for the resolved product — appears next to the price
  /// in the join CTA (e.g. "Group Single"). Sibling of `pricing` on the
  /// wire because it's presentational, not part of the price contract.
  @override
  @JsonKey(name: 'product_label')
  String? get productLabel;
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
  @JsonKey(name: 'payment_status')
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_review')
  bool get canReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_blocked_reason')
  String? get reviewBlockedReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'prior_failed_purchase')
  PriorFailedPurchase? get priorFailedPurchase =>
      throw _privateConstructorUsedError;

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
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'can_review') bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
    @JsonKey(name: 'prior_failed_purchase')
    PriorFailedPurchase? priorFailedPurchase,
  });

  $PriorFailedPurchaseCopyWith<$Res>? get priorFailedPurchase;
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
    Object? paymentStatus = freezed,
    Object? canReview = null,
    Object? reviewBlockedReason = freezed,
    Object? priorFailedPurchase = freezed,
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
            paymentStatus: freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            canReview: null == canReview
                ? _value.canReview
                : canReview // ignore: cast_nullable_to_non_nullable
                      as bool,
            reviewBlockedReason: freezed == reviewBlockedReason
                ? _value.reviewBlockedReason
                : reviewBlockedReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            priorFailedPurchase: freezed == priorFailedPurchase
                ? _value.priorFailedPurchase
                : priorFailedPurchase // ignore: cast_nullable_to_non_nullable
                      as PriorFailedPurchase?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriorFailedPurchaseCopyWith<$Res>? get priorFailedPurchase {
    if (_value.priorFailedPurchase == null) {
      return null;
    }

    return $PriorFailedPurchaseCopyWith<$Res>(_value.priorFailedPurchase!, (
      value,
    ) {
      return _then(_value.copyWith(priorFailedPurchase: value) as $Val);
    });
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
    @JsonKey(name: 'payment_status') String? paymentStatus,
    @JsonKey(name: 'can_review') bool canReview,
    @JsonKey(name: 'review_blocked_reason') String? reviewBlockedReason,
    @JsonKey(name: 'prior_failed_purchase')
    PriorFailedPurchase? priorFailedPurchase,
  });

  @override
  $PriorFailedPurchaseCopyWith<$Res>? get priorFailedPurchase;
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
    Object? paymentStatus = freezed,
    Object? canReview = null,
    Object? reviewBlockedReason = freezed,
    Object? priorFailedPurchase = freezed,
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
        paymentStatus: freezed == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        canReview: null == canReview
            ? _value.canReview
            : canReview // ignore: cast_nullable_to_non_nullable
                  as bool,
        reviewBlockedReason: freezed == reviewBlockedReason
            ? _value.reviewBlockedReason
            : reviewBlockedReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        priorFailedPurchase: freezed == priorFailedPurchase
            ? _value.priorFailedPurchase
            : priorFailedPurchase // ignore: cast_nullable_to_non_nullable
                  as PriorFailedPurchase?,
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
    @JsonKey(name: 'payment_status') this.paymentStatus,
    @JsonKey(name: 'can_review') this.canReview = false,
    @JsonKey(name: 'review_blocked_reason') this.reviewBlockedReason,
    @JsonKey(name: 'prior_failed_purchase') this.priorFailedPurchase,
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
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @override
  @JsonKey(name: 'can_review')
  final bool canReview;
  @override
  @JsonKey(name: 'review_blocked_reason')
  final String? reviewBlockedReason;
  @override
  @JsonKey(name: 'prior_failed_purchase')
  final PriorFailedPurchase? priorFailedPurchase;

  @override
  String toString() {
    return 'UserSessionStatus(creditBalance: $creditBalance, isBooked: $isBooked, bookingId: $bookingId, paymentStatus: $paymentStatus, canReview: $canReview, reviewBlockedReason: $reviewBlockedReason, priorFailedPurchase: $priorFailedPurchase)';
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
                other.bookingId == bookingId) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.canReview, canReview) ||
                other.canReview == canReview) &&
            (identical(other.reviewBlockedReason, reviewBlockedReason) ||
                other.reviewBlockedReason == reviewBlockedReason) &&
            (identical(other.priorFailedPurchase, priorFailedPurchase) ||
                other.priorFailedPurchase == priorFailedPurchase));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    creditBalance,
    isBooked,
    bookingId,
    paymentStatus,
    canReview,
    reviewBlockedReason,
    priorFailedPurchase,
  );

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
    @JsonKey(name: 'payment_status') final String? paymentStatus,
    @JsonKey(name: 'can_review') final bool canReview,
    @JsonKey(name: 'review_blocked_reason') final String? reviewBlockedReason,
    @JsonKey(name: 'prior_failed_purchase')
    final PriorFailedPurchase? priorFailedPurchase,
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
  @override
  @JsonKey(name: 'payment_status')
  String? get paymentStatus;
  @override
  @JsonKey(name: 'can_review')
  bool get canReview;
  @override
  @JsonKey(name: 'review_blocked_reason')
  String? get reviewBlockedReason;
  @override
  @JsonKey(name: 'prior_failed_purchase')
  PriorFailedPurchase? get priorFailedPurchase;

  /// Create a copy of UserSessionStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionStatusImplCopyWith<_$UserSessionStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PriorFailedPurchase _$PriorFailedPurchaseFromJson(Map<String, dynamic> json) {
  return _PriorFailedPurchase.fromJson(json);
}

/// @nodoc
mixin _$PriorFailedPurchase {
  @JsonKey(name: 'purchase_id')
  int get purchaseId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'expired' | 'cancelled' | 'rejected'
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt => throw _privateConstructorUsedError;

  /// Serializes this PriorFailedPurchase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PriorFailedPurchase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriorFailedPurchaseCopyWith<PriorFailedPurchase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriorFailedPurchaseCopyWith<$Res> {
  factory $PriorFailedPurchaseCopyWith(
    PriorFailedPurchase value,
    $Res Function(PriorFailedPurchase) then,
  ) = _$PriorFailedPurchaseCopyWithImpl<$Res, PriorFailedPurchase>;
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
  });
}

/// @nodoc
class _$PriorFailedPurchaseCopyWithImpl<$Res, $Val extends PriorFailedPurchase>
    implements $PriorFailedPurchaseCopyWith<$Res> {
  _$PriorFailedPurchaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriorFailedPurchase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? failedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            purchaseId: null == purchaseId
                ? _value.purchaseId
                : purchaseId // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            failedAt: freezed == failedAt
                ? _value.failedAt
                : failedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PriorFailedPurchaseImplCopyWith<$Res>
    implements $PriorFailedPurchaseCopyWith<$Res> {
  factory _$$PriorFailedPurchaseImplCopyWith(
    _$PriorFailedPurchaseImpl value,
    $Res Function(_$PriorFailedPurchaseImpl) then,
  ) = __$$PriorFailedPurchaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'purchase_id') int purchaseId,
    String status,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
  });
}

/// @nodoc
class __$$PriorFailedPurchaseImplCopyWithImpl<$Res>
    extends _$PriorFailedPurchaseCopyWithImpl<$Res, _$PriorFailedPurchaseImpl>
    implements _$$PriorFailedPurchaseImplCopyWith<$Res> {
  __$$PriorFailedPurchaseImplCopyWithImpl(
    _$PriorFailedPurchaseImpl _value,
    $Res Function(_$PriorFailedPurchaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PriorFailedPurchase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? purchaseId = null,
    Object? status = null,
    Object? failedAt = freezed,
  }) {
    return _then(
      _$PriorFailedPurchaseImpl(
        purchaseId: null == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        failedAt: freezed == failedAt
            ? _value.failedAt
            : failedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PriorFailedPurchaseImpl implements _PriorFailedPurchase {
  const _$PriorFailedPurchaseImpl({
    @JsonKey(name: 'purchase_id') required this.purchaseId,
    required this.status,
    @JsonKey(name: 'failed_at') this.failedAt,
  });

  factory _$PriorFailedPurchaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriorFailedPurchaseImplFromJson(json);

  @override
  @JsonKey(name: 'purchase_id')
  final int purchaseId;
  @override
  final String status;
  // 'expired' | 'cancelled' | 'rejected'
  @override
  @JsonKey(name: 'failed_at')
  final DateTime? failedAt;

  @override
  String toString() {
    return 'PriorFailedPurchase(purchaseId: $purchaseId, status: $status, failedAt: $failedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriorFailedPurchaseImpl &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.failedAt, failedAt) ||
                other.failedAt == failedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, purchaseId, status, failedAt);

  /// Create a copy of PriorFailedPurchase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriorFailedPurchaseImplCopyWith<_$PriorFailedPurchaseImpl> get copyWith =>
      __$$PriorFailedPurchaseImplCopyWithImpl<_$PriorFailedPurchaseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PriorFailedPurchaseImplToJson(this);
  }
}

abstract class _PriorFailedPurchase implements PriorFailedPurchase {
  const factory _PriorFailedPurchase({
    @JsonKey(name: 'purchase_id') required final int purchaseId,
    required final String status,
    @JsonKey(name: 'failed_at') final DateTime? failedAt,
  }) = _$PriorFailedPurchaseImpl;

  factory _PriorFailedPurchase.fromJson(Map<String, dynamic> json) =
      _$PriorFailedPurchaseImpl.fromJson;

  @override
  @JsonKey(name: 'purchase_id')
  int get purchaseId;
  @override
  String get status; // 'expired' | 'cancelled' | 'rejected'
  @override
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt;

  /// Create a copy of PriorFailedPurchase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriorFailedPurchaseImplCopyWith<_$PriorFailedPurchaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
