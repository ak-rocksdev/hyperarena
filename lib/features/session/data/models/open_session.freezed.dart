// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionHealth _$SessionHealthFromJson(Map<String, dynamic> json) {
  return _SessionHealth.fromJson(json);
}

/// @nodoc
mixin _$SessionHealth {
  int get pendingPayments => throw _privateConstructorUsedError;
  bool get isLowSignupRisk => throw _privateConstructorUsedError;
  bool get isJoinDeadlineAtRisk => throw _privateConstructorUsedError;
  int get trendScore => throw _privateConstructorUsedError;
  int get pendingPaymentAmount => throw _privateConstructorUsedError;
  int get slotsRemaining => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
  Duration? get timeToStart => throw _privateConstructorUsedError;

  /// Serializes this SessionHealth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionHealthCopyWith<SessionHealth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionHealthCopyWith<$Res> {
  factory $SessionHealthCopyWith(
    SessionHealth value,
    $Res Function(SessionHealth) then,
  ) = _$SessionHealthCopyWithImpl<$Res, SessionHealth>;
  @useResult
  $Res call({
    int pendingPayments,
    bool isLowSignupRisk,
    bool isJoinDeadlineAtRisk,
    int trendScore,
    int pendingPaymentAmount,
    int slotsRemaining,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    Duration? timeToStart,
  });
}

