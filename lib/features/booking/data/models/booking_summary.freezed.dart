// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingSummary _$BookingSummaryFromJson(Map<String, dynamic> json) {
  return _BookingSummary.fromJson(json);
}

/// @nodoc
mixin _$BookingSummary {
  Court? get court => throw _privateConstructorUsedError;
  Venue? get venue => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  List<CourtSlot> get slots => throw _privateConstructorUsedError;
  int get totalAmount => throw _privateConstructorUsedError;
  PaymentMethodType? get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this BookingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingSummaryCopyWith<BookingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingSummaryCopyWith<$Res> {
  factory $BookingSummaryCopyWith(
    BookingSummary value,
    $Res Function(BookingSummary) then,
  ) = _$BookingSummaryCopyWithImpl<$Res, BookingSummary>;
  @useResult
  $Res call({
    Court? court,
    Venue? venue,
    DateTime? date,
    List<CourtSlot> slots,
    int totalAmount,
    PaymentMethodType? paymentMethod,
  });

  $CourtCopyWith<$Res>? get court;
  $VenueCopyWith<$Res>? get venue;
}

/// @nodoc
class _$BookingSummaryCopyWithImpl<$Res, $Val extends BookingSummary>
    implements $BookingSummaryCopyWith<$Res> {
  _$BookingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? court = freezed,
    Object? venue = freezed,
    Object? date = freezed,
    Object? slots = null,
    Object? totalAmount = null,
    Object? paymentMethod = freezed,
  }) {
    return _then(
      _value.copyWith(
            court: freezed == court
                ? _value.court
                : court // ignore: cast_nullable_to_non_nullable
                      as Court?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as Venue?,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            slots: null == slots
                ? _value.slots
                : slots // ignore: cast_nullable_to_non_nullable
                      as List<CourtSlot>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as PaymentMethodType?,
          )
          as $Val,
    );
  }

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourtCopyWith<$Res>? get court {
    if (_value.court == null) {
      return null;
    }

    return $CourtCopyWith<$Res>(_value.court!, (value) {
      return _then(_value.copyWith(court: value) as $Val);
    });
  }

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueCopyWith<$Res>? get venue {
    if (_value.venue == null) {
      return null;
    }

    return $VenueCopyWith<$Res>(_value.venue!, (value) {
      return _then(_value.copyWith(venue: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingSummaryImplCopyWith<$Res>
    implements $BookingSummaryCopyWith<$Res> {
  factory _$$BookingSummaryImplCopyWith(
    _$BookingSummaryImpl value,
    $Res Function(_$BookingSummaryImpl) then,
  ) = __$$BookingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Court? court,
    Venue? venue,
    DateTime? date,
    List<CourtSlot> slots,
    int totalAmount,
    PaymentMethodType? paymentMethod,
  });

  @override
  $CourtCopyWith<$Res>? get court;
  @override
  $VenueCopyWith<$Res>? get venue;
}

/// @nodoc
class __$$BookingSummaryImplCopyWithImpl<$Res>
    extends _$BookingSummaryCopyWithImpl<$Res, _$BookingSummaryImpl>
    implements _$$BookingSummaryImplCopyWith<$Res> {
  __$$BookingSummaryImplCopyWithImpl(
    _$BookingSummaryImpl _value,
    $Res Function(_$BookingSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? court = freezed,
    Object? venue = freezed,
    Object? date = freezed,
    Object? slots = null,
    Object? totalAmount = null,
    Object? paymentMethod = freezed,
  }) {
    return _then(
      _$BookingSummaryImpl(
        court: freezed == court
            ? _value.court
            : court // ignore: cast_nullable_to_non_nullable
                  as Court?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as Venue?,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        slots: null == slots
            ? _value._slots
            : slots // ignore: cast_nullable_to_non_nullable
                  as List<CourtSlot>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as PaymentMethodType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingSummaryImpl implements _BookingSummary {
  const _$BookingSummaryImpl({
    this.court,
    this.venue,
    this.date,
    final List<CourtSlot> slots = const [],
    this.totalAmount = 0,
    this.paymentMethod,
  }) : _slots = slots;

  factory _$BookingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingSummaryImplFromJson(json);

  @override
  final Court? court;
  @override
  final Venue? venue;
  @override
  final DateTime? date;
  final List<CourtSlot> _slots;
  @override
  @JsonKey()
  List<CourtSlot> get slots {
    if (_slots is EqualUnmodifiableListView) return _slots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slots);
  }

  @override
  @JsonKey()
  final int totalAmount;
  @override
  final PaymentMethodType? paymentMethod;

  @override
  String toString() {
    return 'BookingSummary(court: $court, venue: $venue, date: $date, slots: $slots, totalAmount: $totalAmount, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingSummaryImpl &&
            (identical(other.court, court) || other.court == court) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._slots, _slots) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    court,
    venue,
    date,
    const DeepCollectionEquality().hash(_slots),
    totalAmount,
    paymentMethod,
  );

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingSummaryImplCopyWith<_$BookingSummaryImpl> get copyWith =>
      __$$BookingSummaryImplCopyWithImpl<_$BookingSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingSummaryImplToJson(this);
  }
}

abstract class _BookingSummary implements BookingSummary {
  const factory _BookingSummary({
    final Court? court,
    final Venue? venue,
    final DateTime? date,
    final List<CourtSlot> slots,
    final int totalAmount,
    final PaymentMethodType? paymentMethod,
  }) = _$BookingSummaryImpl;

  factory _BookingSummary.fromJson(Map<String, dynamic> json) =
      _$BookingSummaryImpl.fromJson;

  @override
  Court? get court;
  @override
  Venue? get venue;
  @override
  DateTime? get date;
  @override
  List<CourtSlot> get slots;
  @override
  int get totalAmount;
  @override
  PaymentMethodType? get paymentMethod;

  /// Create a copy of BookingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingSummaryImplCopyWith<_$BookingSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
