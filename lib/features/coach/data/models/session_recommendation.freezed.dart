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
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_enrollment')
  bool get hasEnrollment => throw _privateConstructorUsedError;
  @JsonKey(name: 'program_name')
  String? get programName => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_name')
  String? get levelName => throw _privateConstructorUsedError;
  List<RecommendationSkill> get focus => throw _privateConstructorUsedError;
  List<RecommendationSkill> get introduce => throw _privateConstructorUsedError;
  List<RecommendationSkill> get review => throw _privateConstructorUsedError;

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
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'has_enrollment') bool hasEnrollment,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    List<RecommendationSkill> focus,
    List<RecommendationSkill> introduce,
    List<RecommendationSkill> review,
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
    Object? studentProfileId = null,
    Object? hasEnrollment = null,
    Object? programName = freezed,
    Object? levelName = freezed,
    Object? focus = null,
    Object? introduce = null,
    Object? review = null,
  }) {
    return _then(
      _value.copyWith(
            studentProfileId: null == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            hasEnrollment: null == hasEnrollment
                ? _value.hasEnrollment
                : hasEnrollment // ignore: cast_nullable_to_non_nullable
                      as bool,
            programName: freezed == programName
                ? _value.programName
                : programName // ignore: cast_nullable_to_non_nullable
                      as String?,
            levelName: freezed == levelName
                ? _value.levelName
                : levelName // ignore: cast_nullable_to_non_nullable
                      as String?,
            focus: null == focus
                ? _value.focus
                : focus // ignore: cast_nullable_to_non_nullable
                      as List<RecommendationSkill>,
            introduce: null == introduce
                ? _value.introduce
                : introduce // ignore: cast_nullable_to_non_nullable
                      as List<RecommendationSkill>,
            review: null == review
                ? _value.review
                : review // ignore: cast_nullable_to_non_nullable
                      as List<RecommendationSkill>,
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
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'has_enrollment') bool hasEnrollment,
    @JsonKey(name: 'program_name') String? programName,
    @JsonKey(name: 'level_name') String? levelName,
    List<RecommendationSkill> focus,
    List<RecommendationSkill> introduce,
    List<RecommendationSkill> review,
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
    Object? studentProfileId = null,
    Object? hasEnrollment = null,
    Object? programName = freezed,
    Object? levelName = freezed,
    Object? focus = null,
    Object? introduce = null,
    Object? review = null,
  }) {
    return _then(
      _$SessionRecommendationImpl(
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        hasEnrollment: null == hasEnrollment
            ? _value.hasEnrollment
            : hasEnrollment // ignore: cast_nullable_to_non_nullable
                  as bool,
        programName: freezed == programName
            ? _value.programName
            : programName // ignore: cast_nullable_to_non_nullable
                  as String?,
        levelName: freezed == levelName
            ? _value.levelName
            : levelName // ignore: cast_nullable_to_non_nullable
                  as String?,
        focus: null == focus
            ? _value._focus
            : focus // ignore: cast_nullable_to_non_nullable
                  as List<RecommendationSkill>,
        introduce: null == introduce
            ? _value._introduce
            : introduce // ignore: cast_nullable_to_non_nullable
                  as List<RecommendationSkill>,
        review: null == review
            ? _value._review
            : review // ignore: cast_nullable_to_non_nullable
                  as List<RecommendationSkill>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionRecommendationImpl extends _SessionRecommendation {
  const _$SessionRecommendationImpl({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'has_enrollment') this.hasEnrollment = false,
    @JsonKey(name: 'program_name') this.programName,
    @JsonKey(name: 'level_name') this.levelName,
    final List<RecommendationSkill> focus = const <RecommendationSkill>[],
    final List<RecommendationSkill> introduce = const <RecommendationSkill>[],
    final List<RecommendationSkill> review = const <RecommendationSkill>[],
  }) : _focus = focus,
       _introduce = introduce,
       _review = review,
       super._();

  factory _$SessionRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionRecommendationImplFromJson(json);

  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  @JsonKey(name: 'has_enrollment')
  final bool hasEnrollment;
  @override
  @JsonKey(name: 'program_name')
  final String? programName;
  @override
  @JsonKey(name: 'level_name')
  final String? levelName;
  final List<RecommendationSkill> _focus;
  @override
  @JsonKey()
  List<RecommendationSkill> get focus {
    if (_focus is EqualUnmodifiableListView) return _focus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_focus);
  }

  final List<RecommendationSkill> _introduce;
  @override
  @JsonKey()
  List<RecommendationSkill> get introduce {
    if (_introduce is EqualUnmodifiableListView) return _introduce;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_introduce);
  }

  final List<RecommendationSkill> _review;
  @override
  @JsonKey()
  List<RecommendationSkill> get review {
    if (_review is EqualUnmodifiableListView) return _review;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_review);
  }

  @override
  String toString() {
    return 'SessionRecommendation(studentProfileId: $studentProfileId, hasEnrollment: $hasEnrollment, programName: $programName, levelName: $levelName, focus: $focus, introduce: $introduce, review: $review)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionRecommendationImpl &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.hasEnrollment, hasEnrollment) ||
                other.hasEnrollment == hasEnrollment) &&
            (identical(other.programName, programName) ||
                other.programName == programName) &&
            (identical(other.levelName, levelName) ||
                other.levelName == levelName) &&
            const DeepCollectionEquality().equals(other._focus, _focus) &&
            const DeepCollectionEquality().equals(
              other._introduce,
              _introduce,
            ) &&
            const DeepCollectionEquality().equals(other._review, _review));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentProfileId,
    hasEnrollment,
    programName,
    levelName,
    const DeepCollectionEquality().hash(_focus),
    const DeepCollectionEquality().hash(_introduce),
    const DeepCollectionEquality().hash(_review),
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

