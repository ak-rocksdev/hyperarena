// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachingBooking _$CoachingBookingFromJson(Map<String, dynamic> json) {
  return _CoachingBooking.fromJson(json);
}

/// @nodoc
mixin _$CoachingBooking {
  String get id => throw _privateConstructorUsedError;
  String get coachId => throw _privateConstructorUsedError;
  String get coachName => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get packageId => throw _privateConstructorUsedError;
  String get packageName => throw _privateConstructorUsedError;
  Sport get sport => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CoachingBooking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachingBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachingBookingCopyWith<CoachingBooking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachingBookingCopyWith<$Res> {
  factory $CoachingBookingCopyWith(
    CoachingBooking value,
    $Res Function(CoachingBooking) then,
  ) = _$CoachingBookingCopyWithImpl<$Res, CoachingBooking>;
  @useResult
  $Res call({
    String id,
    String coachId,
    String coachName,
    String playerId,
    String playerName,
    String packageId,
    String packageName,
    Sport sport,
    DateTime date,
    String startTime,
    String endTime,
    String venueName,
    int amount,
    BookingStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CoachingBookingCopyWithImpl<$Res, $Val extends CoachingBooking>
    implements $CoachingBookingCopyWith<$Res> {
  _$CoachingBookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachingBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? packageId = null,
    Object? packageName = null,
    Object? sport = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? venueName = null,
    Object? amount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            coachId: null == coachId
                ? _value.coachId
                : coachId // ignore: cast_nullable_to_non_nullable
                      as String,
            coachName: null == coachName
                ? _value.coachName
                : coachName // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            packageId: null == packageId
                ? _value.packageId
                : packageId // ignore: cast_nullable_to_non_nullable
                      as String,
            packageName: null == packageName
                ? _value.packageName
                : packageName // ignore: cast_nullable_to_non_nullable
                      as String,
            sport: null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as Sport,
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
            venueName: null == venueName
                ? _value.venueName
                : venueName // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BookingStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachingBookingImplCopyWith<$Res>
    implements $CoachingBookingCopyWith<$Res> {
  factory _$$CoachingBookingImplCopyWith(
    _$CoachingBookingImpl value,
    $Res Function(_$CoachingBookingImpl) then,
  ) = __$$CoachingBookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String coachId,
    String coachName,
    String playerId,
    String playerName,
    String packageId,
    String packageName,
    Sport sport,
    DateTime date,
    String startTime,
    String endTime,
    String venueName,
    int amount,
    BookingStatus status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$CoachingBookingImplCopyWithImpl<$Res>
    extends _$CoachingBookingCopyWithImpl<$Res, _$CoachingBookingImpl>
    implements _$$CoachingBookingImplCopyWith<$Res> {
  __$$CoachingBookingImplCopyWithImpl(
    _$CoachingBookingImpl _value,
    $Res Function(_$CoachingBookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachingBooking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? coachId = null,
    Object? coachName = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? packageId = null,
    Object? packageName = null,
    Object? sport = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? venueName = null,
    Object? amount = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CoachingBookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        coachId: null == coachId
            ? _value.coachId
            : coachId // ignore: cast_nullable_to_non_nullable
                  as String,
        coachName: null == coachName
            ? _value.coachName
            : coachName // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        packageId: null == packageId
            ? _value.packageId
            : packageId // ignore: cast_nullable_to_non_nullable
                  as String,
        packageName: null == packageName
            ? _value.packageName
            : packageName // ignore: cast_nullable_to_non_nullable
                  as String,
        sport: null == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as Sport,
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
        venueName: null == venueName
            ? _value.venueName
            : venueName // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BookingStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachingBookingImpl implements _CoachingBooking {
  const _$CoachingBookingImpl({
    required this.id,
    required this.coachId,
    required this.coachName,
    required this.playerId,
    required this.playerName,
    required this.packageId,
    required this.packageName,
    required this.sport,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.venueName,
    required this.amount,
    this.status = BookingStatus.pendingPayment,
    required this.createdAt,
  });

  factory _$CoachingBookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachingBookingImplFromJson(json);

  @override
  final String id;
  @override
  final String coachId;
  @override
  final String coachName;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String packageId;
  @override
  final String packageName;
  @override
  final Sport sport;
  @override
  final DateTime date;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String venueName;
  @override
  final int amount;
  @override
  @JsonKey()
  final BookingStatus status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CoachingBooking(id: $id, coachId: $coachId, coachName: $coachName, playerId: $playerId, playerName: $playerName, packageId: $packageId, packageName: $packageName, sport: $sport, date: $date, startTime: $startTime, endTime: $endTime, venueName: $venueName, amount: $amount, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachingBookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
            (identical(other.coachName, coachName) ||
                other.coachName == coachName) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    coachId,
    coachName,
    playerId,
    playerName,
    packageId,
    packageName,
    sport,
    date,
    startTime,
    endTime,
    venueName,
    amount,
    status,
    createdAt,
  );

  /// Create a copy of CoachingBooking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachingBookingImplCopyWith<_$CoachingBookingImpl> get copyWith =>
      __$$CoachingBookingImplCopyWithImpl<_$CoachingBookingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachingBookingImplToJson(this);
  }
}

abstract class _CoachingBooking implements CoachingBooking {
  const factory _CoachingBooking({
    required final String id,
    required final String coachId,
    required final String coachName,
    required final String playerId,
    required final String playerName,
    required final String packageId,
    required final String packageName,
    required final Sport sport,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    required final String venueName,
    required final int amount,
    final BookingStatus status,
    required final DateTime createdAt,
  }) = _$CoachingBookingImpl;

  factory _CoachingBooking.fromJson(Map<String, dynamic> json) =
      _$CoachingBookingImpl.fromJson;

  @override
  String get id;
  @override
  String get coachId;
  @override
  String get coachName;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get packageId;
  @override
  String get packageName;
  @override
  Sport get sport;
  @override
  DateTime get date;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String get venueName;
  @override
  int get amount;
  @override
  BookingStatus get status;
  @override
  DateTime get createdAt;

  /// Create a copy of CoachingBooking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachingBookingImplCopyWith<_$CoachingBookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