/// @nodoc
class _$SessionHealthCopyWithImpl<$Res, $Val extends SessionHealth>
    implements $SessionHealthCopyWith<$Res> {
  _$SessionHealthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingPayments = null,
    Object? isLowSignupRisk = null,
    Object? isJoinDeadlineAtRisk = null,
    Object? trendScore = null,
    Object? pendingPaymentAmount = null,
    Object? slotsRemaining = null,
    Object? timeToStart = freezed,
  }) {
    return _then(
      _value.copyWith(
            pendingPayments: null == pendingPayments
                ? _value.pendingPayments
                : pendingPayments // ignore: cast_nullable_to_non_nullable
                      as int,
            isLowSignupRisk: null == isLowSignupRisk
                ? _value.isLowSignupRisk
                : isLowSignupRisk // ignore: cast_nullable_to_non_nullable
                      as bool,
            isJoinDeadlineAtRisk: null == isJoinDeadlineAtRisk
                ? _value.isJoinDeadlineAtRisk
                : isJoinDeadlineAtRisk // ignore: cast_nullable_to_non_nullable
                      as bool,
            trendScore: null == trendScore
                ? _value.trendScore
                : trendScore // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingPaymentAmount: null == pendingPaymentAmount
                ? _value.pendingPaymentAmount
                : pendingPaymentAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            slotsRemaining: null == slotsRemaining
                ? _value.slotsRemaining
                : slotsRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            timeToStart: freezed == timeToStart
                ? _value.timeToStart
                : timeToStart // ignore: cast_nullable_to_non_nullable
                      as Duration?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionHealthImplCopyWith<$Res>
    implements $SessionHealthCopyWith<$Res> {
  factory _$$SessionHealthImplCopyWith(
    _$SessionHealthImpl value,
    $Res Function(_$SessionHealthImpl) then,
  ) = __$$SessionHealthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int pendingPayments,
    bool isLowSignupRisk,
    bool isJoinDeadlineAtRisk,
    int trendScore,
    int pendingPaymentAmount,
    int slotsRemaining,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    Duration? timeToStart,
  });
}

/// @nodoc
class __$$SessionHealthImplCopyWithImpl<$Res>
    extends _$SessionHealthCopyWithImpl<$Res, _$SessionHealthImpl>
    implements _$$SessionHealthImplCopyWith<$Res> {
  __$$SessionHealthImplCopyWithImpl(
    _$SessionHealthImpl _value,
    $Res Function(_$SessionHealthImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionHealth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingPayments = null,
    Object? isLowSignupRisk = null,
    Object? isJoinDeadlineAtRisk = null,
    Object? trendScore = null,
    Object? pendingPaymentAmount = null,
    Object? slotsRemaining = null,
    Object? timeToStart = freezed,
  }) {
    return _then(
      _$SessionHealthImpl(
        pendingPayments: null == pendingPayments
            ? _value.pendingPayments
            : pendingPayments // ignore: cast_nullable_to_non_nullable
                  as int,
        isLowSignupRisk: null == isLowSignupRisk
            ? _value.isLowSignupRisk
            : isLowSignupRisk // ignore: cast_nullable_to_non_nullable
                  as bool,
        isJoinDeadlineAtRisk: null == isJoinDeadlineAtRisk
            ? _value.isJoinDeadlineAtRisk
            : isJoinDeadlineAtRisk // ignore: cast_nullable_to_non_nullable
                  as bool,
        trendScore: null == trendScore
            ? _value.trendScore
            : trendScore // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingPaymentAmount: null == pendingPaymentAmount
            ? _value.pendingPaymentAmount
            : pendingPaymentAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        slotsRemaining: null == slotsRemaining
            ? _value.slotsRemaining
            : slotsRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        timeToStart: freezed == timeToStart
            ? _value.timeToStart
            : timeToStart // ignore: cast_nullable_to_non_nullable
                  as Duration?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionHealthImpl implements _SessionHealth {
  const _$SessionHealthImpl({
    this.pendingPayments = 0,
    this.isLowSignupRisk = false,
    this.isJoinDeadlineAtRisk = false,
    this.trendScore = 0,
    this.pendingPaymentAmount = 0,
    this.slotsRemaining = 0,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    this.timeToStart,
  });

  factory _$SessionHealthImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionHealthImplFromJson(json);

  @override
  @JsonKey()
  final int pendingPayments;
  @override
  @JsonKey()
  final bool isLowSignupRisk;
  @override
  @JsonKey()
  final bool isJoinDeadlineAtRisk;
  @override
  @JsonKey()
  final int trendScore;
  @override
  @JsonKey()
  final int pendingPaymentAmount;
  @override
  @JsonKey()
  final int slotsRemaining;
  @override
  @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
  final Duration? timeToStart;

  @override
  String toString() {
    return 'SessionHealth(pendingPayments: $pendingPayments, isLowSignupRisk: $isLowSignupRisk, isJoinDeadlineAtRisk: $isJoinDeadlineAtRisk, trendScore: $trendScore, pendingPaymentAmount: $pendingPaymentAmount, slotsRemaining: $slotsRemaining, timeToStart: $timeToStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionHealthImpl &&
            (identical(other.pendingPayments, pendingPayments) ||
                other.pendingPayments == pendingPayments) &&
            (identical(other.isLowSignupRisk, isLowSignupRisk) ||
                other.isLowSignupRisk == isLowSignupRisk) &&
            (identical(other.isJoinDeadlineAtRisk, isJoinDeadlineAtRisk) ||
                other.isJoinDeadlineAtRisk == isJoinDeadlineAtRisk) &&
            (identical(other.trendScore, trendScore) ||
                other.trendScore == trendScore) &&
            (identical(other.pendingPaymentAmount, pendingPaymentAmount) ||
                other.pendingPaymentAmount == pendingPaymentAmount) &&
            (identical(other.slotsRemaining, slotsRemaining) ||
                other.slotsRemaining == slotsRemaining) &&
            (identical(other.timeToStart, timeToStart) ||
                other.timeToStart == timeToStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pendingPayments,
    isLowSignupRisk,
    isJoinDeadlineAtRisk,
    trendScore,
    pendingPaymentAmount,
    slotsRemaining,
    timeToStart,
  );

  /// Create a copy of SessionHealth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionHealthImplCopyWith<_$SessionHealthImpl> get copyWith =>
      __$$SessionHealthImplCopyWithImpl<_$SessionHealthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionHealthImplToJson(this);
  }
}

abstract class _SessionHealth implements SessionHealth {
  const factory _SessionHealth({
    final int pendingPayments,
    final bool isLowSignupRisk,
    final bool isJoinDeadlineAtRisk,
    final int trendScore,
    final int pendingPaymentAmount,
    final int slotsRemaining,
    @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
    final Duration? timeToStart,
  }) = _$SessionHealthImpl;

  factory _SessionHealth.fromJson(Map<String, dynamic> json) =
      _$SessionHealthImpl.fromJson;

  @override
  int get pendingPayments;
  @override
  bool get isLowSignupRisk;
  @override
  bool get isJoinDeadlineAtRisk;
  @override
  int get trendScore;
  @override
  int get pendingPaymentAmount;
  @override
  int get slotsRemaining;
  @override
  @JsonKey(fromJson: _healthDurationFromJson, toJson: _healthDurationToJson)
  Duration? get timeToStart;

  /// Create a copy of SessionHealth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionHealthImplCopyWith<_$SessionHealthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionPricing _$SessionPricingFromJson(Map<String, dynamic> json) {
  return _SessionPricing.fromJson(json);
}

/// @nodoc
mixin _$SessionPricing {
  @JsonKey(name: 'effective_price')
  int? get effectivePrice => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_mode')
  String get paymentMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_required')
  int? get creditRequired => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'effective_price') int? effectivePrice,
    String currency,
    @JsonKey(name: 'payment_mode') String paymentMode,
    @JsonKey(name: 'credit_required') int? creditRequired,
    String? source,
    @JsonKey(name: 'product_id') int? productId,
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
    Object? effectivePrice = freezed,
    Object? currency = null,
    Object? paymentMode = null,
    Object? creditRequired = freezed,
    Object? source = freezed,
    Object? productId = freezed,
  }) {
    return _then(
      _value.copyWith(
            effectivePrice: freezed == effectivePrice
                ? _value.effectivePrice
                : effectivePrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentMode: null == paymentMode
                ? _value.paymentMode
                : paymentMode // ignore: cast_nullable_to_non_nullable
                      as String,
            creditRequired: freezed == creditRequired
                ? _value.creditRequired
                : creditRequired // ignore: cast_nullable_to_non_nullable
                      as int?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int?,
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
    @JsonKey(name: 'effective_price') int? effectivePrice,
    String currency,
    @JsonKey(name: 'payment_mode') String paymentMode,
    @JsonKey(name: 'credit_required') int? creditRequired,
    String? source,
    @JsonKey(name: 'product_id') int? productId,
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
    Object? effectivePrice = freezed,
    Object? currency = null,
    Object? paymentMode = null,
    Object? creditRequired = freezed,
    Object? source = freezed,
    Object? productId = freezed,
  }) {
    return _then(
      _$SessionPricingImpl(
        effectivePrice: freezed == effectivePrice
            ? _value.effectivePrice
            : effectivePrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentMode: null == paymentMode
            ? _value.paymentMode
            : paymentMode // ignore: cast_nullable_to_non_nullable
                  as String,
        creditRequired: freezed == creditRequired
            ? _value.creditRequired
            : creditRequired // ignore: cast_nullable_to_non_nullable
                  as int?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionPricingImpl implements _SessionPricing {
  const _$SessionPricingImpl({
    @JsonKey(name: 'effective_price') this.effectivePrice,
    this.currency = 'IDR',
    @JsonKey(name: 'payment_mode') this.paymentMode = 'unconfigured',
    @JsonKey(name: 'credit_required') this.creditRequired,
    this.source,
    @JsonKey(name: 'product_id') this.productId,
  });

  factory _$SessionPricingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionPricingImplFromJson(json);

  @override
  @JsonKey(name: 'effective_price')
  final int? effectivePrice;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(name: 'payment_mode')
  final String paymentMode;
  @override
  @JsonKey(name: 'credit_required')
  final int? creditRequired;
  @override
  final String? source;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;

  @override
  String toString() {
    return 'SessionPricing(effectivePrice: $effectivePrice, currency: $currency, paymentMode: $paymentMode, creditRequired: $creditRequired, source: $source, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionPricingImpl &&
            (identical(other.effectivePrice, effectivePrice) ||
                other.effectivePrice == effectivePrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.paymentMode, paymentMode) ||
                other.paymentMode == paymentMode) &&
            (identical(other.creditRequired, creditRequired) ||
                other.creditRequired == creditRequired) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    effectivePrice,
    currency,
    paymentMode,
    creditRequired,
    source,
    productId,
  );

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
    @JsonKey(name: 'effective_price') final int? effectivePrice,
    final String currency,
    @JsonKey(name: 'payment_mode') final String paymentMode,
    @JsonKey(name: 'credit_required') final int? creditRequired,
    final String? source,
    @JsonKey(name: 'product_id') final int? productId,
  }) = _$SessionPricingImpl;

  factory _SessionPricing.fromJson(Map<String, dynamic> json) =
      _$SessionPricingImpl.fromJson;

  @override
  @JsonKey(name: 'effective_price')
  int? get effectivePrice;
  @override
  String get currency;
  @override
  @JsonKey(name: 'payment_mode')
  String get paymentMode;
  @override
  @JsonKey(name: 'credit_required')
  int? get creditRequired;
  @override
  String? get source;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;

  /// Create a copy of SessionPricing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionPricingImplCopyWith<_$SessionPricingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpenSession _$OpenSessionFromJson(Map<String, dynamic> json) {
  return _OpenSession.fromJson(json);
}

/// @nodoc
mixin _$OpenSession {
  String get id => throw _privateConstructorUsedError;

  /// Raw editable title (nullable post-Issue 2026-05-07-session-title).
  /// Pre-feature-deploy BE sent auto-name here; consumers should read
  /// [displayTitle] (or use the `safeTitle` extension) which handles
  /// both windows.
  String? get title => throw _privateConstructorUsedError;
  Sport get sport => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get hostName => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get currentPlayers => throw _privateConstructorUsedError;
  int get maxPlayers => throw _privateConstructorUsedError;
  LevelTier? get minLevel => throw _privateConstructorUsedError;
  LevelTier? get maxLevel => throw _privateConstructorUsedError;

  /// Legacy alias for `pricing.effective_price`. Prefer reading
  /// `pricing` directly — `pricePerPerson` doesn't carry payment mode,
  /// credit requirement, or currency.
  int get pricePerPerson => throw _privateConstructorUsedError;

  /// Resolved pricing block — source of truth for display. Nullable
  /// because mock fixtures may omit it; consumers fall back to
  /// `pricePerPerson` + tenant currency.
  SessionPricing? get pricing => throw _privateConstructorUsedError;

  /// `title ?? auto-name` from BE. Always non-null on a real response;
  /// nullable here so pre-feature-deploy responses (which omit this
  /// field) still parse — use the `safeTitle` extension at call sites.
  @JsonKey(name: 'display_title')
  String? get displayTitle => throw _privateConstructorUsedError;

  /// 8-char hash, null when no session-specific photo set. Used to
  /// distinguish "real session photo" (rectangular 16:9) from
  /// "fallback to tenant logo" (square) — when [photoUrls] is non-null
  /// but [photoPath] is null, the URLs point at the tenant logo and
  /// caller renders the centered-on-brand-color fallback layout.
  @JsonKey(name: 'photo_path')
  String? get photoPath => throw _privateConstructorUsedError;

  /// Hero photo URLs in 4 sizes (sm/md/lg/xl). When [photoPath] is set
  /// these are 16:9 session photos; otherwise BE returns the tenant
  /// `logo_urls` map (square) as the fallback. Null when neither
  /// session nor tenant has a photo.
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get participantNames => throw _privateConstructorUsedError;
  OpenSessionStatus get status => throw _privateConstructorUsedError;
  DateTime? get joinDeadline => throw _privateConstructorUsedError;
  SessionPricingModel get pricingModel => throw _privateConstructorUsedError;
  SessionVisibility get visibility => throw _privateConstructorUsedError;
  int? get courtCost => throw _privateConstructorUsedError;
  int? get coachCost => throw _privateConstructorUsedError;
  int? get organizerFeePerPerson => throw _privateConstructorUsedError;
  SessionSettlementStatus get settlementStatus =>
      throw _privateConstructorUsedError;
  SessionHealth get health => throw _privateConstructorUsedError;

  /// Serializes this OpenSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenSessionCopyWith<OpenSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenSessionCopyWith<$Res> {
  factory $OpenSessionCopyWith(
    OpenSession value,
    $Res Function(OpenSession) then,
  ) = _$OpenSessionCopyWithImpl<$Res, OpenSession>;
  @useResult
  $Res call({
    String id,
    String? title,
    Sport sport,
    String hostId,
    String hostName,
    String venueName,
    String venueId,
    DateTime date,
    String startTime,
    String endTime,
    int currentPlayers,
    int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    int pricePerPerson,
    SessionPricing? pricing,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? description,
    List<String> participantNames,
    OpenSessionStatus status,
    DateTime? joinDeadline,
    SessionPricingModel pricingModel,
    SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    SessionSettlementStatus settlementStatus,
    SessionHealth health,
  });

  $SessionPricingCopyWith<$Res>? get pricing;
  $SessionHealthCopyWith<$Res> get health;
}

/// @nodoc
class _$OpenSessionCopyWithImpl<$Res, $Val extends OpenSession>
    implements $OpenSessionCopyWith<$Res> {
  _$OpenSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? sport = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? venueName = null,
    Object? venueId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? currentPlayers = null,
    Object? maxPlayers = null,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? pricePerPerson = null,
    Object? pricing = freezed,
    Object? displayTitle = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
    Object? description = freezed,
    Object? participantNames = null,
    Object? status = null,
    Object? joinDeadline = freezed,
    Object? pricingModel = null,
    Object? visibility = null,
    Object? courtCost = freezed,
    Object? coachCost = freezed,
    Object? organizerFeePerPerson = freezed,
    Object? settlementStatus = null,
    Object? health = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            sport: null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as String,
            hostName: null == hostName
                ? _value.hostName
                : hostName // ignore: cast_nullable_to_non_nullable
                      as String,
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            venueId: null == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPlayers: null == currentPlayers
                ? _value.currentPlayers
                : currentPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            maxPlayers: null == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            minLevel: freezed == minLevel
                ? _value.minLevel
                : minLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            maxLevel: freezed == maxLevel
                ? _value.maxLevel
                : maxLevel // ignore: cast_nullable_to_non_nullable
                      as LevelTier?,
            pricePerPerson: null == pricePerPerson
                ? _value.pricePerPerson
                : pricePerPerson // ignore: cast_nullable_to_non_nullable
                      as int,
            pricing: freezed == pricing
                ? _value.pricing
                : pricing // ignore: cast_nullable_to_non_nullable
                      as SessionPricing?,
            displayTitle: freezed == displayTitle
                ? _value.displayTitle
                : displayTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            participantNames: null == participantNames
                ? _value.participantNames
                : participantNames // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OpenSessionStatus,
            joinDeadline: freezed == joinDeadline
                ? _value.joinDeadline
                : joinDeadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pricingModel: null == pricingModel
                ? _value.pricingModel
                : pricingModel // ignore: cast_nullable_to_non_nullable
                      as SessionPricingModel,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as SessionVisibility,
            courtCost: freezed == courtCost
                ? _value.courtCost
                : courtCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            coachCost: freezed == coachCost
                ? _value.coachCost
                : coachCost // ignore: cast_nullable_to_non_nullable
                      as int?,
            organizerFeePerPerson: freezed == organizerFeePerPerson
                ? _value.organizerFeePerPerson
                : organizerFeePerPerson // ignore: cast_nullable_to_non_nullable
                      as int?,
            settlementStatus: null == settlementStatus
                ? _value.settlementStatus
                : settlementStatus // ignore: cast_nullable_to_non_nullable
                      as SessionSettlementStatus,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as SessionHealth,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionPricingCopyWith<$Res>? get pricing {
    if (_value.pricing == null) {
      return null;
    }

    return $SessionPricingCopyWith<$Res>(_value.pricing!, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionHealthCopyWith<$Res> get health {
    return $SessionHealthCopyWith<$Res>(_value.health, (value) {
      return _then(_value.copyWith(health: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenSessionImplCopyWith<$Res>
    implements $OpenSessionCopyWith<$Res> {
  factory _$$OpenSessionImplCopyWith(
    _$OpenSessionImpl value,
    $Res Function(_$OpenSessionImpl) then,
  ) = __$$OpenSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? title,
    Sport sport,
    String hostId,
    String hostName,
    String venueName,
    String venueId,
    DateTime date,
    String startTime,
    String endTime,
    int currentPlayers,
    int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    int pricePerPerson,
    SessionPricing? pricing,
    @JsonKey(name: 'display_title') String? displayTitle,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    String? description,
    List<String> participantNames,
    OpenSessionStatus status,
    DateTime? joinDeadline,
    SessionPricingModel pricingModel,
    SessionVisibility visibility,
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
    SessionSettlementStatus settlementStatus,
    SessionHealth health,
  });

  @override
  $SessionPricingCopyWith<$Res>? get pricing;
  @override
  $SessionHealthCopyWith<$Res> get health;
}

/// @nodoc
class __$$OpenSessionImplCopyWithImpl<$Res>
    extends _$OpenSessionCopyWithImpl<$Res, _$OpenSessionImpl>
    implements _$$OpenSessionImplCopyWith<$Res> {
  __$$OpenSessionImplCopyWithImpl(
    _$OpenSessionImpl _value,
    $Res Function(_$OpenSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? sport = null,
    Object? hostId = null,
    Object? hostName = null,
    Object? venueName = null,
    Object? venueId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? currentPlayers = null,
    Object? maxPlayers = null,
    Object? minLevel = freezed,
    Object? maxLevel = freezed,
    Object? pricePerPerson = null,
    Object? pricing = freezed,
    Object? displayTitle = freezed,
    Object? photoPath = freezed,
    Object? photoUrls = freezed,
    Object? description = freezed,
    Object? participantNames = null,
    Object? status = null,
    Object? joinDeadline = freezed,
    Object? pricingModel = null,
    Object? visibility = null,
    Object? courtCost = freezed,
    Object? coachCost = freezed,
    Object? organizerFeePerPerson = freezed,
    Object? settlementStatus = null,
    Object? health = null,
  }) {
    return _then(
      _$OpenSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        sport: null == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        hostName: null == hostName
            ? _value.hostName
            : hostName // ignore: cast_nullable_to_non_nullable
                  as String,
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        venueId: null == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPlayers: null == currentPlayers
            ? _value.currentPlayers
            : currentPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        maxPlayers: null == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        minLevel: freezed == minLevel
            ? _value.minLevel
            : minLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        maxLevel: freezed == maxLevel
            ? _value.maxLevel
            : maxLevel // ignore: cast_nullable_to_non_nullable
                  as LevelTier?,
        pricePerPerson: null == pricePerPerson
            ? _value.pricePerPerson
            : pricePerPerson // ignore: cast_nullable_to_non_nullable
                  as int,
        pricing: freezed == pricing
            ? _value.pricing
            : pricing // ignore: cast_nullable_to_non_nullable
                  as SessionPricing?,
        displayTitle: freezed == displayTitle
            ? _value.displayTitle
            : displayTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantNames: null == participantNames
            ? _value._participantNames
            : participantNames // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OpenSessionStatus,
        joinDeadline: freezed == joinDeadline
            ? _value.joinDeadline
            : joinDeadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pricingModel: null == pricingModel
            ? _value.pricingModel
            : pricingModel // ignore: cast_nullable_to_non_nullable
                  as SessionPricingModel,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as SessionVisibility,
        courtCost: freezed == courtCost
            ? _value.courtCost
            : courtCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        coachCost: freezed == coachCost
            ? _value.coachCost
            : coachCost // ignore: cast_nullable_to_non_nullable
                  as int?,
        organizerFeePerPerson: freezed == organizerFeePerPerson
            ? _value.organizerFeePerPerson
            : organizerFeePerPerson // ignore: cast_nullable_to_non_nullable
                  as int?,
        settlementStatus: null == settlementStatus
            ? _value.settlementStatus
            : settlementStatus // ignore: cast_nullable_to_non_nullable
                  as SessionSettlementStatus,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as SessionHealth,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenSessionImpl implements _OpenSession {
  const _$OpenSessionImpl({
    required this.id,
    this.title,
    required this.sport,
    required this.hostId,
    required this.hostName,
    required this.venueName,
    required this.venueId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.currentPlayers = 0,
    this.maxPlayers = 1,
    this.minLevel,
    this.maxLevel,
    required this.pricePerPerson,
    this.pricing,
    @JsonKey(name: 'display_title') this.displayTitle,
    @JsonKey(name: 'photo_path') this.photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    this.description,
    final List<String> participantNames = const [],
    this.status = OpenSessionStatus.open,
    this.joinDeadline,
    this.pricingModel = SessionPricingModel.margin,
    this.visibility = SessionVisibility.free,
    this.courtCost,
    this.coachCost,
    this.organizerFeePerPerson,
    this.settlementStatus = SessionSettlementStatus.pending,
    this.health = const SessionHealth(),
  }) : _photoUrls = photoUrls,
       _participantNames = participantNames;

  factory _$OpenSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpenSessionImplFromJson(json);

  @override
  final String id;

  /// Raw editable title (nullable post-Issue 2026-05-07-session-title).
  /// Pre-feature-deploy BE sent auto-name here; consumers should read
  /// [displayTitle] (or use the `safeTitle` extension) which handles
  /// both windows.
  @override
  final String? title;
  @override
  final Sport sport;
  @override
  final String hostId;
  @override
  final String hostName;
  @override
  final String venueName;
  @override
  final String venueId;
  @override
  final DateTime date;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  @JsonKey()
  final int currentPlayers;
  @override
  @JsonKey()
  final int maxPlayers;
  @override
  final LevelTier? minLevel;
  @override
  final LevelTier? maxLevel;

  /// Legacy alias for `pricing.effective_price`. Prefer reading
  /// `pricing` directly — `pricePerPerson` doesn't carry payment mode,
  /// credit requirement, or currency.
  @override
  final int pricePerPerson;

  /// Resolved pricing block — source of truth for display. Nullable
  /// because mock fixtures may omit it; consumers fall back to
  /// `pricePerPerson` + tenant currency.
  @override
  final SessionPricing? pricing;

  /// `title ?? auto-name` from BE. Always non-null on a real response;
  /// nullable here so pre-feature-deploy responses (which omit this
  /// field) still parse — use the `safeTitle` extension at call sites.
  @override
  @JsonKey(name: 'display_title')
  final String? displayTitle;

  /// 8-char hash, null when no session-specific photo set. Used to
  /// distinguish "real session photo" (rectangular 16:9) from
  /// "fallback to tenant logo" (square) — when [photoUrls] is non-null
  /// but [photoPath] is null, the URLs point at the tenant logo and
  /// caller renders the centered-on-brand-color fallback layout.
  @override
  @JsonKey(name: 'photo_path')
  final String? photoPath;

  /// Hero photo URLs in 4 sizes (sm/md/lg/xl). When [photoPath] is set
  /// these are 16:9 session photos; otherwise BE returns the tenant
  /// `logo_urls` map (square) as the fallback. Null when neither
  /// session nor tenant has a photo.
  final Map<String, String>? _photoUrls;

  /// Hero photo URLs in 4 sizes (sm/md/lg/xl). When [photoPath] is set
  /// these are 16:9 session photos; otherwise BE returns the tenant
  /// `logo_urls` map (square) as the fallback. Null when neither
  /// session nor tenant has a photo.
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableMapView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? description;
  final List<String> _participantNames;
  @override
  @JsonKey()
  List<String> get participantNames {
    if (_participantNames is EqualUnmodifiableListView)
      return _participantNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantNames);
  }

  @override
  @JsonKey()
  final OpenSessionStatus status;
  @override
  final DateTime? joinDeadline;
  @override
  @JsonKey()
  final SessionPricingModel pricingModel;
  @override
  @JsonKey()
  final SessionVisibility visibility;
  @override
  final int? courtCost;
  @override
  final int? coachCost;
  @override
  final int? organizerFeePerPerson;
  @override
  @JsonKey()
  final SessionSettlementStatus settlementStatus;
  @override
  @JsonKey()
  final SessionHealth health;

  @override
  String toString() {
    return 'OpenSession(id: $id, title: $title, sport: $sport, hostId: $hostId, hostName: $hostName, venueName: $venueName, venueId: $venueId, date: $date, startTime: $startTime, endTime: $endTime, currentPlayers: $currentPlayers, maxPlayers: $maxPlayers, minLevel: $minLevel, maxLevel: $maxLevel, pricePerPerson: $pricePerPerson, pricing: $pricing, displayTitle: $displayTitle, photoPath: $photoPath, photoUrls: $photoUrls, description: $description, participantNames: $participantNames, status: $status, joinDeadline: $joinDeadline, pricingModel: $pricingModel, visibility: $visibility, courtCost: $courtCost, coachCost: $coachCost, organizerFeePerPerson: $organizerFeePerPerson, settlementStatus: $settlementStatus, health: $health)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.hostName, hostName) ||
                other.hostName == hostName) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.currentPlayers, currentPlayers) ||
                other.currentPlayers == currentPlayers) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.minLevel, minLevel) ||
                other.minLevel == minLevel) &&
            (identical(other.maxLevel, maxLevel) ||
                other.maxLevel == maxLevel) &&
            (identical(other.pricePerPerson, pricePerPerson) ||
                other.pricePerPerson == pricePerPerson) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._participantNames,
              _participantNames,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinDeadline, joinDeadline) ||
                other.joinDeadline == joinDeadline) &&
            (identical(other.pricingModel, pricingModel) ||
                other.pricingModel == pricingModel) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.courtCost, courtCost) ||
                other.courtCost == courtCost) &&
            (identical(other.coachCost, coachCost) ||
                other.coachCost == coachCost) &&
            (identical(other.organizerFeePerPerson, organizerFeePerPerson) ||
                other.organizerFeePerPerson == organizerFeePerPerson) &&
            (identical(other.settlementStatus, settlementStatus) ||
                other.settlementStatus == settlementStatus) &&
            (identical(other.health, health) || other.health == health));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    sport,
    hostId,
    hostName,
    venueName,
    venueId,
    date,
    startTime,
    endTime,
    currentPlayers,
    maxPlayers,
    minLevel,
    maxLevel,
    pricePerPerson,
    pricing,
    displayTitle,
    photoPath,
    const DeepCollectionEquality().hash(_photoUrls),
    description,
    const DeepCollectionEquality().hash(_participantNames),
    status,
    joinDeadline,
    pricingModel,
    visibility,
    courtCost,
    coachCost,
    organizerFeePerPerson,
    settlementStatus,
    health,
  ]);

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenSessionImplCopyWith<_$OpenSessionImpl> get copyWith =>
      __$$OpenSessionImplCopyWithImpl<_$OpenSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenSessionImplToJson(this);
  }
}

