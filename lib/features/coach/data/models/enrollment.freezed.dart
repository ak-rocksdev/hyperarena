// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) {
  return _Enrollment.fromJson(json);
}

/// @nodoc
mixin _$Enrollment {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  String get programId => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
  String? get currentLevelId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  EnrolledProgram? get program => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_level')
  EnrolledLevel? get currentLevel => throw _privateConstructorUsedError;

  /// Serializes this Enrollment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrollmentCopyWith<Enrollment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrollmentCopyWith<$Res> {
  factory $EnrollmentCopyWith(
    Enrollment value,
    $Res Function(Enrollment) then,
  ) = _$EnrollmentCopyWithImpl<$Res, Enrollment>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'program_id', fromJson: idFromJson) String programId,
    @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
    String? currentLevelId,
    String status,
    EnrolledProgram? program,
    @JsonKey(name: 'current_level') EnrolledLevel? currentLevel,
  });

  $EnrolledProgramCopyWith<$Res>? get program;
  $EnrolledLevelCopyWith<$Res>? get currentLevel;
}

/// @nodoc
class _$EnrollmentCopyWithImpl<$Res, $Val extends Enrollment>
    implements $EnrollmentCopyWith<$Res> {
  _$EnrollmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? programId = null,
    Object? currentLevelId = freezed,
    Object? status = null,
    Object? program = freezed,
    Object? currentLevel = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentProfileId: null == studentProfileId
                ? _value.studentProfileId
                : studentProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            programId: null == programId
                ? _value.programId
                : programId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentLevelId: freezed == currentLevelId
                ? _value.currentLevelId
                : currentLevelId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            program: freezed == program
                ? _value.program
                : program // ignore: cast_nullable_to_non_nullable
                      as EnrolledProgram?,
            currentLevel: freezed == currentLevel
                ? _value.currentLevel
                : currentLevel // ignore: cast_nullable_to_non_nullable
                      as EnrolledLevel?,
          )
          as $Val,
    );
  }

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EnrolledProgramCopyWith<$Res>? get program {
    if (_value.program == null) {
      return null;
    }

    return $EnrolledProgramCopyWith<$Res>(_value.program!, (value) {
      return _then(_value.copyWith(program: value) as $Val);
    });
  }

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EnrolledLevelCopyWith<$Res>? get currentLevel {
    if (_value.currentLevel == null) {
      return null;
    }

    return $EnrolledLevelCopyWith<$Res>(_value.currentLevel!, (value) {
      return _then(_value.copyWith(currentLevel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EnrollmentImplCopyWith<$Res>
    implements $EnrollmentCopyWith<$Res> {
  factory _$$EnrollmentImplCopyWith(
    _$EnrollmentImpl value,
    $Res Function(_$EnrollmentImpl) then,
  ) = __$$EnrollmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    String studentProfileId,
    @JsonKey(name: 'program_id', fromJson: idFromJson) String programId,
    @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
    String? currentLevelId,
    String status,
    EnrolledProgram? program,
    @JsonKey(name: 'current_level') EnrolledLevel? currentLevel,
  });

  @override
  $EnrolledProgramCopyWith<$Res>? get program;
  @override
  $EnrolledLevelCopyWith<$Res>? get currentLevel;
}

/// @nodoc
class __$$EnrollmentImplCopyWithImpl<$Res>
    extends _$EnrollmentCopyWithImpl<$Res, _$EnrollmentImpl>
    implements _$$EnrollmentImplCopyWith<$Res> {
  __$$EnrollmentImplCopyWithImpl(
    _$EnrollmentImpl _value,
    $Res Function(_$EnrollmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentProfileId = null,
    Object? programId = null,
    Object? currentLevelId = freezed,
    Object? status = null,
    Object? program = freezed,
    Object? currentLevel = freezed,
  }) {
    return _then(
      _$EnrollmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentProfileId: null == studentProfileId
            ? _value.studentProfileId
            : studentProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        programId: null == programId
            ? _value.programId
            : programId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentLevelId: freezed == currentLevelId
            ? _value.currentLevelId
            : currentLevelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        program: freezed == program
            ? _value.program
            : program // ignore: cast_nullable_to_non_nullable
                  as EnrolledProgram?,
        currentLevel: freezed == currentLevel
            ? _value.currentLevel
            : currentLevel // ignore: cast_nullable_to_non_nullable
                  as EnrolledLevel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrollmentImpl implements _Enrollment {
  const _$EnrollmentImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required this.studentProfileId,
    @JsonKey(name: 'program_id', fromJson: idFromJson) required this.programId,
    @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
    this.currentLevelId,
    this.status = 'active',
    this.program,
    @JsonKey(name: 'current_level') this.currentLevel,
  });

  factory _$EnrollmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrollmentImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  final String studentProfileId;
  @override
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  final String programId;
  @override
  @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
  final String? currentLevelId;
  @override
  @JsonKey()
  final String status;
  @override
  final EnrolledProgram? program;
  @override
  @JsonKey(name: 'current_level')
  final EnrolledLevel? currentLevel;

  @override
  String toString() {
    return 'Enrollment(id: $id, studentProfileId: $studentProfileId, programId: $programId, currentLevelId: $currentLevelId, status: $status, program: $program, currentLevel: $currentLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrollmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentProfileId, studentProfileId) ||
                other.studentProfileId == studentProfileId) &&
            (identical(other.programId, programId) ||
                other.programId == programId) &&
            (identical(other.currentLevelId, currentLevelId) ||
                other.currentLevelId == currentLevelId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.program, program) || other.program == program) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentProfileId,
    programId,
    currentLevelId,
    status,
    program,
    currentLevel,
  );

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrollmentImplCopyWith<_$EnrollmentImpl> get copyWith =>
      __$$EnrollmentImplCopyWithImpl<_$EnrollmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrollmentImplToJson(this);
  }
}

abstract class _Enrollment implements Enrollment {
  const factory _Enrollment({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
    required final String studentProfileId,
    @JsonKey(name: 'program_id', fromJson: idFromJson)
    required final String programId,
    @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
    final String? currentLevelId,
    final String status,
    final EnrolledProgram? program,
    @JsonKey(name: 'current_level') final EnrolledLevel? currentLevel,
  }) = _$EnrollmentImpl;

  factory _Enrollment.fromJson(Map<String, dynamic> json) =
      _$EnrollmentImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'student_profile_id', fromJson: idFromJson)
  String get studentProfileId;
  @override
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  String get programId;
  @override
  @JsonKey(name: 'current_level_id', fromJson: nullableIdFromJson)
  String? get currentLevelId;
  @override
  String get status;
  @override
  EnrolledProgram? get program;
  @override
  @JsonKey(name: 'current_level')
  EnrolledLevel? get currentLevel;

  /// Create a copy of Enrollment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrollmentImplCopyWith<_$EnrollmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnrolledProgram _$EnrolledProgramFromJson(Map<String, dynamic> json) {
  return _EnrolledProgram.fromJson(json);
}

