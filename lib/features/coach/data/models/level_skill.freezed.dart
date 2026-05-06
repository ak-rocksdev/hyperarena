// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_skill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LevelSkill _$LevelSkillFromJson(Map<String, dynamic> json) {
  return _LevelSkill.fromJson(json);
}

/// @nodoc
mixin _$LevelSkill {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'level_id', fromJson: idFromJson)
  String get levelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  String? get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  Skill? get skill => throw _privateConstructorUsedError;
  bool get isOverride => throw _privateConstructorUsedError;

  /// Serializes this LevelSkill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LevelSkillCopyWith<LevelSkill> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelSkillCopyWith<$Res> {
  factory $LevelSkillCopyWith(
    LevelSkill value,
    $Res Function(LevelSkill) then,
  ) = _$LevelSkillCopyWithImpl<$Res, LevelSkill>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'level_id', fromJson: idFromJson) String levelId,
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'sort_order') int sortOrder,
    Skill? skill,
    bool isOverride,
  });

  $SkillCopyWith<$Res>? get skill;
}

/// @nodoc
class _$LevelSkillCopyWithImpl<$Res, $Val extends LevelSkill>
    implements $LevelSkillCopyWith<$Res> {
  _$LevelSkillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? levelId = null,
    Object? studentProfileId = freezed,
    Object? sortOrder = null,
    Object? skill = freezed,
    Object? isOverride = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            levelId: null == levelId
                ? _value.levelId
                : levelId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentProfileId: freezed == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            skill: freezed == skill
                ? _value.skill
                : skill // ignore: cast_nullable_to_non_nullable
                      as Skill?,
            isOverride: null == isOverride
                ? _value.isOverride
                : isOverride // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SkillCopyWith<$Res>? get skill {
    if (_value.skill == null) {
      return null;
    }

    return $SkillCopyWith<$Res>(_value.skill!, (value) {
      return _then(_value.copyWith(skill: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LevelSkillImplCopyWith<$Res>
    implements $LevelSkillCopyWith<$Res> {
  factory _$$LevelSkillImplCopyWith(
    _$LevelSkillImpl value,
    $Res Function(_$LevelSkillImpl) then,
  ) = __$$LevelSkillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'level_id', fromJson: idFromJson) String levelId,
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    String? studentProfileId,
    @JsonKey(name: 'sort_order') int sortOrder,
    Skill? skill,
    bool isOverride,
  });

  @override
  $SkillCopyWith<$Res>? get skill;
}

/// @nodoc
class __$$LevelSkillImplCopyWithImpl<$Res>
    extends _$LevelSkillCopyWithImpl<$Res, _$LevelSkillImpl>
    implements _$$LevelSkillImplCopyWith<$Res> {
  __$$LevelSkillImplCopyWithImpl(
    _$LevelSkillImpl _value,
    $Res Function(_$LevelSkillImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? levelId = null,
    Object? studentProfileId = freezed,
    Object? sortOrder = null,
    Object? skill = freezed,
    Object? isOverride = null,
  }) {
    return _then(
      _$LevelSkillImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        levelId: null == levelId
            ? _value.levelId
            : levelId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: freezed == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        skill: freezed == skill
            ? _value.skill
            : skill // ignore: cast_nullable_to_non_nullable
                  as Skill?,
        isOverride: null == isOverride
            ? _value.isOverride
            : isOverride // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LevelSkillImpl implements _LevelSkill {
  const _$LevelSkillImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'level_id', fromJson: idFromJson) required this.levelId,
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    this.studentProfileId,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
    this.skill,
    this.isOverride = false,
  });

  factory _$LevelSkillImpl.fromJson(Map<String, dynamic> json) =>
      _$$LevelSkillImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'level_id', fromJson: idFromJson)
  final String levelId;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  final String? studentProfileId;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  final Skill? skill;
  @override
  @JsonKey()
  final bool isOverride;

  @override
  String toString() {
    return 'LevelSkill(id: $id, levelId: $levelId, studentProfileId: $studentProfileId, sortOrder: $sortOrder, skill: $skill, isOverride: $isOverride)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelSkillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.levelId, levelId) || other.levelId == levelId) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.skill, skill) || other.skill == skill) &&
            (identical(other.isOverride, isOverride) ||
                other.isOverride == isOverride));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    levelId,
    studentProfileId,
    sortOrder,
    skill,
    isOverride,
  );

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelSkillImplCopyWith<_$LevelSkillImpl> get copyWith =>
      __$$LevelSkillImplCopyWithImpl<_$LevelSkillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LevelSkillImplToJson(this);
  }
}

abstract class _LevelSkill implements LevelSkill {
  const factory _LevelSkill({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'level_id', fromJson: idFromJson)
    required final String levelId,
    @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
    final String? studentProfileId,
    @JsonKey(name: 'sort_order') final int sortOrder,
    final Skill? skill,
    final bool isOverride,
  }) = _$LevelSkillImpl;

  factory _LevelSkill.fromJson(Map<String, dynamic> json) =
      _$LevelSkillImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'level_id', fromJson: idFromJson)
  String get levelId;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: nullableIdFromJson)
  String? get studentProfileId;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  Skill? get skill;
  @override
  bool get isOverride;

  /// Create a copy of LevelSkill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LevelSkillImplCopyWith<_$LevelSkillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Skill _$SkillFromJson(Map<String, dynamic> json) {
  return _Skill.fromJson(json);
}

/// @nodoc
mixin _$Skill {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this Skill to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Skill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillCopyWith<Skill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillCopyWith<$Res> {
  factory $SkillCopyWith(Skill value, $Res Function(Skill) then) =
      _$SkillCopyWithImpl<$Res, Skill>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? category,
  });
}

/// @nodoc
class _$SkillCopyWithImpl<$Res, $Val extends Skill>
    implements $SkillCopyWith<$Res> {
  _$SkillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Skill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkillImplCopyWith<$Res> implements $SkillCopyWith<$Res> {
  factory _$$SkillImplCopyWith(
    _$SkillImpl value,
    $Res Function(_$SkillImpl) then,
  ) = __$$SkillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? category,
  });
}

/// @nodoc
class __$$SkillImplCopyWithImpl<$Res>
    extends _$SkillCopyWithImpl<$Res, _$SkillImpl>
    implements _$$SkillImplCopyWith<$Res> {
  __$$SkillImplCopyWithImpl(
    _$SkillImpl _value,
    $Res Function(_$SkillImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Skill
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
  }) {
    return _then(
      _$SkillImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillImpl implements _Skill {
  const _$SkillImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.category,
  });

  factory _$SkillImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? category;

  @override
  String toString() {
    return 'Skill(id: $id, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, category);

  /// Create a copy of Skill
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillImplCopyWith<_$SkillImpl> get copyWith =>
      __$$SkillImplCopyWithImpl<_$SkillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillImplToJson(this);
  }
}

abstract class _Skill implements Skill {
  const factory _Skill({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? category,
  }) = _$SkillImpl;

  factory _Skill.fromJson(Map<String, dynamic> json) = _$SkillImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get category;

  /// Create a copy of Skill
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillImplCopyWith<_$SkillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
