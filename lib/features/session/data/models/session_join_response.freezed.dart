// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_join_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionJoinResponse _$SessionJoinResponseFromJson(Map<String, dynamic> json) {
  return _SessionJoinResponse.fromJson(json);
}

/// @nodoc
mixin _$SessionJoinResponse {
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_credit')
  bool get usedCredit => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit_balance_after')
  int? get creditBalanceAfter => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_id')
  int? get purchaseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  JoinBookingInfo get booking => throw _privateConstructorUsedError;

  /// Serializes this SessionJoinResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionJoinResponseCopyWith<SessionJoinResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionJoinResponseCopyWith<$Res> {
  factory $SessionJoinResponseCopyWith(
    SessionJoinResponse value,
    $Res Function(SessionJoinResponse) then,
  ) = _$SessionJoinResponseCopyWithImpl<$Res, SessionJoinResponse>;
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'used_credit') bool usedCredit,
    @JsonKey(name: 'credit_balance_after') int? creditBalanceAfter,
    @JsonKey(name: 'purchase_id') int? purchaseId,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String message,
    JoinBookingInfo booking,
  });

  $JoinBookingInfoCopyWith<$Res> get booking;
}

/// @nodoc
class _$SessionJoinResponseCopyWithImpl<$Res, $Val extends SessionJoinResponse>
    implements $SessionJoinResponseCopyWith<$Res> {
  _$SessionJoinResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? usedCredit = null,
    Object? creditBalanceAfter = freezed,
    Object? purchaseId = freezed,
    Object? expiresAt = freezed,
    Object? message = null,
    Object? booking = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            usedCredit: null == usedCredit
                ? _value.usedCredit
                : usedCredit // ignore: cast_nullable_to_non_nullable
                      as bool,
            creditBalanceAfter: freezed == creditBalanceAfter
                ? _value.creditBalanceAfter
                : creditBalanceAfter // ignore: cast_nullable_to_non_nullable
                      as int?,
            purchaseId: freezed == purchaseId
                ? _value.purchaseId
                : purchaseId // ignore: cast_nullable_to_non_nullable
                      as int?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            booking: null == booking
                ? _value.booking
                : booking // ignore: cast_nullable_to_non_nullable
                      as JoinBookingInfo,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $JoinBookingInfoCopyWith<$Res> get booking {
    return $JoinBookingInfoCopyWith<$Res>(_value.booking, (value) {
      return _then(_value.copyWith(booking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionJoinResponseImplCopyWith<$Res>
    implements $SessionJoinResponseCopyWith<$Res> {
  factory _$$SessionJoinResponseImplCopyWith(
    _$SessionJoinResponseImpl value,
    $Res Function(_$SessionJoinResponseImpl) then,
  ) = __$$SessionJoinResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    @JsonKey(name: 'used_credit') bool usedCredit,
    @JsonKey(name: 'credit_balance_after') int? creditBalanceAfter,
    @JsonKey(name: 'purchase_id') int? purchaseId,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
    String message,
    JoinBookingInfo booking,
  });

  @override
  $JoinBookingInfoCopyWith<$Res> get booking;
}

/// @nodoc
class __$$SessionJoinResponseImplCopyWithImpl<$Res>
    extends _$SessionJoinResponseCopyWithImpl<$Res, _$SessionJoinResponseImpl>
    implements _$$SessionJoinResponseImplCopyWith<$Res> {
  __$$SessionJoinResponseImplCopyWithImpl(
    _$SessionJoinResponseImpl _value,
    $Res Function(_$SessionJoinResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? usedCredit = null,
    Object? creditBalanceAfter = freezed,
    Object? purchaseId = freezed,
    Object? expiresAt = freezed,
    Object? message = null,
    Object? booking = null,
  }) {
    return _then(
      _$SessionJoinResponseImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        usedCredit: null == usedCredit
            ? _value.usedCredit
            : usedCredit // ignore: cast_nullable_to_non_nullable
                  as bool,
        creditBalanceAfter: freezed == creditBalanceAfter
            ? _value.creditBalanceAfter
            : creditBalanceAfter // ignore: cast_nullable_to_non_nullable
                  as int?,
        purchaseId: freezed == purchaseId
            ? _value.purchaseId
            : purchaseId // ignore: cast_nullable_to_non_nullable
                  as int?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        booking: null == booking
            ? _value.booking
            : booking // ignore: cast_nullable_to_non_nullable
                  as JoinBookingInfo,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionJoinResponseImpl implements _SessionJoinResponse {
  const _$SessionJoinResponseImpl({
    required this.status,
    @JsonKey(name: 'used_credit') required this.usedCredit,
    @JsonKey(name: 'credit_balance_after') this.creditBalanceAfter,
    @JsonKey(name: 'purchase_id') this.purchaseId,
    @JsonKey(name: 'expires_at') this.expiresAt,
    required this.message,
    required this.booking,
  });

  factory _$SessionJoinResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionJoinResponseImplFromJson(json);

  @override
  final String status;
  @override
  @JsonKey(name: 'used_credit')
  final bool usedCredit;
  @override
  @JsonKey(name: 'credit_balance_after')
  final int? creditBalanceAfter;
  @override
  @JsonKey(name: 'purchase_id')
  final int? purchaseId;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @override
  final String message;
  @override
  final JoinBookingInfo booking;

  @override
  String toString() {
    return 'SessionJoinResponse(status: $status, usedCredit: $usedCredit, creditBalanceAfter: $creditBalanceAfter, purchaseId: $purchaseId, expiresAt: $expiresAt, message: $message, booking: $booking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionJoinResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.usedCredit, usedCredit) ||
                other.usedCredit == usedCredit) &&
            (identical(other.creditBalanceAfter, creditBalanceAfter) ||
                other.creditBalanceAfter == creditBalanceAfter) &&
            (identical(other.purchaseId, purchaseId) ||
                other.purchaseId == purchaseId) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.booking, booking) || other.booking == booking));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    usedCredit,
    creditBalanceAfter,
    purchaseId,
    expiresAt,
    message,
    booking,
  );

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionJoinResponseImplCopyWith<_$SessionJoinResponseImpl> get copyWith =>
      __$$SessionJoinResponseImplCopyWithImpl<_$SessionJoinResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionJoinResponseImplToJson(this);
  }
}

abstract class _SessionJoinResponse implements SessionJoinResponse {
  const factory _SessionJoinResponse({
    required final String status,
    @JsonKey(name: 'used_credit') required final bool usedCredit,
    @JsonKey(name: 'credit_balance_after') final int? creditBalanceAfter,
    @JsonKey(name: 'purchase_id') final int? purchaseId,
    @JsonKey(name: 'expires_at') final DateTime? expiresAt,
    required final String message,
    required final JoinBookingInfo booking,
  }) = _$SessionJoinResponseImpl;

  factory _SessionJoinResponse.fromJson(Map<String, dynamic> json) =
      _$SessionJoinResponseImpl.fromJson;

  @override
  String get status;
  @override
  @JsonKey(name: 'used_credit')
  bool get usedCredit;
  @override
  @JsonKey(name: 'credit_balance_after')
  int? get creditBalanceAfter;
  @override
  @JsonKey(name: 'purchase_id')
  int? get purchaseId;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;
  @override
  String get message;
  @override
  JoinBookingInfo get booking;

  /// Create a copy of SessionJoinResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionJoinResponseImplCopyWith<_$SessionJoinResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JoinBookingInfo _$JoinBookingInfoFromJson(Map<String, dynamic> json) {
  return _JoinBookingInfo.fromJson(json);
}

/// @nodoc
mixin _$JoinBookingInfo {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'booked_at')
  DateTime get bookedAt => throw _privateConstructorUsedError;

  /// Serializes this JoinBookingInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JoinBookingInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JoinBookingInfoCopyWith<JoinBookingInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JoinBookingInfoCopyWith<$Res> {
  factory $JoinBookingInfoCopyWith(
    JoinBookingInfo value,
    $Res Function(JoinBookingInfo) then,
  ) = _$JoinBookingInfoCopyWithImpl<$Res, JoinBookingInfo>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    @JsonKey(name: 'booked_at') DateTime bookedAt,
  });
}

