// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_action_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachActionCounts _$CoachActionCountsFromJson(Map<String, dynamic> json) {
  return _CoachActionCounts.fromJson(json);
}

/// @nodoc
mixin _$CoachActionCounts {
  int get absencesUnmarked => throw _privateConstructorUsedError;
  int get assessmentsUngraded => throw _privateConstructorUsedError;
  int get studentsUngraded => throw _privateConstructorUsedError;

  /// Serializes this CoachActionCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachActionCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachActionCountsCopyWith<CoachActionCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachActionCountsCopyWith<$Res> {
  factory $CoachActionCountsCopyWith(
    CoachActionCounts value,
    $Res Function(CoachActionCounts) then,
  ) = _$CoachActionCountsCopyWithImpl<$Res, CoachActionCounts>;
  @useResult
  $Res call({
    int absencesUnmarked,
    int assessmentsUngraded,
    int studentsUngraded,
  });
}

/// @nodoc
class _$CoachActionCountsCopyWithImpl<$Res, $Val extends CoachActionCounts>
    implements $CoachActionCountsCopyWith<$Res> {
  _$CoachActionCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachActionCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absencesUnmarked = null,
    Object? assessmentsUngraded = null,
    Object? studentsUngraded = null,
  }) {
    return _then(
      _value.copyWith(
            absencesUnmarked: null == absencesUnmarked
                ? _value.absencesUnmarked
                : absencesUnmarked // ignore: cast_nullable_to_non_nullable
                      as int,
            assessmentsUngraded: null == assessmentsUngraded
                ? _value.assessmentsUngraded
                : assessmentsUngraded // ignore: cast_nullable_to_non_nullable
                      as int,
            studentsUngraded: null == studentsUngraded
                ? _value.studentsUngraded
                : studentsUngraded // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachActionCountsImplCopyWith<$Res>
    implements $CoachActionCountsCopyWith<$Res> {
  factory _$$CoachActionCountsImplCopyWith(
    _$CoachActionCountsImpl value,
    $Res Function(_$CoachActionCountsImpl) then,
  ) = __$$CoachActionCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int absencesUnmarked,
    int assessmentsUngraded,
    int studentsUngraded,
  });
}

/// @nodoc
class __$$CoachActionCountsImplCopyWithImpl<$Res>
    extends _$CoachActionCountsCopyWithImpl<$Res, _$CoachActionCountsImpl>
    implements _$$CoachActionCountsImplCopyWith<$Res> {
  __$$CoachActionCountsImplCopyWithImpl(
    _$CoachActionCountsImpl _value,
    $Res Function(_$CoachActionCountsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachActionCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? absencesUnmarked = null,
    Object? assessmentsUngraded = null,
    Object? studentsUngraded = null,
  }) {
    return _then(
      _$CoachActionCountsImpl(
        absencesUnmarked: null == absencesUnmarked
            ? _value.absencesUnmarked
            : absencesUnmarked // ignore: cast_nullable_to_non_nullable
                  as int,
        assessmentsUngraded: null == assessmentsUngraded
            ? _value.assessmentsUngraded
            : assessmentsUngraded // ignore: cast_nullable_to_non_nullable
                  as int,
        studentsUngraded: null == studentsUngraded
            ? _value.studentsUngraded
            : studentsUngraded // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachActionCountsImpl implements _CoachActionCounts {
  const _$CoachActionCountsImpl({
    required this.absencesUnmarked,
    required this.assessmentsUngraded,
    required this.studentsUngraded,
  });

  factory _$CoachActionCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachActionCountsImplFromJson(json);

  @override
  final int absencesUnmarked;
  @override
  final int assessmentsUngraded;
  @override
  final int studentsUngraded;

  @override
  String toString() {
    return 'CoachActionCounts(absencesUnmarked: $absencesUnmarked, assessmentsUngraded: $assessmentsUngraded, studentsUngraded: $studentsUngraded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachActionCountsImpl &&
            (identical(other.absencesUnmarked, absencesUnmarked) ||
                other.absencesUnmarked == absencesUnmarked) &&
            (identical(other.assessmentsUngraded, assessmentsUngraded) ||
                other.assessmentsUngraded == assessmentsUngraded) &&
            (identical(other.studentsUngraded, studentsUngraded) ||
                other.studentsUngraded == studentsUngraded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    absencesUnmarked,
    assessmentsUngraded,
    studentsUngraded,
  );

  /// Create a copy of CoachActionCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachActionCountsImplCopyWith<_$CoachActionCountsImpl> get copyWith =>
      __$$CoachActionCountsImplCopyWithImpl<_$CoachActionCountsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachActionCountsImplToJson(this);
  }
}

abstract class _CoachActionCounts implements CoachActionCounts {
  const factory _CoachActionCounts({
    required final int absencesUnmarked,
    required final int assessmentsUngraded,
    required final int studentsUngraded,
  }) = _$CoachActionCountsImpl;

  factory _CoachActionCounts.fromJson(Map<String, dynamic> json) =
      _$CoachActionCountsImpl.fromJson;

  @override
  int get absencesUnmarked;
  @override
  int get assessmentsUngraded;
  @override
  int get studentsUngraded;

  /// Create a copy of CoachActionCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachActionCountsImplCopyWith<_$CoachActionCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