/// @nodoc
mixin _$EnrolledProgram {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this EnrolledProgram to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnrolledProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrolledProgramCopyWith<EnrolledProgram> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrolledProgramCopyWith<$Res> {
  factory $EnrolledProgramCopyWith(
    EnrolledProgram value,
    $Res Function(EnrolledProgram) then,
  ) = _$EnrolledProgramCopyWithImpl<$Res, EnrolledProgram>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String name});
}

/// @nodoc
class _$EnrolledProgramCopyWithImpl<$Res, $Val extends EnrolledProgram>
    implements $EnrolledProgramCopyWith<$Res> {
  _$EnrolledProgramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrolledProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnrolledProgramImplCopyWith<$Res>
    implements $EnrolledProgramCopyWith<$Res> {
  factory _$$EnrolledProgramImplCopyWith(
    _$EnrolledProgramImpl value,
    $Res Function(_$EnrolledProgramImpl) then,
  ) = __$$EnrolledProgramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String name});
}

/// @nodoc
class __$$EnrolledProgramImplCopyWithImpl<$Res>
    extends _$EnrolledProgramCopyWithImpl<$Res, _$EnrolledProgramImpl>
    implements _$$EnrolledProgramImplCopyWith<$Res> {
  __$$EnrolledProgramImplCopyWithImpl(
    _$EnrolledProgramImpl _value,
    $Res Function(_$EnrolledProgramImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrolledProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$EnrolledProgramImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrolledProgramImpl implements _EnrolledProgram {
  const _$EnrolledProgramImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
  });

  factory _$EnrolledProgramImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrolledProgramImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'EnrolledProgram(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrolledProgramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of EnrolledProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrolledProgramImplCopyWith<_$EnrolledProgramImpl> get copyWith =>
      __$$EnrolledProgramImplCopyWithImpl<_$EnrolledProgramImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrolledProgramImplToJson(this);
  }
}

