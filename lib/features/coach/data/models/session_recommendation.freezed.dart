// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionRecommendation _$SessionRecommendationFromJson(
  Map<String, dynamic> json,
) {
  return _SessionRecommendation.fromJson(json);
}

/// @nodoc
mixin _$SessionRecommendation {
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  String? get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_name')
  String? get studentName => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;

  /// Serializes this SessionRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionRecommendationCopyWith<SessionRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionRecommendationCopyWith<$Res> {
  factory $SessionRecommendationCopyWith(
    SessionRecommendation value,
    $Res Function(SessionRecommendation) then,
  ) = _$SessionRecommendationCopyWithImpl<$Res, SessionRecommendation>;
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'student_name') String? studentName,
    String? title,
    String? description,
    List<String> skills,
  });
}

/// @nodoc
class _$SessionRecommendationCopyWithImpl<
  $Res,
  $Val extends SessionRecommendation
>
    implements $SessionRecommendationCopyWith<$Res> {
  _$SessionRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = freezed,
    Object? studentName = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? skills = null,
  }) {
    return _then(
      _value.copyWith(
            studentProfileId: freezed == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String?,
            studentName: freezed == studentName
                ? _value.studentName
                : studentName // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            skills: null == skills
                ? _value.skills
                : skills // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionRecommendationImplCopyWith<$Res>
    implements $SessionRecommendationCopyWith<$Res> {
  factory _$$SessionRecommendationImplCopyWith(
    _$SessionRecommendationImpl value,
    $Res Function(_$SessionRecommendationImpl) then,
  ) = __$$SessionRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'student_name') String? studentName,
    String? title,
    String? description,
    List<String> skills,
  });
}

/// @nodoc
class __$$SessionRecommendationImplCopyWithImpl<$Res>
    extends
        _$SessionRecommendationCopyWithImpl<$Res, _$SessionRecommendationImpl>
    implements _$$SessionRecommendationImplCopyWith<$Res> {
  __$$SessionRecommendationImplCopyWithImpl(
    _$SessionRecommendationImpl _value,
    $Res Function(_$SessionRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentProfileId = freezed,
    Object? studentName = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? skills = null,
  }) {
    return _then(
      _$SessionRecommendationImpl(
        studentProfileId: freezed == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String?,
        studentName: freezed == studentName
            ? _value.studentName
            : studentName // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        skills: null == skills
            ? _value._skills
            : skills // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionRecommendationImpl implements _SessionRecommendation {
  const _$SessionRecommendationImpl({
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    this.studentProfileId,
    @JsonKey(name: 'student_name') this.studentName,
    this.title,
    this.description,
    final List<String> skills = const <String>[],
  }) : _skills = skills;

  factory _$SessionRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionRecommendationImplFromJson(json);

  @override
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  final String? studentProfileId;
  @override
  @JsonKey(name: 'student_name')
  final String? studentName;
  @override
  final String? title;
  @override
  final String? description;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  String toString() {
    return 'SessionRecommendation(studentProfileId: $studentProfileId, studentName: $studentName, title: $title, description: $description, skills: $skills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionRecommendationImpl &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._skills, _skills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentProfileId,
    studentName,
    title,
    description,
    const DeepCollectionEquality().hash(_skills),
  );

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionRecommendationImplCopyWith<_$SessionRecommendationImpl>
  get copyWith =>
      __$$SessionRecommendationImplCopyWithImpl<_$SessionRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionRecommendationImplToJson(this);
  }
}

abstract class _SessionRecommendation implements SessionRecommendation {
  const factory _SessionRecommendation({
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    final String? studentProfileId,
    @JsonKey(name: 'student_name') final String? studentName,
    final String? title,
    final String? description,
    final List<String> skills,
  }) = _$SessionRecommendationImpl;

  factory _SessionRecommendation.fromJson(Map<String, dynamic> json) =
      _$SessionRecommendationImpl.fromJson;

  @override
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  String? get studentProfileId;
  @override
  @JsonKey(name: 'student_name')
  String? get studentName;
  @override
  String? get title;
  @override
  String? get description;
  @override
  List<String> get skills;

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionRecommendationImplCopyWith<_$SessionRecommendationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