abstract class _OpenSession implements OpenSession {
  const factory _OpenSession({
    required final String id,
    final String? title,
    required final Sport sport,
    required final String hostId,
    required final String hostName,
    required final String venueName,
    required final String venueId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    final int currentPlayers,
    final int maxPlayers,
    final LevelTier? minLevel,
    final LevelTier? maxLevel,
    required final int pricePerPerson,
    final SessionPricing? pricing,
    @JsonKey(name: 'display_title') final String? displayTitle,
    @JsonKey(name: 'photo_path') final String? photoPath,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    final String? description,
    final List<String> participantNames,
    final OpenSessionStatus status,
    final DateTime? joinDeadline,
    final SessionPricingModel pricingModel,
    final SessionVisibility visibility,
    final int? courtCost,
    final int? coachCost,
    final int? organizerFeePerPerson,
    final SessionSettlementStatus settlementStatus,
    final SessionHealth health,
  }) = _$OpenSessionImpl;

  factory _OpenSession.fromJson(Map<String, dynamic> json) =
      _$OpenSessionImpl.fromJson;

  @override
  String get id;

  /// Raw editable title (nullable post-Issue 2026-05-07-session-title).
  /// Pre-feature-deploy BE sent auto-name here; consumers should read
  /// [displayTitle] (or use the `safeTitle` extension) which handles
  /// both windows.
  @override
  String? get title;
  @override
  Sport get sport;
  @override
  String get hostId;
  @override
  String get hostName;
  @override
  String get venueName;
  @override
  String get venueId;
  @override
  DateTime get date;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int get currentPlayers;
  @override
  int get maxPlayers;
  @override
  LevelTier? get minLevel;
  @override
  LevelTier? get maxLevel;

