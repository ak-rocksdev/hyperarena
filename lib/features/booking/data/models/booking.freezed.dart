// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  BookingType get bookingType => throw _privateConstructorUsedError;
  String get bookingCode => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String? get venueId => throw _privateConstructorUsedError;
  String? get courtId => throw _privateConstructorUsedError;
  DateTime get bookingDate => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  PaymentMethodType get paymentMethod => throw _privateConstructorUsedError;
  String? get paymentProofUrl => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get venueName => throw _privateConstructorUsedError;
  String? get courtName => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    BookingType bookingType,
    String bookingCode,
    String playerId,
    String? venueId,
    String? courtId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int totalAmount,
    BookingStatus status,
    PaymentMethodType paymentMethod,
    String? paymentProofUrl,
    DateTime? expiresAt,
    DateTime createdAt,
    String? venueName,
    String? courtName,
  });
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingType = null,
    Object? bookingCode = null,
    Object? playerId = null,
    Object? venueId = freezed,
    Object? courtId = freezed,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentProofUrl = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? venueName = freezed,
    Object? courtName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingType: null == bookingType
                ? _value.bookingType
                : bookingType // ignore: cast_nullable_to_non_nullable
                      as BookingType,
            bookingCode: null == bookingCode
                ? _value.bookingCode
                : bookingCode // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            venueId: freezed == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String?,
            courtId: freezed == courtId
                ? _value.courtId
                : courtId // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookingStatus,
            paymentMethod: null == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethodType,
            paymentProofUrl: freezed == paymentProofUrl
                ? _value.paymentProofUrl
                : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            venueName: freezed == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String?,
            courtName: freezed == courtName
                ? _value.courtName
                : courtName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    BookingType bookingType,
    String bookingCode,
    String playerId,
    String? venueId,
    String? courtId,
    DateTime bookingDate,
    String startTime,
    String endTime,
    int totalAmount,
    BookingStatus status,
    PaymentMethodType paymentMethod,
    String? paymentProofUrl,
    DateTime? expiresAt,
    DateTime createdAt,
    String? venueName,
    String? courtName,
  });
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookingType = null,
    Object? bookingCode = null,
    Object? playerId = null,
    Object? venueId = freezed,
    Object? courtId = freezed,
    Object? bookingDate = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? paymentProofUrl = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? venueName = freezed,
    Object? courtName = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingType: null == bookingType
            ? _value.bookingType
            : bookingType // ignore: cast_nullable_to_non_nullable
                  as BookingType,
        bookingCode: null == bookingCode
            ? _value.bookingCode
            : bookingCode // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        venueId: freezed == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String?,
        courtId: freezed == courtId
            ? _value.courtId
            : courtId // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookingStatus,
        paymentMethod: null == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethodType,
        paymentProofUrl: freezed == paymentProofUrl
            ? _value.paymentProofUrl
            : paymentProofUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        venueName: freezed == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String?,
        courtName: freezed == courtName
            ? _value.courtName
            : courtName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.bookingType,
    required this.bookingCode,
    required this.playerId,
    this.venueId,
    this.courtId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.paymentProofUrl,
    this.expiresAt,
    required this.createdAt,
    this.venueName,
    this.courtName,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final BookingType bookingType;
  @override
  final String bookingCode;
  @override
  final String playerId;
  @override
  final String? venueId;
  @override
  final String? courtId;
  @override
  final DateTime bookingDate;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final int totalAmount;
  @override
  final BookingStatus status;
  @override
  final PaymentMethodType paymentMethod;
  @override
  final String? paymentProofUrl;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;
  @override
  final String? venueName;
  @override
  final String? courtName;

  @override
  String toString() {
    return 'Booking(id: $id, bookingType: $bookingType, bookingCode: $bookingCode, playerId: $playerId, venueId: $venueId, courtId: $courtId, bookingDate: $bookingDate, startTime: $startTime, endTime: $endTime, totalAmount: $totalAmount, status: $status, paymentMethod: $paymentMethod, paymentProofUrl: $paymentProofUrl, expiresAt: $expiresAt, createdAt: $createdAt, venueName: $venueName, courtName: $courtName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType) &&
            (identical(other.bookingCode, bookingCode) ||
                other.bookingCode == bookingCode) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentProofUrl, paymentProofUrl) ||
                other.paymentProofUrl == paymentProofUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.courtName, courtName) ||
                other.courtName == courtName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    bookingType,
    bookingCode,
    playerId,
    venueId,
    courtId,
    bookingDate,
    startTime,
    endTime,
    totalAmount,
    status,
    paymentMethod,
    paymentProofUrl,
    expiresAt,
    createdAt,
    venueName,
    courtName,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final BookingType bookingType,
    required final String bookingCode,
    required final String playerId,
    final String? venueId,
    final String? courtId,
    required final DateTime bookingDate,
    required final String startTime,
    required final String endTime,
    required final int totalAmount,
    required final BookingStatus status,
    required final PaymentMethodType paymentMethod,
    final String? paymentProofUrl,
    final DateTime? expiresAt,
    required final DateTime createdAt,
    final String? venueName,
    final String? courtName,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  BookingType get bookingType;
  @override
  String get bookingCode;
  @override
  String get playerId;
  @override
  String? get venueId;
  @override
  String? get courtId;
  @override
  DateTime get bookingDate;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int get totalAmount;
  @override
  BookingStatus get status;
  @override
  PaymentMethodType get paymentMethod;
  @override
  String? get paymentProofUrl;
  @override
  DateTime? get expiresAt;
  @override
  DateTime get createdAt;
  @override
  String? get venueName;
  @override
  String? get courtName;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
