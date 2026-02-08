// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_rating_aggregate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachRatingAggregate _$CoachRatingAggregateFromJson(Map<String, dynamic> json) {
  return _CoachRatingAggregate.fromJson(json);
}

/// @nodoc
mixin _$CoachRatingAggregate {
  String get coachId => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<int, int> get distribution => throw _privateConstructorUsedError;

  /// Serializes this CoachRatingAggregate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachRatingAggregateCopyWith<CoachRatingAggregate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachRatingAggregateCopyWith<$Res> {
  factory $CoachRatingAggregateCopyWith(
    CoachRatingAggregate value,
    $Res Function(CoachRatingAggregate) then,
  ) = _$CoachRatingAggregateCopyWithImpl<$Res, CoachRatingAggregate>;
  @useResult
  $Res call({
    String coachId,
    double averageRating,
    int totalReviews,
    Map<int, int> distribution,
  });
}

/// @nodoc
class _$CoachRatingAggregateCopyWithImpl<
  $Res,
  $Val extends CoachRatingAggregate
>
    implements $CoachRatingAggregateCopyWith<$Res> {
  _$CoachRatingAggregateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coachId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? distribution = null,
  }) {
    return _then(
      _value.copyWith(
            coachId: null == coachId
                ? _value.coachId
                : coachId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CoachRatingAggregateImplCopyWith<$Res>
    implements $CoachRatingAggregateCopyWith<$Res> {
  factory _$$CoachRatingAggregateImplCopyWith(
    _$CoachRatingAggregateImpl value,
    $Res Function(_$CoachRatingAggregateImpl) then,
  ) = __$$CoachRatingAggregateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String coachId,
    double averageRating,
    int totalReviews,
    Map<int, int> distribution,
  });
}

/// @nodoc
class __$$CoachRatingAggregateImplCopyWithImpl<$Res>
    extends _$CoachRatingAggregateCopyWithImpl<$Res, _$CoachRatingAggregateImpl>
    implements _$$CoachRatingAggregateImplCopyWith<$Res> {
  __$$CoachRatingAggregateImplCopyWithImpl(
    _$CoachRatingAggregateImpl _value,
    $Res Function(_$CoachRatingAggregateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coachId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? distribution = null,
  }) {
    return _then(
      _$CoachRatingAggregateImpl(
        coachId: null == coachId
            ? _value.coachId
            : coachId // ignore: cast_nullable_to_non_nullable
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
class _$CoachRatingAggregateImpl implements _CoachRatingAggregate {
  const _$CoachRatingAggregateImpl({
    required this.coachId,
    required this.averageRating,
    required this.totalReviews,
    final Map<int, int> distribution = const {},
  }) : _distribution = distribution;

  factory _$CoachRatingAggregateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachRatingAggregateImplFromJson(json);

  @override
  final String coachId;
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
    return 'CoachRatingAggregate(coachId: $coachId, averageRating: $averageRating, totalReviews: $totalReviews, distribution: $distribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachRatingAggregateImpl &&
            (identical(other.coachId, coachId) || other.coachId == coachId) &&
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
    coachId,
    averageRating,
    totalReviews,
    const DeepCollectionEquality().hash(_distribution),
  );

  /// Create a copy of CoachRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachRatingAggregateImplCopyWith<_$CoachRatingAggregateImpl>
  get copyWith =>
      __$$CoachRatingAggregateImplCopyWithImpl<_$CoachRatingAggregateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachRatingAggregateImplToJson(this);
  }
}

abstract class _CoachRatingAggregate implements CoachRatingAggregate {
  const factory _CoachRatingAggregate({
    required final String coachId,
    required final double averageRating,
    required final int totalReviews,
    final Map<int, int> distribution,
  }) = _$CoachRatingAggregateImpl;

  factory _CoachRatingAggregate.fromJson(Map<String, dynamic> json) =
      _$CoachRatingAggregateImpl.fromJson;

  @override
  String get coachId;
  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<int, int> get distribution;

  /// Create a copy of CoachRatingAggregate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachRatingAggregateImplCopyWith<_$CoachRatingAggregateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
