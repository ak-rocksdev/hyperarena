// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivitySubject _$ActivitySubjectFromJson(Map<String, dynamic> json) {
  return _ActivitySubject.fromJson(json);
}

/// @nodoc
mixin _$ActivitySubject {
  String get type => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this ActivitySubject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivitySubject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivitySubjectCopyWith<ActivitySubject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitySubjectCopyWith<$Res> {
  factory $ActivitySubjectCopyWith(
    ActivitySubject value,
    $Res Function(ActivitySubject) then,
  ) = _$ActivitySubjectCopyWithImpl<$Res, ActivitySubject>;
  @useResult
  $Res call({String type, int id, String? name});
}

/// @nodoc
class _$ActivitySubjectCopyWithImpl<$Res, $Val extends ActivitySubject>
    implements $ActivitySubjectCopyWith<$Res> {
  _$ActivitySubjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivitySubject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? id = null, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivitySubjectImplCopyWith<$Res>
    implements $ActivitySubjectCopyWith<$Res> {
  factory _$$ActivitySubjectImplCopyWith(
    _$ActivitySubjectImpl value,
    $Res Function(_$ActivitySubjectImpl) then,
  ) = __$$ActivitySubjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int id, String? name});
}

/// @nodoc
class __$$ActivitySubjectImplCopyWithImpl<$Res>
    extends _$ActivitySubjectCopyWithImpl<$Res, _$ActivitySubjectImpl>
    implements _$$ActivitySubjectImplCopyWith<$Res> {
  __$$ActivitySubjectImplCopyWithImpl(
    _$ActivitySubjectImpl _value,
    $Res Function(_$ActivitySubjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivitySubject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? id = null, Object? name = freezed}) {
    return _then(
      _$ActivitySubjectImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivitySubjectImpl implements _ActivitySubject {
  const _$ActivitySubjectImpl({
    required this.type,
    required this.id,
    this.name,
  });

  factory _$ActivitySubjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivitySubjectImplFromJson(json);

  @override
  final String type;
  @override
  final int id;
  @override
  final String? name;

  @override
  String toString() {
    return 'ActivitySubject(type: $type, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitySubjectImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, id, name);

  /// Create a copy of ActivitySubject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitySubjectImplCopyWith<_$ActivitySubjectImpl> get copyWith =>
      __$$ActivitySubjectImplCopyWithImpl<_$ActivitySubjectImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivitySubjectImplToJson(this);
  }
}

abstract class _ActivitySubject implements ActivitySubject {
  const factory _ActivitySubject({
    required final String type,
    required final int id,
    final String? name,
  }) = _$ActivitySubjectImpl;

  factory _ActivitySubject.fromJson(Map<String, dynamic> json) =
      _$ActivitySubjectImpl.fromJson;

  @override
  String get type;
  @override
  int get id;
  @override
  String? get name;

  /// Create a copy of ActivitySubject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivitySubjectImplCopyWith<_$ActivitySubjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) {
  return _ActivityItem.fromJson(json);
}

/// @nodoc
mixin _$ActivityItem {
  int get id => throw _privateConstructorUsedError;
  ActivityType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ActivitySubject? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'occurred_at')
  DateTime? get occurredAt => throw _privateConstructorUsedError;

  /// Serializes this ActivityItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityItemCopyWith<ActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityItemCopyWith<$Res> {
  factory $ActivityItemCopyWith(
    ActivityItem value,
    $Res Function(ActivityItem) then,
  ) = _$ActivityItemCopyWithImpl<$Res, ActivityItem>;
  @useResult
  $Res call({
    int id,
    ActivityType type,
    String description,
    ActivitySubject? subject,
    @JsonKey(name: 'occurred_at') DateTime? occurredAt,
  });

  $ActivitySubjectCopyWith<$Res>? get subject;
}

/// @nodoc
class _$ActivityItemCopyWithImpl<$Res, $Val extends ActivityItem>
    implements $ActivityItemCopyWith<$Res> {
  _$ActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? subject = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ActivityType,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            subject: freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as ActivitySubject?,
            occurredAt: freezed == occurredAt
                ? _value.occurredAt
                : occurredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivitySubjectCopyWith<$Res>? get subject {
    if (_value.subject == null) {
      return null;
    }

    return $ActivitySubjectCopyWith<$Res>(_value.subject!, (value) {
      return _then(_value.copyWith(subject: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ActivityItemImplCopyWith<$Res>
    implements $ActivityItemCopyWith<$Res> {
  factory _$$ActivityItemImplCopyWith(
    _$ActivityItemImpl value,
    $Res Function(_$ActivityItemImpl) then,
  ) = __$$ActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    ActivityType type,
    String description,
    ActivitySubject? subject,
    @JsonKey(name: 'occurred_at') DateTime? occurredAt,
  });

  @override
  $ActivitySubjectCopyWith<$Res>? get subject;
}

/// @nodoc
class __$$ActivityItemImplCopyWithImpl<$Res>
    extends _$ActivityItemCopyWithImpl<$Res, _$ActivityItemImpl>
    implements _$$ActivityItemImplCopyWith<$Res> {
  __$$ActivityItemImplCopyWithImpl(
    _$ActivityItemImpl _value,
    $Res Function(_$ActivityItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? description = null,
    Object? subject = freezed,
    Object? occurredAt = freezed,
  }) {
    return _then(
      _$ActivityItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ActivityType,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        subject: freezed == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as ActivitySubject?,
        occurredAt: freezed == occurredAt
            ? _value.occurredAt
            : occurredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityItemImpl implements _ActivityItem {
  const _$ActivityItemImpl({
    required this.id,
    required this.type,
    required this.description,
    this.subject,
    @JsonKey(name: 'occurred_at') this.occurredAt,
  });

  factory _$ActivityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityItemImplFromJson(json);

  @override
  final int id;
  @override
  final ActivityType type;
  @override
  final String description;
  @override
  final ActivitySubject? subject;
  @override
  @JsonKey(name: 'occurred_at')
  final DateTime? occurredAt;

  @override
  String toString() {
    return 'ActivityItem(id: $id, type: $type, description: $description, subject: $subject, occurredAt: $occurredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, description, subject, occurredAt);

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      __$$ActivityItemImplCopyWithImpl<_$ActivityItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityItemImplToJson(this);
  }
}

abstract class _ActivityItem implements ActivityItem {
  const factory _ActivityItem({
    required final int id,
    required final ActivityType type,
    required final String description,
    final ActivitySubject? subject,
    @JsonKey(name: 'occurred_at') final DateTime? occurredAt,
  }) = _$ActivityItemImpl;

  factory _ActivityItem.fromJson(Map<String, dynamic> json) =
      _$ActivityItemImpl.fromJson;

  @override
  int get id;
  @override
  ActivityType get type;
  @override
  String get description;
  @override
  ActivitySubject? get subject;
  @override
  @JsonKey(name: 'occurred_at')
  DateTime? get occurredAt;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
