// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_rating_aggregate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VenueRatingAggregate _$VenueRatingAggregateFromJson(Map<String, dynamic> json) {
  return _VenueRatingAggregate.fromJson(json);
}

/// @nodoc
mixin _$VenueRatingAggregate {
  String get venueId => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<int, int> get distribution => throw _privateConstructorUsedError;

  /// Serializes this VenueRatingAggregate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueRatingAggregateCopyWith<VenueRatingAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueRatingAggregateCopyWith<$Res> {
  factory $VenueRatingAggregateCopyWith(
    VenueRatingAggregate value,
    $Res Function(VenueRatingAggregate) then,
  ) = _$VenueRatingAggregateCopyWithImpl<$Res, VenueRatingAggregate>;
  @useResult
  $Res call({
    String venueId,
    double averageRating,
    int totalReviews,
    Map<int, int> distribution,
  });
}

/// @nodoc
class _$VenueRatingAggregateCopyWithImpl<
  $Res,
  $Val extends VenueRatingAggregate
>
    implements $VenueRatingAggregateCopyWith<$Res> {
  _$VenueRatingAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? distribution = null,
  }) {
    return _then(
      _value.copyWith(
            venueId: null == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            distribution: null == distribution
                ? _value.distribution
                : distribution // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VenueRatingAggregateImplCopyWith<$Res>
    implements $VenueRatingAggregateCopyWith<$Res> {
  factory _$$VenueRatingAggregateImplCopyWith(
    _$VenueRatingAggregateImpl value,
    $Res Function(_$VenueRatingAggregateImpl) then,
  ) = __$$VenueRatingAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String venueId,
    double averageRating,
    int totalReviews,
    Map<int, int> distribution,
  });
}

/// @nodoc
class __$$VenueRatingAggregateImplCopyWithImpl<$Res>
    extends _$VenueRatingAggregateCopyWithImpl<$Res, _$VenueRatingAggregateImpl>
    implements _$$VenueRatingAggregateImplCopyWith<$Res> {
  __$$VenueRatingAggregateImplCopyWithImpl(
    _$VenueRatingAggregateImpl _value,
    $Res Function(_$VenueRatingAggregateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VenueRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? venueId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? distribution = null,
  }) {
    return _then(
      _$VenueRatingAggregateImpl(
        venueId: null == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        distribution: null == distribution
            ? _value._distribution
            : distribution // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueRatingAggregateImpl implements _VenueRatingAggregate {
  const _$VenueRatingAggregateImpl({
    required this.venueId,
    required this.averageRating,
    required this.totalReviews,
    final Map<int, int> distribution = const {},
  }) : _distribution = distribution;

  factory _$VenueRatingAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueRatingAggregateImplFromJson(json);

  @override
  final String venueId;
  @override
  final double averageRating;
  @override
  final int totalReviews;
  final Map<int, int> _distribution;
  @override
  @JsonKey()
  Map<int, int> get distribution {
    if (_distribution is EqualUnmodifiableMapView) return _distribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_distribution);
  }

  @override
  String toString() {
    return 'VenueRatingAggregate(venueId: $venueId, averageRating: $averageRating, totalReviews: $totalReviews, distribution: $distribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueRatingAggregateImpl &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality().equals(
              other._distribution,
              _distribution,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    venueId,
    averageRating,
    totalReviews,
    const DeepCollectionEquality().hash(_distribution),
  );

  /// Create a copy of VenueRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueRatingAggregateImplCopyWith<_$VenueRatingAggregateImpl>
  get copyWith =>
      __$$VenueRatingAggregateImplCopyWithImpl<_$VenueRatingAggregateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueRatingAggregateImplToJson(this);
  }
}

abstract class _VenueRatingAggregate implements VenueRatingAggregate {
  const factory _VenueRatingAggregate({
    required final String venueId,
    required final double averageRating,
    required final int totalReviews,
    final Map<int, int> distribution,
  }) = _$VenueRatingAggregateImpl;

  factory _VenueRatingAggregate.fromJson(Map<String, dynamic> json) =
      _$VenueRatingAggregateImpl.fromJson;

  @override
  String get venueId;
  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<int, int> get distribution;

  /// Create a copy of VenueRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueRatingAggregateImplCopyWith<_$VenueRatingAggregateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
