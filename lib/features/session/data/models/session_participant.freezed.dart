// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionParticipant _$SessionParticipantFromJson(Map<String, dynamic> json) {
  return _SessionParticipant.fromJson(json);
}

/// @nodoc
mixin _$SessionParticipant {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String? get bookingId => throw _privateConstructorUsedError;
  SessionParticipantStatus get status => throw _privateConstructorUsedError;
  PaymentMethodType get paymentMethod => throw _privateConstructorUsedError;
  int get paidAmount => throw _privateConstructorUsedError;
  DateTime? get paidAt => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String? get refundReason => throw _privateConstructorUsedError;
  String? get disputeReason => throw _privateConstructorUsedError;
  String? get evidenceUrl => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this SessionParticipant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionParticipantCopyWith<SessionParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionParticipantCopyWith<$Res> {
  factory $SessionParticipantCopyWith(
    SessionParticipant value,
    $Res Function(SessionParticipant) then,
  ) = _$SessionParticipantCopyWithImpl<$Res, SessionParticipant>;
  @useResult
  $Res call({
    String id,
    String sessionId,
    String playerId,
    String playerName,
    String? bookingId,
    SessionParticipantStatus status,
    PaymentMethodType paymentMethod,
    int paidAmount,
    DateTime? paidAt,
    DateTime? confirmedAt,
    String? note,
    String? rejectionReason,
    String? refundReason,
    String? disputeReason,
    String? evidenceUrl,
    DateTime joinedAt,
  });
}

/// @nodoc
class _$SessionParticipantCopyWithImpl<$Res, $Val extends SessionParticipant>
    implements $SessionParticipantCopyWith<$Res> {
  _$SessionParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? bookingId = freezed,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paidAmount = null,
    Object? paidAt = freezed,
    Object? confirmedAt = freezed,
    Object? note = freezed,
    Object? rejectionReason = freezed,
    Object? refundReason = freezed,
    Object? disputeReason = freezed,
    Object? evidenceUrl = freezed,
    Object? joinedAt = null,
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
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingId: freezed == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SessionParticipantStatus,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethodType,
            paidAmount: null == paidAmount
                ? _value.paidAmount
                : paidAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            confirmedAt: freezed == confirmedAt
                ? _value.confirmedAt
                : confirmedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            refundReason: freezed == refundReason
                ? _value.refundReason
                : refundReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            disputeReason: freezed == disputeReason
                ? _value.disputeReason
                : disputeReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            evidenceUrl: freezed == evidenceUrl
                ? _value.evidenceUrl
                : evidenceUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionParticipantImplCopyWith<$Res>
    implements $SessionParticipantCopyWith<$Res> {
  factory _$$SessionParticipantImplCopyWith(
    _$SessionParticipantImpl value,
    $Res Function(_$SessionParticipantImpl) then,
  ) = __$$SessionParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sessionId,
    String playerId,
    String playerName,
    String? bookingId,
    SessionParticipantStatus status,
    PaymentMethodType paymentMethod,
    int paidAmount,
    DateTime? paidAt,
    DateTime? confirmedAt,
    String? note,
    String? rejectionReason,
    String? refundReason,
    String? disputeReason,
    String? evidenceUrl,
    DateTime joinedAt,
  });
}