abstract class _SessionRecommendation extends SessionRecommendation {
  const factory _SessionRecommendation({
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'has_enrollment') final bool hasEnrollment,
    @JsonKey(name: 'program_name') final String? programName,
    @JsonKey(name: 'level_name') final String? levelName,
    final List<RecommendationSkill> focus,
    final List<RecommendationSkill> introduce,
    final List<RecommendationSkill> review,
  }) = _$SessionRecommendationImpl;
  const _SessionRecommendation._() : super._();

  factory _SessionRecommendation.fromJson(Map<String, dynamic> json) =
      _$SessionRecommendationImpl.fromJson;

  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  @JsonKey(name: 'has_enrollment')
  bool get hasEnrollment;
  @override
  @JsonKey(name: 'program_name')
  String? get programName;
  @override
  @JsonKey(name: 'level_name')
  String? get levelName;
  @override
  List<RecommendationSkill> get focus;
  @override
  List<RecommendationSkill> get introduce;
  @override
  List<RecommendationSkill> get review;

  /// Create a copy of SessionRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionRecommendationImplCopyWith<_$SessionRecommendationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RecommendationSkill _$RecommendationSkillFromJson(Map<String, dynamic> json) {
  return _RecommendationSkill.fromJson(json);
}

/// @nodoc
mixin _$RecommendationSkill {
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  String get levelSkillId => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill_name')
  String get skillName => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_status')
  String? get lastStatus => throw _privateConstructorUsedError;
  int? get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_practiced_at')
  String? get lastPracticedAt => throw _privateConstructorUsedError;

  /// Serializes this RecommendationSkill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationSkillCopyWith<RecommendationSkill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationSkillCopyWith<$Res> {
  factory $RecommendationSkillCopyWith(
    RecommendationSkill value,
    $Res Function(RecommendationSkill) then,
  ) = _$RecommendationSkillCopyWithImpl<$Res, RecommendationSkill>;
  @useResult
  $Res call({
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson) String levelSkillId,
    @JsonKey(name: 'skill_name') String skillName,
    String? category,
    @JsonKey(name: 'last_status') String? lastStatus,
    int? score,
    @JsonKey(name: 'last_practiced_at') String? lastPracticedAt,
  });
}

/// @nodoc
class _$RecommendationSkillCopyWithImpl<$Res, $Val extends RecommendationSkill>
    implements $RecommendationSkillCopyWith<$Res> {
  _$RecommendationSkillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelSkillId = null,
    Object? skillName = null,
    Object? category = freezed,
    Object? lastStatus = freezed,
    Object? score = freezed,
    Object? lastPracticedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            levelSkillId: null == levelSkillId
                ? _value.levelSkillId
                : levelSkillId // ignore: cast_nullable_to_non_nullable
                      as String,
            skillName: null == skillName
                ? _value.skillName
                : skillName // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastStatus: freezed == lastStatus
                ? _value.lastStatus
                : lastStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastPracticedAt: freezed == lastPracticedAt
                ? _value.lastPracticedAt
                : lastPracticedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecommendationSkillImplCopyWith<$Res>
    implements $RecommendationSkillCopyWith<$Res> {
  factory _$$RecommendationSkillImplCopyWith(
    _$RecommendationSkillImpl value,
    $Res Function(_$RecommendationSkillImpl) then,
  ) = __$$RecommendationSkillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson) String levelSkillId,
    @JsonKey(name: 'skill_name') String skillName,
    String? category,
    @JsonKey(name: 'last_status') String? lastStatus,
    int? score,
    @JsonKey(name: 'last_practiced_at') String? lastPracticedAt,
  });
}

