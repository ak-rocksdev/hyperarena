// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_payout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachPayout _$CoachPayoutFromJson(Map<String, dynamic> json) {
  return _CoachPayout.fromJson(json);
}

/// @nodoc
mixin _$CoachPayout {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id')
  int? get sessionId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending' | 'approved' | 'paid'
  @JsonKey(name: 'request_id')
  int? get requestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Server-side join shape: `session: { id, type, start_at, duration_minutes }`.
  @JsonKey(name: 'session')
  Map<String, dynamic>? get sessionMeta => throw _privateConstructorUsedError;

  /// Serializes this CoachPayout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachPayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachPayoutCopyWith<CoachPayout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachPayoutCopyWith<$Res> {
  factory $CoachPayoutCopyWith(
    CoachPayout value,
    $Res Function(CoachPayout) then,
  ) = _$CoachPayoutCopyWithImpl<$Res, CoachPayout>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'session_id') int? sessionId,
    int amount,
    String currency,
    String period,
    String status,
    @JsonKey(name: 'request_id') int? requestId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'session') Map<String, dynamic>? sessionMeta,
  });
}

/// @nodoc
class _$CoachPayoutCopyWithImpl<$Res, $Val extends CoachPayout>
    implements $CoachPayoutCopyWith<$Res> {
  _$CoachPayoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachPayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? period = null,
    Object? status = null,
    Object? requestId = freezed,
    Object? createdAt = null,
    Object? sessionMeta = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            requestId: freezed == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sessionMeta: freezed == sessionMeta
                ? _value.sessionMeta
                : sessionMeta // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachPayoutImplCopyWith<$Res>
    implements $CoachPayoutCopyWith<$Res> {
  factory _$$CoachPayoutImplCopyWith(
    _$CoachPayoutImpl value,
    $Res Function(_$CoachPayoutImpl) then,
  ) = __$$CoachPayoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'session_id') int? sessionId,
    int amount,
    String currency,
    String period,
    String status,
    @JsonKey(name: 'request_id') int? requestId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'session') Map<String, dynamic>? sessionMeta,
  });
}

/// @nodoc
class __$$CoachPayoutImplCopyWithImpl<$Res>
    extends _$CoachPayoutCopyWithImpl<$Res, _$CoachPayoutImpl>
    implements _$$CoachPayoutImplCopyWith<$Res> {
  __$$CoachPayoutImplCopyWithImpl(
    _$CoachPayoutImpl _value,
    $Res Function(_$CoachPayoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachPayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = freezed,
    Object? amount = null,
    Object? currency = null,
    Object? period = null,
    Object? status = null,
    Object? requestId = freezed,
    Object? createdAt = null,
    Object? sessionMeta = freezed,
  }) {
    return _then(
      _$CoachPayoutImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        requestId: freezed == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sessionMeta: freezed == sessionMeta
            ? _value._sessionMeta
            : sessionMeta // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachPayoutImpl implements _CoachPayout {
  const _$CoachPayoutImpl({
    required this.id,
    @JsonKey(name: 'session_id') this.sessionId,
    required this.amount,
    required this.currency,
    required this.period,
    required this.status,
    @JsonKey(name: 'request_id') this.requestId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'session') final Map<String, dynamic>? sessionMeta,
  }) : _sessionMeta = sessionMeta;

  factory _$CoachPayoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachPayoutImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'session_id')
  final int? sessionId;
  @override
  final int amount;
  @override
  final String currency;
  @override
  final String period;
  @override
  final String status;
  // 'pending' | 'approved' | 'paid'
  @override
  @JsonKey(name: 'request_id')
  final int? requestId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Server-side join shape: `session: { id, type, start_at, duration_minutes }`.
  final Map<String, dynamic>? _sessionMeta;

  /// Server-side join shape: `session: { id, type, start_at, duration_minutes }`.
  @override
  @JsonKey(name: 'session')
  Map<String, dynamic>? get sessionMeta {
    final value = _sessionMeta;
    if (value == null) return null;
    if (_sessionMeta is EqualUnmodifiableMapView) return _sessionMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CoachPayout(id: $id, sessionId: $sessionId, amount: $amount, currency: $currency, period: $period, status: $status, requestId: $requestId, createdAt: $createdAt, sessionMeta: $sessionMeta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachPayoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._sessionMeta,
              _sessionMeta,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    amount,
    currency,
    period,
    status,
    requestId,
    createdAt,
    const DeepCollectionEquality().hash(_sessionMeta),
  );

  /// Create a copy of CoachPayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachPayoutImplCopyWith<_$CoachPayoutImpl> get copyWith =>
      __$$CoachPayoutImplCopyWithImpl<_$CoachPayoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachPayoutImplToJson(this);
  }
}

abstract class _CoachPayout implements CoachPayout {
  const factory _CoachPayout({
    required final int id,
    @JsonKey(name: 'session_id') final int? sessionId,
    required final int amount,
    required final String currency,
    required final String period,
    required final String status,
    @JsonKey(name: 'request_id') final int? requestId,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'session') final Map<String, dynamic>? sessionMeta,
  }) = _$CoachPayoutImpl;

  factory _CoachPayout.fromJson(Map<String, dynamic> json) =
      _$CoachPayoutImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'session_id')
  int? get sessionId;
  @override
  int get amount;
  @override
  String get currency;
  @override
  String get period;
  @override
  String get status; // 'pending' | 'approved' | 'paid'
  @override
  @JsonKey(name: 'request_id')
  int? get requestId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Server-side join shape: `session: { id, type, start_at, duration_minutes }`.
  @override
  @JsonKey(name: 'session')
  Map<String, dynamic>? get sessionMeta;

  /// Create a copy of CoachPayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachPayoutImplCopyWith<_$CoachPayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