/// @nodoc
class __$$SessionParticipantImplCopyWithImpl<$Res>
    extends _$SessionParticipantCopyWithImpl<$Res, _$SessionParticipantImpl>
    implements _$$SessionParticipantImplCopyWith<$Res> {
  __$$SessionParticipantImplCopyWithImpl(
    _$SessionParticipantImpl _value,
    $Res Function(_$SessionParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? bookingId = freezed,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paidAmount = null,
    Object? paidAt = freezed,
    Object? confirmedAt = freezed,
    Object? note = freezed,
    Object? rejectionReason = freezed,
    Object? refundReason = freezed,
    Object? disputeReason = freezed,
    Object? evidenceUrl = freezed,
    Object? joinedAt = null,
  }) {
    return _then(
      _$SessionParticipantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingId: freezed == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SessionParticipantStatus,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethodType,
        paidAmount: null == paidAmount
            ? _value.paidAmount
            : paidAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        confirmedAt: freezed == confirmedAt
            ? _value.confirmedAt
            : confirmedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        refundReason: freezed == refundReason
            ? _value.refundReason
            : refundReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        disputeReason: freezed == disputeReason
            ? _value.disputeReason
            : disputeReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        evidenceUrl: freezed == evidenceUrl
            ? _value.evidenceUrl
            : evidenceUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionParticipantImpl implements _SessionParticipant {
  const _$SessionParticipantImpl({
    required this.id,
    required this.sessionId,
    required this.playerId,
    required this.playerName,
    this.bookingId,
    this.status = SessionParticipantStatus.pendingPayment,
    this.paymentMethod = PaymentMethodType.qris,
    this.paidAmount = 0,
    this.paidAt,
    this.confirmedAt,
    this.note,
    this.rejectionReason,
    this.refundReason,
    this.disputeReason,
    this.evidenceUrl,
    required this.joinedAt,
  });

  factory _$SessionParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionParticipantImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String? bookingId;
  @override
  @JsonKey()
  final SessionParticipantStatus status;
  @override
  @JsonKey()
  final PaymentMethodType paymentMethod;
  @override
  @JsonKey()
  final int paidAmount;
  @override
  final DateTime? paidAt;
  @override
  final DateTime? confirmedAt;
  @override
  final String? note;
  @override
  final String? rejectionReason;
  @override
  final String? refundReason;
  @override
  final String? disputeReason;
  @override
  final String? evidenceUrl;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'SessionParticipant(id: $id, sessionId: $sessionId, playerId: $playerId, playerName: $playerName, bookingId: $bookingId, status: $status, paymentMethod: $paymentMethod, paidAmount: $paidAmount, paidAt: $paidAt, confirmedAt: $confirmedAt, note: $note, rejectionReason: $rejectionReason, refundReason: $refundReason, disputeReason: $disputeReason, evidenceUrl: $evidenceUrl, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            (identical(other.disputeReason, disputeReason) ||
                other.disputeReason == disputeReason) &&
            (identical(other.evidenceUrl, evidenceUrl) ||
                other.evidenceUrl == evidenceUrl) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    playerId,
    playerName,
    bookingId,
    status,
    paymentMethod,
    paidAmount,
    paidAt,
    confirmedAt,
    note,
    rejectionReason,
    refundReason,
    disputeReason,
    evidenceUrl,
    joinedAt,
  );

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      __$$SessionParticipantImplCopyWithImpl<_$SessionParticipantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionParticipantImplToJson(this);
  }
}

abstract class _SessionParticipant implements SessionParticipant {
  const factory _SessionParticipant({
    required final String id,
    required final String sessionId,
    required final String playerId,
    required final String playerName,
    final String? bookingId,
    final SessionParticipantStatus status,
    final PaymentMethodType paymentMethod,
    final int paidAmount,
    final DateTime? paidAt,
    final DateTime? confirmedAt,
    final String? note,
    final String? rejectionReason,
    final String? refundReason,
    final String? disputeReason,
    final String? evidenceUrl,
    required final DateTime joinedAt,
  }) = _$SessionParticipantImpl;

  factory _SessionParticipant.fromJson(Map<String, dynamic> json) =
      _$SessionParticipantImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String? get bookingId;
  @override
  SessionParticipantStatus get status;
  @override
  PaymentMethodType get paymentMethod;
  @override
  int get paidAmount;
  @override
  DateTime? get paidAt;
  @override
  DateTime? get confirmedAt;
  @override
  String? get note;
  @override
  String? get rejectionReason;
  @override
  String? get refundReason;
  @override
  String? get disputeReason;
  @override
  String? get evidenceUrl;
  @override
  DateTime get joinedAt;

  /// Create a copy of SessionParticipant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionParticipantImplCopyWith<_$SessionParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
