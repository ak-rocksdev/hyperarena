// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'court_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourtSlot _$CourtSlotFromJson(Map<String, dynamic> json) {
  return _CourtSlot.fromJson(json);
}

/// @nodoc
mixin _$CourtSlot {
  String get id => throw _privateConstructorUsedError;
  String get courtId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  bool get isPeak => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this CourtSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourtSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourtSlotCopyWith<CourtSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtSlotCopyWith<$Res> {
  factory $CourtSlotCopyWith(CourtSlot value, $Res Function(CourtSlot) then) =
      _$CourtSlotCopyWithImpl<$Res, CourtSlot>;
  @useResult
  $Res call({
    String id,
    String courtId,
    DateTime date,
    String startTime,
    String endTime,
    int price,
    bool isPeak,
    bool isAvailable,
  });
}

/// @nodoc
class _$CourtSlotCopyWithImpl<$Res, $Val extends CourtSlot>
    implements $CourtSlotCopyWith<$Res> {
  _$CourtSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourtSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courtId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? price = null,
    Object? isPeak = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            courtId: null == courtId
                ? _value.courtId
                : courtId // ignore: cast_nullable_to_non_nullable
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            isPeak: null == isPeak
                ? _value.isPeak
                : isPeak // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourtSlotImplCopyWith<$Res>
    implements $CourtSlotCopyWith<$Res> {
  factory _$$CourtSlotImplCopyWith(
    _$CourtSlotImpl value,
    $Res Function(_$CourtSlotImpl) then,
  ) = __$$CourtSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String courtId,
    DateTime date,
    String startTime,
    String endTime,
    int price,
    bool isPeak,
    bool isAvailable,
  });
}

/// @nodoc
class __$$CourtSlotImplCopyWithImpl<$Res>
    extends _$CourtSlotCopyWithImpl<$Res, _$CourtSlotImpl>
    implements _$$CourtSlotImplCopyWith<$Res> {
  __$$CourtSlotImplCopyWithImpl(
    _$CourtSlotImpl _value,
    $Res Function(_$CourtSlotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourtSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courtId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? price = null,
    Object? isPeak = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _$CourtSlotImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        courtId: null == courtId
            ? _value.courtId
            : courtId // ignore: cast_nullable_to_non_nullable
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
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        isPeak: null == isPeak
            ? _value.isPeak
            : isPeak // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourtSlotImpl implements _CourtSlot {
  const _$CourtSlotImpl({
    required this.id,
    required this.courtId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    this.isPeak = false,
    this.isAvailable = true,
  });

  factory _$CourtSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourtSlotImplFromJson(json);

  @override
  final String id;
  @override
  final String courtId;
  @override
  final DateTime date;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final int price;
  @override
  @JsonKey()
  final bool isPeak;
  @override
  @JsonKey()
  final bool isAvailable;

  @override
  String toString() {
    return 'CourtSlot(id: $id, courtId: $courtId, date: $date, startTime: $startTime, endTime: $endTime, price: $price, isPeak: $isPeak, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courtId, courtId) || other.courtId == courtId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isPeak, isPeak) || other.isPeak == isPeak) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    courtId,
    date,
    startTime,
    endTime,
    price,
    isPeak,
    isAvailable,
  );

  /// Create a copy of CourtSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtSlotImplCopyWith<_$CourtSlotImpl> get copyWith =>
      __$$CourtSlotImplCopyWithImpl<_$CourtSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourtSlotImplToJson(this);
  }
}

abstract class _CourtSlot implements CourtSlot {
  const factory _CourtSlot({
    required final String id,
    required final String courtId,
    required final DateTime date,
    required final String startTime,
    required final String endTime,
    required final int price,
    final bool isPeak,
    final bool isAvailable,
  }) = _$CourtSlotImpl;

  factory _CourtSlot.fromJson(Map<String, dynamic> json) =
      _$CourtSlotImpl.fromJson;

  @override
  String get id;
  @override
  String get courtId;
  @override
  DateTime get date;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  int get price;
  @override
  bool get isPeak;
  @override
  bool get isAvailable;

  /// Create a copy of CourtSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourtSlotImplCopyWith<_$CourtSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
