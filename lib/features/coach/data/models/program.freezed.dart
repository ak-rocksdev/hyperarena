// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Program _$ProgramFromJson(Map<String, dynamic> json) {
  return _Program.fromJson(json);
}

/// @nodoc
mixin _$Program {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this Program to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Program
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramCopyWith<Program> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramCopyWith<$Res> {
  factory $ProgramCopyWith(Program value, $Res Function(Program) then) =
      _$ProgramCopyWithImpl<$Res, Program>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? description,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$ProgramCopyWithImpl<$Res, $Val extends Program>
    implements $ProgramCopyWith<$Res> {
  _$ProgramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Program
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgramImplCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$$ProgramImplCopyWith(
    _$ProgramImpl value,
    $Res Function(_$ProgramImpl) then,
  ) = __$$ProgramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String? description,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$ProgramImplCopyWithImpl<$Res>
    extends _$ProgramCopyWithImpl<$Res, _$ProgramImpl>
    implements _$$ProgramImplCopyWith<$Res> {
  __$$ProgramImplCopyWithImpl(
    _$ProgramImpl _value,
    $Res Function(_$ProgramImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Program
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$ProgramImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramImpl implements _Program {
  const _$ProgramImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.description,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$ProgramImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'Program(id: $id, name: $name, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, isActive);

  /// Create a copy of Program
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramImplCopyWith<_$ProgramImpl> get copyWith =>
      __$$ProgramImplCopyWithImpl<_$ProgramImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramImplToJson(this);
  }
}

abstract class _Program implements Program {
  const factory _Program({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String? description,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$ProgramImpl;

  factory _Program.fromJson(Map<String, dynamic> json) = _$ProgramImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of Program
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramImplCopyWith<_$ProgramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgramLevel _$ProgramLevelFromJson(Map<String, dynamic> json) {
  return _ProgramLevel.fromJson(json);
}

/// @nodoc
mixin _$ProgramLevel {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  String get programId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this ProgramLevel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgramLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramLevelCopyWith<ProgramLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramLevelCopyWith<$Res> {
  factory $ProgramLevelCopyWith(
    ProgramLevel value,
    $Res Function(ProgramLevel) then,
  ) = _$ProgramLevelCopyWithImpl<$Res, ProgramLevel>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'program_id', fromJson: idFromJson) String programId,
    String name,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class _$ProgramLevelCopyWithImpl<$Res, $Val extends ProgramLevel>
    implements $ProgramLevelCopyWith<$Res> {
  _$ProgramLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgramLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? programId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            programId: null == programId
                ? _value.programId
                : programId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgramLevelImplCopyWith<$Res>
    implements $ProgramLevelCopyWith<$Res> {
  factory _$$ProgramLevelImplCopyWith(
    _$ProgramLevelImpl value,
    $Res Function(_$ProgramLevelImpl) then,
  ) = __$$ProgramLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'program_id', fromJson: idFromJson) String programId,
    String name,
    String? description,
    @JsonKey(name: 'sort_order') int sortOrder,
  });
}

/// @nodoc
class __$$ProgramLevelImplCopyWithImpl<$Res>
    extends _$ProgramLevelCopyWithImpl<$Res, _$ProgramLevelImpl>
    implements _$$ProgramLevelImplCopyWith<$Res> {
  __$$ProgramLevelImplCopyWithImpl(
    _$ProgramLevelImpl _value,
    $Res Function(_$ProgramLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgramLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? programId = null,
    Object? name = null,
    Object? description = freezed,
    Object? sortOrder = null,
  }) {
    return _then(
      _$ProgramLevelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        programId: null == programId
            ? _value.programId
            : programId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramLevelImpl implements _ProgramLevel {
  const _$ProgramLevelImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'program_id', fromJson: idFromJson) required this.programId,
    required this.name,
    this.description,
    @JsonKey(name: 'sort_order') this.sortOrder = 0,
  });

  factory _$ProgramLevelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramLevelImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  final String programId;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'ProgramLevel(id: $id, programId: $programId, name: $name, description: $description, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramLevelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.programId, programId) ||
                other.programId == programId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, programId, name, description, sortOrder);

  /// Create a copy of ProgramLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramLevelImplCopyWith<_$ProgramLevelImpl> get copyWith =>
      __$$ProgramLevelImplCopyWithImpl<_$ProgramLevelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramLevelImplToJson(this);
  }
}

abstract class _ProgramLevel implements ProgramLevel {
  const factory _ProgramLevel({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'program_id', fromJson: idFromJson)
    required final String programId,
    required final String name,
    final String? description,
    @JsonKey(name: 'sort_order') final int sortOrder,
  }) = _$ProgramLevelImpl;

  factory _ProgramLevel.fromJson(Map<String, dynamic> json) =
      _$ProgramLevelImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'program_id', fromJson: idFromJson)
  String get programId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;

  /// Create a copy of ProgramLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramLevelImplCopyWith<_$ProgramLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