abstract class _EnrolledProgram implements EnrolledProgram {
  const factory _EnrolledProgram({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
  }) = _$EnrolledProgramImpl;

  factory _EnrolledProgram.fromJson(Map<String, dynamic> json) =
      _$EnrolledProgramImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;

  /// Create a copy of EnrolledProgram
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrolledProgramImplCopyWith<_$EnrolledProgramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnrolledLevel _$EnrolledLevelFromJson(Map<String, dynamic> json) {
  return _EnrolledLevel.fromJson(json);
}

/// @nodoc
mixin _$EnrolledLevel {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this EnrolledLevel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnrolledLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrolledLevelCopyWith<EnrolledLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrolledLevelCopyWith<$Res> {
  factory $EnrolledLevelCopyWith(
    EnrolledLevel value,
    $Res Function(EnrolledLevel) then,
  ) = _$EnrolledLevelCopyWithImpl<$Res, EnrolledLevel>;
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String name});
}

/// @nodoc
class _$EnrolledLevelCopyWithImpl<$Res, $Val extends EnrolledLevel>
    implements $EnrolledLevelCopyWith<$Res> {
  _$EnrolledLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrolledLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnrolledLevelImplCopyWith<$Res>
    implements $EnrolledLevelCopyWith<$Res> {
  factory _$$EnrolledLevelImplCopyWith(
    _$EnrolledLevelImpl value,
    $Res Function(_$EnrolledLevelImpl) then,
  ) = __$$EnrolledLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(fromJson: idFromJson) String id, String name});
}

/// @nodoc
class __$$EnrolledLevelImplCopyWithImpl<$Res>
    extends _$EnrolledLevelCopyWithImpl<$Res, _$EnrolledLevelImpl>
    implements _$$EnrolledLevelImplCopyWith<$Res> {
  __$$EnrolledLevelImplCopyWithImpl(
    _$EnrolledLevelImpl _value,
    $Res Function(_$EnrolledLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrolledLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$EnrolledLevelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrolledLevelImpl implements _EnrolledLevel {
  const _$EnrolledLevelImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
  });

  factory _$EnrolledLevelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrolledLevelImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'EnrolledLevel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrolledLevelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of EnrolledLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrolledLevelImplCopyWith<_$EnrolledLevelImpl> get copyWith =>
      __$$EnrolledLevelImplCopyWithImpl<_$EnrolledLevelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrolledLevelImplToJson(this);
  }
}

abstract class _EnrolledLevel implements EnrolledLevel {
  const factory _EnrolledLevel({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
  }) = _$EnrolledLevelImpl;

  factory _EnrolledLevel.fromJson(Map<String, dynamic> json) =
      _$EnrolledLevelImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;

  /// Create a copy of EnrolledLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrolledLevelImplCopyWith<_$EnrolledLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