/// @nodoc
class _$JoinBookingInfoCopyWithImpl<$Res, $Val extends JoinBookingInfo>
    implements $JoinBookingInfoCopyWith<$Res> {
  _$JoinBookingInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JoinBookingInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? bookedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            bookedAt: null == bookedAt
                ? _value.bookedAt
                : bookedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JoinBookingInfoImplCopyWith<$Res>
    implements $JoinBookingInfoCopyWith<$Res> {
  factory _$$JoinBookingInfoImplCopyWith(
    _$JoinBookingInfoImpl value,
    $Res Function(_$JoinBookingInfoImpl) then,
  ) = __$$JoinBookingInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'session_id', fromJson: idFromJson) String sessionId,
    @JsonKey(name: 'booked_at') DateTime bookedAt,
  });
}

/// @nodoc
class __$$JoinBookingInfoImplCopyWithImpl<$Res>
    extends _$JoinBookingInfoCopyWithImpl<$Res, _$JoinBookingInfoImpl>
    implements _$$JoinBookingInfoImplCopyWith<$Res> {
  __$$JoinBookingInfoImplCopyWithImpl(
    _$JoinBookingInfoImpl _value,
    $Res Function(_$JoinBookingInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JoinBookingInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? bookedAt = null,
  }) {
    return _then(
      _$JoinBookingInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookedAt: null == bookedAt
            ? _value.bookedAt
            : bookedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JoinBookingInfoImpl implements _JoinBookingInfo {
  const _$JoinBookingInfoImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'session_id', fromJson: idFromJson) required this.sessionId,
    @JsonKey(name: 'booked_at') required this.bookedAt,
  });

  factory _$JoinBookingInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$JoinBookingInfoImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  final String sessionId;
  @override
  @JsonKey(name: 'booked_at')
  final DateTime bookedAt;

  @override
  String toString() {
    return 'JoinBookingInfo(id: $id, sessionId: $sessionId, bookedAt: $bookedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JoinBookingInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.bookedAt, bookedAt) ||
                other.bookedAt == bookedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sessionId, bookedAt);

  /// Create a copy of JoinBookingInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JoinBookingInfoImplCopyWith<_$JoinBookingInfoImpl> get copyWith =>
      __$$JoinBookingInfoImplCopyWithImpl<_$JoinBookingInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JoinBookingInfoImplToJson(this);
  }
}

abstract class _JoinBookingInfo implements JoinBookingInfo {
  const factory _JoinBookingInfo({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'session_id', fromJson: idFromJson)
    required final String sessionId,
    @JsonKey(name: 'booked_at') required final DateTime bookedAt,
  }) = _$JoinBookingInfoImpl;

  factory _JoinBookingInfo.fromJson(Map<String, dynamic> json) =
      _$JoinBookingInfoImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'session_id', fromJson: idFromJson)
  String get sessionId;
  @override
  @JsonKey(name: 'booked_at')
  DateTime get bookedAt;

  /// Create a copy of JoinBookingInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JoinBookingInfoImplCopyWith<_$JoinBookingInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
