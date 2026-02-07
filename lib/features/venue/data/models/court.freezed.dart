// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'court.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Court _$CourtFromJson(Map<String, dynamic> json) {
  return _Court.fromJson(json);
}

/// @nodoc
mixin _$Court {
  String get id => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Sport get sportType => throw _privateConstructorUsedError;
  String? get surfaceType => throw _privateConstructorUsedError;
  String get environment => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this Court to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Court
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourtCopyWith<Court> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourtCopyWith<$Res> {
  factory $CourtCopyWith(Court value, $Res Function(Court) then) =
      _$CourtCopyWithImpl<$Res, Court>;
  @useResult
  $Res call({
    String id,
    String venueId,
    String name,
    Sport sportType,
    String? surfaceType,
    String environment,
    List<String> photos,
    bool isActive,
  });
}

/// @nodoc
class _$CourtCopyWithImpl<$Res, $Val extends Court>
    implements $CourtCopyWith<$Res> {
  _$CourtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Court
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? name = null,
    Object? sportType = null,
    Object? surfaceType = freezed,
    Object? environment = null,
    Object? photos = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            venueId: null == venueId
                ? _value.venueId
                : venueId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sportType: null == sportType
                ? _value.sportType
                : sportType // ignore: cast_nullable_to_non_nullable
                      as Sport,
            surfaceType: freezed == surfaceType
                ? _value.surfaceType
                : surfaceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            environment: null == environment
                ? _value.environment
                : environment // ignore: cast_nullable_to_non_nullable
                      as String,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$CourtImplCopyWith<$Res> implements $CourtCopyWith<$Res> {
  factory _$$CourtImplCopyWith(
    _$CourtImpl value,
    $Res Function(_$CourtImpl) then,
  ) = __$$CourtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String venueId,
    String name,
    Sport sportType,
    String? surfaceType,
    String environment,
    List<String> photos,
    bool isActive,
  });
}

/// @nodoc
class __$$CourtImplCopyWithImpl<$Res>
    extends _$CourtCopyWithImpl<$Res, _$CourtImpl>
    implements _$$CourtImplCopyWith<$Res> {
  __$$CourtImplCopyWithImpl(
    _$CourtImpl _value,
    $Res Function(_$CourtImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Court
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueId = null,
    Object? name = null,
    Object? sportType = null,
    Object? surfaceType = freezed,
    Object? environment = null,
    Object? photos = null,
    Object? isActive = null,
  }) {
    return _then(
      _$CourtImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        venueId: null == venueId
            ? _value.venueId
            : venueId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sportType: null == sportType
            ? _value.sportType
            : sportType // ignore: cast_nullable_to_non_nullable
                  as Sport,
        surfaceType: freezed == surfaceType
            ? _value.surfaceType
            : surfaceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        environment: null == environment
            ? _value.environment
            : environment // ignore: cast_nullable_to_non_nullable
                  as String,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$CourtImpl implements _Court {
  const _$CourtImpl({
    required this.id,
    required this.venueId,
    required this.name,
    required this.sportType,
    this.surfaceType,
    required this.environment,
    final List<String> photos = const [],
    this.isActive = true,
  }) : _photos = photos;

  factory _$CourtImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourtImplFromJson(json);

  @override
  final String id;
  @override
  final String venueId;
  @override
  final String name;
  @override
  final Sport sportType;
  @override
  final String? surfaceType;
  @override
  final String environment;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'Court(id: $id, venueId: $venueId, name: $name, sportType: $sportType, surfaceType: $surfaceType, environment: $environment, photos: $photos, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourtImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueId, venueId) || other.venueId == venueId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sportType, sportType) ||
                other.sportType == sportType) &&
            (identical(other.surfaceType, surfaceType) ||
                other.surfaceType == surfaceType) &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    venueId,
    name,
    sportType,
    surfaceType,
    environment,
    const DeepCollectionEquality().hash(_photos),
    isActive,
  );

  /// Create a copy of Court
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourtImplCopyWith<_$CourtImpl> get copyWith =>
      __$$CourtImplCopyWithImpl<_$CourtImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourtImplToJson(this);
  }
}

abstract class _Court implements Court {
  const factory _Court({
    required final String id,
    required final String venueId,
    required final String name,
    required final Sport sportType,
    final String? surfaceType,
    required final String environment,
    final List<String> photos,
    final bool isActive,
  }) = _$CourtImpl;

  factory _Court.fromJson(Map<String, dynamic> json) = _$CourtImpl.fromJson;

  @override
  String get id;
  @override
  String get venueId;
  @override
  String get name;
  @override
  Sport get sportType;
  @override
  String? get surfaceType;
  @override
  String get environment;
  @override
  List<String> get photos;
  @override
  bool get isActive;

  /// Create a copy of Court
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourtImplCopyWith<_$CourtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
