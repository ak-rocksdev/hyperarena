// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sport_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SportFilter _$SportFilterFromJson(Map<String, dynamic> json) {
  return _SportFilter.fromJson(json);
}

/// @nodoc
mixin _$SportFilter {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;

  /// Serializes this SportFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SportFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SportFilterCopyWith<SportFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SportFilterCopyWith<$Res> {
  factory $SportFilterCopyWith(
    SportFilter value,
    $Res Function(SportFilter) then,
  ) = _$SportFilterCopyWithImpl<$Res, SportFilter>;
  @useResult
  $Res call({int id, String name, String? icon});
}

/// @nodoc
class _$SportFilterCopyWithImpl<$Res, $Val extends SportFilter>
    implements $SportFilterCopyWith<$Res> {
  _$SportFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SportFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? icon = freezed}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SportFilterImplCopyWith<$Res>
    implements $SportFilterCopyWith<$Res> {
  factory _$$SportFilterImplCopyWith(
    _$SportFilterImpl value,
    $Res Function(_$SportFilterImpl) then,
  ) = __$$SportFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? icon});
}

/// @nodoc
class __$$SportFilterImplCopyWithImpl<$Res>
    extends _$SportFilterCopyWithImpl<$Res, _$SportFilterImpl>
    implements _$$SportFilterImplCopyWith<$Res> {
  __$$SportFilterImplCopyWithImpl(
    _$SportFilterImpl _value,
    $Res Function(_$SportFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SportFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? icon = freezed}) {
    return _then(
      _$SportFilterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SportFilterImpl implements _SportFilter {
  const _$SportFilterImpl({required this.id, required this.name, this.icon});

  factory _$SportFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$SportFilterImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? icon;

  @override
  String toString() {
    return 'SportFilter(id: $id, name: $name, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SportFilterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon);

  /// Create a copy of SportFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SportFilterImplCopyWith<_$SportFilterImpl> get copyWith =>
      __$$SportFilterImplCopyWithImpl<_$SportFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SportFilterImplToJson(this);
  }
}

abstract class _SportFilter implements SportFilter {
  const factory _SportFilter({
    required final int id,
    required final String name,
    final String? icon,
  }) = _$SportFilterImpl;

  factory _SportFilter.fromJson(Map<String, dynamic> json) =
      _$SportFilterImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get icon;

  /// Create a copy of SportFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SportFilterImplCopyWith<_$SportFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