/// @nodoc
class __$$RecommendationSkillImplCopyWithImpl<$Res>
    extends _$RecommendationSkillCopyWithImpl<$Res, _$RecommendationSkillImpl>
    implements _$$RecommendationSkillImplCopyWith<$Res> {
  __$$RecommendationSkillImplCopyWithImpl(
    _$RecommendationSkillImpl _value,
    $Res Function(_$RecommendationSkillImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelSkillId = null,
    Object? skillName = null,
    Object? category = freezed,
    Object? lastStatus = freezed,
    Object? score = freezed,
    Object? lastPracticedAt = freezed,
  }) {
    return _then(
      _$RecommendationSkillImpl(
        levelSkillId: null == levelSkillId
            ? _value.levelSkillId
            : levelSkillId // ignore: cast_nullable_to_non_nullable
                  as String,
        skillName: null == skillName
            ? _value.skillName
            : skillName // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastStatus: freezed == lastStatus
            ? _value.lastStatus
            : lastStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastPracticedAt: freezed == lastPracticedAt
            ? _value.lastPracticedAt
            : lastPracticedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationSkillImpl implements _RecommendationSkill {
  const _$RecommendationSkillImpl({
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required this.levelSkillId,
    @JsonKey(name: 'skill_name') required this.skillName,
    this.category,
    @JsonKey(name: 'last_status') this.lastStatus,
    this.score,
    @JsonKey(name: 'last_practiced_at') this.lastPracticedAt,
  });

  factory _$RecommendationSkillImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationSkillImplFromJson(json);

  @override
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  final String levelSkillId;
  @override
  @JsonKey(name: 'skill_name')
  final String skillName;
  @override
  final String? category;
  @override
  @JsonKey(name: 'last_status')
  final String? lastStatus;
  @override
  final int? score;
  @override
  @JsonKey(name: 'last_practiced_at')
  final String? lastPracticedAt;

  @override
  String toString() {
    return 'RecommendationSkill(levelSkillId: $levelSkillId, skillName: $skillName, category: $category, lastStatus: $lastStatus, score: $score, lastPracticedAt: $lastPracticedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationSkillImpl &&
            (identical(other.levelSkillId, levelSkillId) ||
                other.levelSkillId == levelSkillId) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.lastStatus, lastStatus) ||
                other.lastStatus == lastStatus) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.lastPracticedAt, lastPracticedAt) ||
                other.lastPracticedAt == lastPracticedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    levelSkillId,
    skillName,
    category,
    lastStatus,
    score,
    lastPracticedAt,
  );

  /// Create a copy of RecommendationSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationSkillImplCopyWith<_$RecommendationSkillImpl> get copyWith =>
      __$$RecommendationSkillImplCopyWithImpl<_$RecommendationSkillImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationSkillImplToJson(this);
  }
}

abstract class _RecommendationSkill implements RecommendationSkill {
  const factory _RecommendationSkill({
    @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
    required final String levelSkillId,
    @JsonKey(name: 'skill_name') required final String skillName,
    final String? category,
    @JsonKey(name: 'last_status') final String? lastStatus,
    final int? score,
    @JsonKey(name: 'last_practiced_at') final String? lastPracticedAt,
  }) = _$RecommendationSkillImpl;

  factory _RecommendationSkill.fromJson(Map<String, dynamic> json) =
      _$RecommendationSkillImpl.fromJson;

  @override
  @JsonKey(name: 'level_skill_id', fromJson: idFromJson)
  String get levelSkillId;
  @override
  @JsonKey(name: 'skill_name')
  String get skillName;
  @override
  String? get category;
  @override
  @JsonKey(name: 'last_status')
  String? get lastStatus;
  @override
  int? get score;
  @override
  @JsonKey(name: 'last_practiced_at')
  String? get lastPracticedAt;

  /// Create a copy of RecommendationSkill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationSkillImplCopyWith<_$RecommendationSkillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
