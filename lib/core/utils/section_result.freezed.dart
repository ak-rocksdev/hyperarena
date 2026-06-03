// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SectionResult<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) success,
    required TResult Function(Object error, StackTrace? stackTrace) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? success,
    TResult? Function(Object error, StackTrace? stackTrace)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? success,
    TResult Function(Object error, StackTrace? stackTrace)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SectionSuccess<T> value) success,
    required TResult Function(SectionFailure<T> value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SectionSuccess<T> value)? success,
    TResult? Function(SectionFailure<T> value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SectionSuccess<T> value)? success,
    TResult Function(SectionFailure<T> value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionResultCopyWith<T, $Res> {
  factory $SectionResultCopyWith(
    SectionResult<T> value,
    $Res Function(SectionResult<T>) then,
  ) = _$SectionResultCopyWithImpl<T, $Res, SectionResult<T>>;
}

/// @nodoc
class _$SectionResultCopyWithImpl<T, $Res, $Val extends SectionResult<T>>
    implements $SectionResultCopyWith<T, $Res> {
  _$SectionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SectionSuccessImplCopyWith<T, $Res> {
  factory _$$SectionSuccessImplCopyWith(
    _$SectionSuccessImpl<T> value,
    $Res Function(_$SectionSuccessImpl<T>) then,
  ) = __$$SectionSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$SectionSuccessImplCopyWithImpl<T, $Res>
    extends _$SectionResultCopyWithImpl<T, $Res, _$SectionSuccessImpl<T>>
    implements _$$SectionSuccessImplCopyWith<T, $Res> {
  __$$SectionSuccessImplCopyWithImpl(
    _$SectionSuccessImpl<T> _value,
    $Res Function(_$SectionSuccessImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = freezed}) {
    return _then(
      _$SectionSuccessImpl<T>(
        freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as T,
      ),
    );
  }
}

/// @nodoc

class _$SectionSuccessImpl<T> extends SectionSuccess<T> {
  const _$SectionSuccessImpl(this.value) : super._();

  @override
  final T value;

  @override
  String toString() {
    return 'SectionResult<$T>.success(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionSuccessImplCopyWith<T, _$SectionSuccessImpl<T>> get copyWith =>
      __$$SectionSuccessImplCopyWithImpl<T, _$SectionSuccessImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) success,
    required TResult Function(Object error, StackTrace? stackTrace) failure,
  }) {
    return success(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? success,
    TResult? Function(Object error, StackTrace? stackTrace)? failure,
  }) {
    return success?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? success,
    TResult Function(Object error, StackTrace? stackTrace)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SectionSuccess<T> value) success,
    required TResult Function(SectionFailure<T> value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SectionSuccess<T> value)? success,
    TResult? Function(SectionFailure<T> value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SectionSuccess<T> value)? success,
    TResult Function(SectionFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SectionSuccess<T> extends SectionResult<T> {
  const factory SectionSuccess(final T value) = _$SectionSuccessImpl<T>;
  const SectionSuccess._() : super._();

  T get value;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionSuccessImplCopyWith<T, _$SectionSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SectionFailureImplCopyWith<T, $Res> {
  factory _$$SectionFailureImplCopyWith(
    _$SectionFailureImpl<T> value,
    $Res Function(_$SectionFailureImpl<T>) then,
  ) = __$$SectionFailureImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Object error, StackTrace? stackTrace});
}

/// @nodoc
class __$$SectionFailureImplCopyWithImpl<T, $Res>
    extends _$SectionResultCopyWithImpl<T, $Res, _$SectionFailureImpl<T>>
    implements _$$SectionFailureImplCopyWith<T, $Res> {
  __$$SectionFailureImplCopyWithImpl(
    _$SectionFailureImpl<T> _value,
    $Res Function(_$SectionFailureImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null, Object? stackTrace = freezed}) {
    return _then(
      _$SectionFailureImpl<T>(
        null == error ? _value.error : error,
        freezed == stackTrace
            ? _value.stackTrace
            : stackTrace // ignore: cast_nullable_to_non_nullable
                  as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$SectionFailureImpl<T> extends SectionFailure<T> {
  const _$SectionFailureImpl(this.error, this.stackTrace) : super._();

  @override
  final Object error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'SectionResult<$T>.failure(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionFailureImpl<T> &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionFailureImplCopyWith<T, _$SectionFailureImpl<T>> get copyWith =>
      __$$SectionFailureImplCopyWithImpl<T, _$SectionFailureImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) success,
    required TResult Function(Object error, StackTrace? stackTrace) failure,
  }) {
    return failure(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T value)? success,
    TResult? Function(Object error, StackTrace? stackTrace)? failure,
  }) {
    return failure?.call(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? success,
    TResult Function(Object error, StackTrace? stackTrace)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SectionSuccess<T> value) success,
    required TResult Function(SectionFailure<T> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SectionSuccess<T> value)? success,
    TResult? Function(SectionFailure<T> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SectionSuccess<T> value)? success,
    TResult Function(SectionFailure<T> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SectionFailure<T> extends SectionResult<T> {
  const factory SectionFailure(
    final Object error,
    final StackTrace? stackTrace,
  ) = _$SectionFailureImpl<T>;
  const SectionFailure._() : super._();

  Object get error;
  StackTrace? get stackTrace;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionFailureImplCopyWith<T, _$SectionFailureImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