  /// Legacy alias for `pricing.effective_price`. Prefer reading
  /// `pricing` directly — `pricePerPerson` doesn't carry payment mode,
  /// credit requirement, or currency.
  @override
  int get pricePerPerson;

  /// Resolved pricing block — source of truth for display. Nullable
  /// because mock fixtures may omit it; consumers fall back to
  /// `pricePerPerson` + tenant currency.
  @override
  SessionPricing? get pricing;

  /// `title ?? auto-name` from BE. Always non-null on a real response;
  /// nullable here so pre-feature-deploy responses (which omit this
  /// field) still parse — use the `safeTitle` extension at call sites.
  @override
  @JsonKey(name: 'display_title')
  String? get displayTitle;

  /// 8-char hash, null when no session-specific photo set. Used to
  /// distinguish "real session photo" (rectangular 16:9) from
  /// "fallback to tenant logo" (square) — when [photoUrls] is non-null
  /// but [photoPath] is null, the URLs point at the tenant logo and
  /// caller renders the centered-on-brand-color fallback layout.
  @override
  @JsonKey(name: 'photo_path')
  String? get photoPath;

  /// Hero photo URLs in 4 sizes (sm/md/lg/xl). When [photoPath] is set
  /// these are 16:9 session photos; otherwise BE returns the tenant
  /// `logo_urls` map (square) as the fallback. Null when neither
  /// session nor tenant has a photo.
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;
  @override
  String? get description;
  @override
  List<String> get participantNames;
  @override
  OpenSessionStatus get status;
  @override
  DateTime? get joinDeadline;
  @override
  SessionPricingModel get pricingModel;
  @override
  SessionVisibility get visibility;
  @override
  int? get courtCost;
  @override
  int? get coachCost;
  @override
  int? get organizerFeePerPerson;
  @override
  SessionSettlementStatus get settlementStatus;
  @override
  SessionHealth get health;

  /// Create a copy of OpenSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenSessionImplCopyWith<_$OpenSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
