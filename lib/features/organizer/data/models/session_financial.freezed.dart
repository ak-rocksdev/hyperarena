// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_financial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionFinancial _$SessionFinancialFromJson(Map<String, dynamic> json) {
  return _SessionFinancial.fromJson(json);
}

/// @nodoc
mixin _$SessionFinancial {
  FinancialSide get revenue => throw _privateConstructorUsedError;
  FinancialSide get cost => throw _privateConstructorUsedError;
  FinancialNet get net => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this SessionFinancial to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionFinancialCopyWith<SessionFinancial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionFinancialCopyWith<$Res> {
  factory $SessionFinancialCopyWith(
    SessionFinancial value,
    $Res Function(SessionFinancial) then,
  ) = _$SessionFinancialCopyWithImpl<$Res, SessionFinancial>;
  @useResult
  $Res call({
    FinancialSide revenue,
    FinancialSide cost,
    FinancialNet net,
    String currency,
  });

  $FinancialSideCopyWith<$Res> get revenue;
  $FinancialSideCopyWith<$Res> get cost;
  $FinancialNetCopyWith<$Res> get net;
}

/// @nodoc
class _$SessionFinancialCopyWithImpl<$Res, $Val extends SessionFinancial>
    implements $SessionFinancialCopyWith<$Res> {
  _$SessionFinancialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? cost = null,
    Object? net = null,
    Object? currency = null,
  }) {
    return _then(
      _value.copyWith(
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as FinancialSide,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as FinancialSide,
            net: null == net
                ? _value.net
                : net // ignore: cast_nullable_to_non_nullable
                      as FinancialNet,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialSideCopyWith<$Res> get revenue {
    return $FinancialSideCopyWith<$Res>(_value.revenue, (value) {
      return _then(_value.copyWith(revenue: value) as $Val);
    });
  }

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialSideCopyWith<$Res> get cost {
    return $FinancialSideCopyWith<$Res>(_value.cost, (value) {
      return _then(_value.copyWith(cost: value) as $Val);
    });
  }

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialNetCopyWith<$Res> get net {
    return $FinancialNetCopyWith<$Res>(_value.net, (value) {
      return _then(_value.copyWith(net: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionFinancialImplCopyWith<$Res>
    implements $SessionFinancialCopyWith<$Res> {
  factory _$$SessionFinancialImplCopyWith(
    _$SessionFinancialImpl value,
    $Res Function(_$SessionFinancialImpl) then,
  ) = __$$SessionFinancialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    FinancialSide revenue,
    FinancialSide cost,
    FinancialNet net,
    String currency,
  });

  @override
  $FinancialSideCopyWith<$Res> get revenue;
  @override
  $FinancialSideCopyWith<$Res> get cost;
  @override
  $FinancialNetCopyWith<$Res> get net;
}

/// @nodoc
class __$$SessionFinancialImplCopyWithImpl<$Res>
    extends _$SessionFinancialCopyWithImpl<$Res, _$SessionFinancialImpl>
    implements _$$SessionFinancialImplCopyWith<$Res> {
  __$$SessionFinancialImplCopyWithImpl(
    _$SessionFinancialImpl _value,
    $Res Function(_$SessionFinancialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? revenue = null,
    Object? cost = null,
    Object? net = null,
    Object? currency = null,
  }) {
    return _then(
      _$SessionFinancialImpl(
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as FinancialSide,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as FinancialSide,
        net: null == net
            ? _value.net
            : net // ignore: cast_nullable_to_non_nullable
                  as FinancialNet,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionFinancialImpl implements _SessionFinancial {
  const _$SessionFinancialImpl({
    required this.revenue,
    required this.cost,
    required this.net,
    this.currency = 'IDR',
  });

  factory _$SessionFinancialImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionFinancialImplFromJson(json);

  @override
  final FinancialSide revenue;
  @override
  final FinancialSide cost;
  @override
  final FinancialNet net;
  @override
  @JsonKey()
  final String currency;

  @override
  String toString() {
    return 'SessionFinancial(revenue: $revenue, cost: $cost, net: $net, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionFinancialImpl &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, revenue, cost, net, currency);

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionFinancialImplCopyWith<_$SessionFinancialImpl> get copyWith =>
      __$$SessionFinancialImplCopyWithImpl<_$SessionFinancialImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionFinancialImplToJson(this);
  }
}

abstract class _SessionFinancial implements SessionFinancial {
  const factory _SessionFinancial({
    required final FinancialSide revenue,
    required final FinancialSide cost,
    required final FinancialNet net,
    final String currency,
  }) = _$SessionFinancialImpl;

  factory _SessionFinancial.fromJson(Map<String, dynamic> json) =
      _$SessionFinancialImpl.fromJson;

  @override
  FinancialSide get revenue;
  @override
  FinancialSide get cost;
  @override
  FinancialNet get net;
  @override
  String get currency;

  /// Create a copy of SessionFinancial
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionFinancialImplCopyWith<_$SessionFinancialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialSide _$FinancialSideFromJson(Map<String, dynamic> json) {
  return _FinancialSide.fromJson(json);
}

/// @nodoc
mixin _$FinancialSide {
  int get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_tracked')
  SystemTrackedBlock get systemTracked => throw _privateConstructorUsedError;
  CustomBlock get custom => throw _privateConstructorUsedError;

  /// Serializes this FinancialSide to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialSideCopyWith<FinancialSide> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialSideCopyWith<$Res> {
  factory $FinancialSideCopyWith(
    FinancialSide value,
    $Res Function(FinancialSide) then,
  ) = _$FinancialSideCopyWithImpl<$Res, FinancialSide>;
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'system_tracked') SystemTrackedBlock systemTracked,
    CustomBlock custom,
  });

  $SystemTrackedBlockCopyWith<$Res> get systemTracked;
  $CustomBlockCopyWith<$Res> get custom;
}

/// @nodoc
class _$FinancialSideCopyWithImpl<$Res, $Val extends FinancialSide>
    implements $FinancialSideCopyWith<$Res> {
  _$FinancialSideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? systemTracked = null,
    Object? custom = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            systemTracked: null == systemTracked
                ? _value.systemTracked
                : systemTracked // ignore: cast_nullable_to_non_nullable
                      as SystemTrackedBlock,
            custom: null == custom
                ? _value.custom
                : custom // ignore: cast_nullable_to_non_nullable
                      as CustomBlock,
          )
          as $Val,
    );
  }

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SystemTrackedBlockCopyWith<$Res> get systemTracked {
    return $SystemTrackedBlockCopyWith<$Res>(_value.systemTracked, (value) {
      return _then(_value.copyWith(systemTracked: value) as $Val);
    });
  }

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomBlockCopyWith<$Res> get custom {
    return $CustomBlockCopyWith<$Res>(_value.custom, (value) {
      return _then(_value.copyWith(custom: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialSideImplCopyWith<$Res>
    implements $FinancialSideCopyWith<$Res> {
  factory _$$FinancialSideImplCopyWith(
    _$FinancialSideImpl value,
    $Res Function(_$FinancialSideImpl) then,
  ) = __$$FinancialSideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int total,
    @JsonKey(name: 'system_tracked') SystemTrackedBlock systemTracked,
    CustomBlock custom,
  });

  @override
  $SystemTrackedBlockCopyWith<$Res> get systemTracked;
  @override
  $CustomBlockCopyWith<$Res> get custom;
}

/// @nodoc
class __$$FinancialSideImplCopyWithImpl<$Res>
    extends _$FinancialSideCopyWithImpl<$Res, _$FinancialSideImpl>
    implements _$$FinancialSideImplCopyWith<$Res> {
  __$$FinancialSideImplCopyWithImpl(
    _$FinancialSideImpl _value,
    $Res Function(_$FinancialSideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? systemTracked = null,
    Object? custom = null,
  }) {
    return _then(
      _$FinancialSideImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        systemTracked: null == systemTracked
            ? _value.systemTracked
            : systemTracked // ignore: cast_nullable_to_non_nullable
                  as SystemTrackedBlock,
        custom: null == custom
            ? _value.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as CustomBlock,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialSideImpl implements _FinancialSide {
  const _$FinancialSideImpl({
    this.total = 0,
    @JsonKey(name: 'system_tracked')
    this.systemTracked = const SystemTrackedBlock(),
    this.custom = const CustomBlock(),
  });

  factory _$FinancialSideImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialSideImplFromJson(json);

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey(name: 'system_tracked')
  final SystemTrackedBlock systemTracked;
  @override
  @JsonKey()
  final CustomBlock custom;

  @override
  String toString() {
    return 'FinancialSide(total: $total, systemTracked: $systemTracked, custom: $custom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialSideImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.systemTracked, systemTracked) ||
                other.systemTracked == systemTracked) &&
            (identical(other.custom, custom) || other.custom == custom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, systemTracked, custom);

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialSideImplCopyWith<_$FinancialSideImpl> get copyWith =>
      __$$FinancialSideImplCopyWithImpl<_$FinancialSideImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialSideImplToJson(this);
  }
}

abstract class _FinancialSide implements FinancialSide {
  const factory _FinancialSide({
    final int total,
    @JsonKey(name: 'system_tracked') final SystemTrackedBlock systemTracked,
    final CustomBlock custom,
  }) = _$FinancialSideImpl;

  factory _FinancialSide.fromJson(Map<String, dynamic> json) =
      _$FinancialSideImpl.fromJson;

  @override
  int get total;
  @override
  @JsonKey(name: 'system_tracked')
  SystemTrackedBlock get systemTracked;
  @override
  CustomBlock get custom;

  /// Create a copy of FinancialSide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialSideImplCopyWith<_$FinancialSideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SystemTrackedBlock _$SystemTrackedBlockFromJson(Map<String, dynamic> json) {
  return _SystemTrackedBlock.fromJson(json);
}

/// @nodoc
mixin _$SystemTrackedBlock {
  int get total => throw _privateConstructorUsedError;
  List<FinancialStream> get streams => throw _privateConstructorUsedError;

  /// Serializes this SystemTrackedBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemTrackedBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemTrackedBlockCopyWith<SystemTrackedBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemTrackedBlockCopyWith<$Res> {
  factory $SystemTrackedBlockCopyWith(
    SystemTrackedBlock value,
    $Res Function(SystemTrackedBlock) then,
  ) = _$SystemTrackedBlockCopyWithImpl<$Res, SystemTrackedBlock>;
  @useResult
  $Res call({int total, List<FinancialStream> streams});
}

/// @nodoc
class _$SystemTrackedBlockCopyWithImpl<$Res, $Val extends SystemTrackedBlock>
    implements $SystemTrackedBlockCopyWith<$Res> {
  _$SystemTrackedBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemTrackedBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? streams = null}) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            streams: null == streams
                ? _value.streams
                : streams // ignore: cast_nullable_to_non_nullable
                      as List<FinancialStream>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SystemTrackedBlockImplCopyWith<$Res>
    implements $SystemTrackedBlockCopyWith<$Res> {
  factory _$$SystemTrackedBlockImplCopyWith(
    _$SystemTrackedBlockImpl value,
    $Res Function(_$SystemTrackedBlockImpl) then,
  ) = __$$SystemTrackedBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, List<FinancialStream> streams});
}

/// @nodoc
class __$$SystemTrackedBlockImplCopyWithImpl<$Res>
    extends _$SystemTrackedBlockCopyWithImpl<$Res, _$SystemTrackedBlockImpl>
    implements _$$SystemTrackedBlockImplCopyWith<$Res> {
  __$$SystemTrackedBlockImplCopyWithImpl(
    _$SystemTrackedBlockImpl _value,
    $Res Function(_$SystemTrackedBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemTrackedBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? streams = null}) {
    return _then(
      _$SystemTrackedBlockImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        streams: null == streams
            ? _value._streams
            : streams // ignore: cast_nullable_to_non_nullable
                  as List<FinancialStream>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemTrackedBlockImpl implements _SystemTrackedBlock {
  const _$SystemTrackedBlockImpl({
    this.total = 0,
    final List<FinancialStream> streams = const <FinancialStream>[],
  }) : _streams = streams;

  factory _$SystemTrackedBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemTrackedBlockImplFromJson(json);

  @override
  @JsonKey()
  final int total;
  final List<FinancialStream> _streams;
  @override
  @JsonKey()
  List<FinancialStream> get streams {
    if (_streams is EqualUnmodifiableListView) return _streams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_streams);
  }

  @override
  String toString() {
    return 'SystemTrackedBlock(total: $total, streams: $streams)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemTrackedBlockImpl &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._streams, _streams));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    const DeepCollectionEquality().hash(_streams),
  );

  /// Create a copy of SystemTrackedBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemTrackedBlockImplCopyWith<_$SystemTrackedBlockImpl> get copyWith =>
      __$$SystemTrackedBlockImplCopyWithImpl<_$SystemTrackedBlockImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemTrackedBlockImplToJson(this);
  }
}

abstract class _SystemTrackedBlock implements SystemTrackedBlock {
  const factory _SystemTrackedBlock({
    final int total,
    final List<FinancialStream> streams,
  }) = _$SystemTrackedBlockImpl;

  factory _SystemTrackedBlock.fromJson(Map<String, dynamic> json) =
      _$SystemTrackedBlockImpl.fromJson;

  @override
  int get total;
  @override
  List<FinancialStream> get streams;

  /// Create a copy of SystemTrackedBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemTrackedBlockImplCopyWith<_$SystemTrackedBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialStream _$FinancialStreamFromJson(Map<String, dynamic> json) {
  return _FinancialStream.fromJson(json);
}

/// @nodoc
mixin _$FinancialStream {
  String get key => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;

  /// Serializes this FinancialStream to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialStream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialStreamCopyWith<FinancialStream> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialStreamCopyWith<$Res> {
  factory $FinancialStreamCopyWith(
    FinancialStream value,
    $Res Function(FinancialStream) then,
  ) = _$FinancialStreamCopyWithImpl<$Res, FinancialStream>;
  @useResult
  $Res call({String key, int amount});
}

/// @nodoc
class _$FinancialStreamCopyWithImpl<$Res, $Val extends FinancialStream>
    implements $FinancialStreamCopyWith<$Res> {
  _$FinancialStreamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialStream
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialStreamImplCopyWith<$Res>
    implements $FinancialStreamCopyWith<$Res> {
  factory _$$FinancialStreamImplCopyWith(
    _$FinancialStreamImpl value,
    $Res Function(_$FinancialStreamImpl) then,
  ) = __$$FinancialStreamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, int amount});
}

/// @nodoc
class __$$FinancialStreamImplCopyWithImpl<$Res>
    extends _$FinancialStreamCopyWithImpl<$Res, _$FinancialStreamImpl>
    implements _$$FinancialStreamImplCopyWith<$Res> {
  __$$FinancialStreamImplCopyWithImpl(
    _$FinancialStreamImpl _value,
    $Res Function(_$FinancialStreamImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialStream
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null, Object? amount = null}) {
    return _then(
      _$FinancialStreamImpl(
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialStreamImpl implements _FinancialStream {
  const _$FinancialStreamImpl({required this.key, this.amount = 0});

  factory _$FinancialStreamImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialStreamImplFromJson(json);

  @override
  final String key;
  @override
  @JsonKey()
  final int amount;

  @override
  String toString() {
    return 'FinancialStream(key: $key, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialStreamImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, amount);

  /// Create a copy of FinancialStream
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialStreamImplCopyWith<_$FinancialStreamImpl> get copyWith =>
      __$$FinancialStreamImplCopyWithImpl<_$FinancialStreamImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialStreamImplToJson(this);
  }
}

abstract class _FinancialStream implements FinancialStream {
  const factory _FinancialStream({
    required final String key,
    final int amount,
  }) = _$FinancialStreamImpl;

  factory _FinancialStream.fromJson(Map<String, dynamic> json) =
      _$FinancialStreamImpl.fromJson;

  @override
  String get key;
  @override
  int get amount;

  /// Create a copy of FinancialStream
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialStreamImplCopyWith<_$FinancialStreamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomBlock _$CustomBlockFromJson(Map<String, dynamic> json) {
  return _CustomBlock.fromJson(json);
}

/// @nodoc
mixin _$CustomBlock {
  int get total => throw _privateConstructorUsedError;
  List<FinancialEntry> get entries => throw _privateConstructorUsedError;

  /// Serializes this CustomBlock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomBlockCopyWith<CustomBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomBlockCopyWith<$Res> {
  factory $CustomBlockCopyWith(
    CustomBlock value,
    $Res Function(CustomBlock) then,
  ) = _$CustomBlockCopyWithImpl<$Res, CustomBlock>;
  @useResult
  $Res call({int total, List<FinancialEntry> entries});
}

/// @nodoc
class _$CustomBlockCopyWithImpl<$Res, $Val extends CustomBlock>
    implements $CustomBlockCopyWith<$Res> {
  _$CustomBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? entries = null}) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<FinancialEntry>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomBlockImplCopyWith<$Res>
    implements $CustomBlockCopyWith<$Res> {
  factory _$$CustomBlockImplCopyWith(
    _$CustomBlockImpl value,
    $Res Function(_$CustomBlockImpl) then,
  ) = __$$CustomBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, List<FinancialEntry> entries});
}

/// @nodoc
class __$$CustomBlockImplCopyWithImpl<$Res>
    extends _$CustomBlockCopyWithImpl<$Res, _$CustomBlockImpl>
    implements _$$CustomBlockImplCopyWith<$Res> {
  __$$CustomBlockImplCopyWithImpl(
    _$CustomBlockImpl _value,
    $Res Function(_$CustomBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? total = null, Object? entries = null}) {
    return _then(
      _$CustomBlockImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<FinancialEntry>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomBlockImpl implements _CustomBlock {
  const _$CustomBlockImpl({
    this.total = 0,
    final List<FinancialEntry> entries = const <FinancialEntry>[],
  }) : _entries = entries;

  factory _$CustomBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomBlockImplFromJson(json);

  @override
  @JsonKey()
  final int total;
  final List<FinancialEntry> _entries;
  @override
  @JsonKey()
  List<FinancialEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  String toString() {
    return 'CustomBlock(total: $total, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomBlockImpl &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    const DeepCollectionEquality().hash(_entries),
  );

  /// Create a copy of CustomBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomBlockImplCopyWith<_$CustomBlockImpl> get copyWith =>
      __$$CustomBlockImplCopyWithImpl<_$CustomBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomBlockImplToJson(this);
  }
}

abstract class _CustomBlock implements CustomBlock {
  const factory _CustomBlock({
    final int total,
    final List<FinancialEntry> entries,
  }) = _$CustomBlockImpl;

  factory _CustomBlock.fromJson(Map<String, dynamic> json) =
      _$CustomBlockImpl.fromJson;

  @override
  int get total;
  @override
  List<FinancialEntry> get entries;

  /// Create a copy of CustomBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomBlockImplCopyWith<_$CustomBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialEntry _$FinancialEntryFromJson(Map<String, dynamic> json) {
  return _FinancialEntry.fromJson(json);
}

/// @nodoc
mixin _$FinancialEntry {
  int get id => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'recorded_by_name')
  String? get recordedByName => throw _privateConstructorUsedError;
  FinancialEntryCategory? get category => throw _privateConstructorUsedError;
  FinancialEntryStudent? get student => throw _privateConstructorUsedError;

  /// Serializes this FinancialEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialEntryCopyWith<FinancialEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialEntryCopyWith<$Res> {
  factory $FinancialEntryCopyWith(
    FinancialEntry value,
    $Res Function(FinancialEntry) then,
  ) = _$FinancialEntryCopyWithImpl<$Res, FinancialEntry>;
  @useResult
  $Res call({
    int id,
    int amount,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'recorded_by_name') String? recordedByName,
    FinancialEntryCategory? category,
    FinancialEntryStudent? student,
  });

  $FinancialEntryCategoryCopyWith<$Res>? get category;
  $FinancialEntryStudentCopyWith<$Res>? get student;
}

/// @nodoc
class _$FinancialEntryCopyWithImpl<$Res, $Val extends FinancialEntry>
    implements $FinancialEntryCopyWith<$Res> {
  _$FinancialEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? recordedByName = freezed,
    Object? category = freezed,
    Object? student = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recordedByName: freezed == recordedByName
                ? _value.recordedByName
                : recordedByName // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as FinancialEntryCategory?,
            student: freezed == student
                ? _value.student
                : student // ignore: cast_nullable_to_non_nullable
                      as FinancialEntryStudent?,
          )
          as $Val,
    );
  }

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialEntryCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $FinancialEntryCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FinancialEntryStudentCopyWith<$Res>? get student {
    if (_value.student == null) {
      return null;
    }

    return $FinancialEntryStudentCopyWith<$Res>(_value.student!, (value) {
      return _then(_value.copyWith(student: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FinancialEntryImplCopyWith<$Res>
    implements $FinancialEntryCopyWith<$Res> {
  factory _$$FinancialEntryImplCopyWith(
    _$FinancialEntryImpl value,
    $Res Function(_$FinancialEntryImpl) then,
  ) = __$$FinancialEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int amount,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'recorded_by_name') String? recordedByName,
    FinancialEntryCategory? category,
    FinancialEntryStudent? student,
  });

  @override
  $FinancialEntryCategoryCopyWith<$Res>? get category;
  @override
  $FinancialEntryStudentCopyWith<$Res>? get student;
}

/// @nodoc
class __$$FinancialEntryImplCopyWithImpl<$Res>
    extends _$FinancialEntryCopyWithImpl<$Res, _$FinancialEntryImpl>
    implements _$$FinancialEntryImplCopyWith<$Res> {
  __$$FinancialEntryImplCopyWithImpl(
    _$FinancialEntryImpl _value,
    $Res Function(_$FinancialEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? recordedByName = freezed,
    Object? category = freezed,
    Object? student = freezed,
  }) {
    return _then(
      _$FinancialEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recordedByName: freezed == recordedByName
            ? _value.recordedByName
            : recordedByName // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as FinancialEntryCategory?,
        student: freezed == student
            ? _value.student
            : student // ignore: cast_nullable_to_non_nullable
                  as FinancialEntryStudent?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialEntryImpl implements _FinancialEntry {
  const _$FinancialEntryImpl({
    required this.id,
    this.amount = 0,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'recorded_by_name') this.recordedByName,
    this.category,
    this.student,
  });

  factory _$FinancialEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialEntryImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final int amount;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'recorded_by_name')
  final String? recordedByName;
  @override
  final FinancialEntryCategory? category;
  @override
  final FinancialEntryStudent? student;

  @override
  String toString() {
    return 'FinancialEntry(id: $id, amount: $amount, notes: $notes, createdAt: $createdAt, recordedByName: $recordedByName, category: $category, student: $student)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recordedByName, recordedByName) ||
                other.recordedByName == recordedByName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.student, student) || other.student == student));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    amount,
    notes,
    createdAt,
    recordedByName,
    category,
    student,
  );

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialEntryImplCopyWith<_$FinancialEntryImpl> get copyWith =>
      __$$FinancialEntryImplCopyWithImpl<_$FinancialEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialEntryImplToJson(this);
  }
}

abstract class _FinancialEntry implements FinancialEntry {
  const factory _FinancialEntry({
    required final int id,
    final int amount,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'recorded_by_name') final String? recordedByName,
    final FinancialEntryCategory? category,
    final FinancialEntryStudent? student,
  }) = _$FinancialEntryImpl;

  factory _FinancialEntry.fromJson(Map<String, dynamic> json) =
      _$FinancialEntryImpl.fromJson;

  @override
  int get id;
  @override
  int get amount;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'recorded_by_name')
  String? get recordedByName;
  @override
  FinancialEntryCategory? get category;
  @override
  FinancialEntryStudent? get student;

  /// Create a copy of FinancialEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialEntryImplCopyWith<_$FinancialEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialEntryCategory _$FinancialEntryCategoryFromJson(
  Map<String, dynamic> json,
) {
  return _FinancialEntryCategory.fromJson(json);
}

/// @nodoc
mixin _$FinancialEntryCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_archived')
  bool get isArchived => throw _privateConstructorUsedError;

  /// Serializes this FinancialEntryCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialEntryCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialEntryCategoryCopyWith<FinancialEntryCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialEntryCategoryCopyWith<$Res> {
  factory $FinancialEntryCategoryCopyWith(
    FinancialEntryCategory value,
    $Res Function(FinancialEntryCategory) then,
  ) = _$FinancialEntryCategoryCopyWithImpl<$Res, FinancialEntryCategory>;
  @useResult
  $Res call({
    int id,
    String name,
    String? icon,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class _$FinancialEntryCategoryCopyWithImpl<
  $Res,
  $Val extends FinancialEntryCategory
>
    implements $FinancialEntryCategoryCopyWith<$Res> {
  _$FinancialEntryCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialEntryCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? isArchived = null,
  }) {
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
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialEntryCategoryImplCopyWith<$Res>
    implements $FinancialEntryCategoryCopyWith<$Res> {
  factory _$$FinancialEntryCategoryImplCopyWith(
    _$FinancialEntryCategoryImpl value,
    $Res Function(_$FinancialEntryCategoryImpl) then,
  ) = __$$FinancialEntryCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? icon,
    @JsonKey(name: 'is_archived') bool isArchived,
  });
}

/// @nodoc
class __$$FinancialEntryCategoryImplCopyWithImpl<$Res>
    extends
        _$FinancialEntryCategoryCopyWithImpl<$Res, _$FinancialEntryCategoryImpl>
    implements _$$FinancialEntryCategoryImplCopyWith<$Res> {
  __$$FinancialEntryCategoryImplCopyWithImpl(
    _$FinancialEntryCategoryImpl _value,
    $Res Function(_$FinancialEntryCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialEntryCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? isArchived = null,
  }) {
    return _then(
      _$FinancialEntryCategoryImpl(
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
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialEntryCategoryImpl implements _FinancialEntryCategory {
  const _$FinancialEntryCategoryImpl({
    required this.id,
    required this.name,
    this.icon,
    @JsonKey(name: 'is_archived') this.isArchived = false,
  });

  factory _$FinancialEntryCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialEntryCategoryImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;

  @override
  String toString() {
    return 'FinancialEntryCategory(id: $id, name: $name, icon: $icon, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialEntryCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon, isArchived);

  /// Create a copy of FinancialEntryCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialEntryCategoryImplCopyWith<_$FinancialEntryCategoryImpl>
  get copyWith =>
      __$$FinancialEntryCategoryImplCopyWithImpl<_$FinancialEntryCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialEntryCategoryImplToJson(this);
  }
}

abstract class _FinancialEntryCategory implements FinancialEntryCategory {
  const factory _FinancialEntryCategory({
    required final int id,
    required final String name,
    final String? icon,
    @JsonKey(name: 'is_archived') final bool isArchived,
  }) = _$FinancialEntryCategoryImpl;

  factory _FinancialEntryCategory.fromJson(Map<String, dynamic> json) =
      _$FinancialEntryCategoryImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'is_archived')
  bool get isArchived;

  /// Create a copy of FinancialEntryCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialEntryCategoryImplCopyWith<_$FinancialEntryCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FinancialEntryStudent _$FinancialEntryStudentFromJson(
  Map<String, dynamic> json,
) {
  return _FinancialEntryStudent.fromJson(json);
}

/// @nodoc
mixin _$FinancialEntryStudent {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;

  /// Serializes this FinancialEntryStudent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialEntryStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialEntryStudentCopyWith<FinancialEntryStudent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialEntryStudentCopyWith<$Res> {
  factory $FinancialEntryStudentCopyWith(
    FinancialEntryStudent value,
    $Res Function(FinancialEntryStudent) then,
  ) = _$FinancialEntryStudentCopyWithImpl<$Res, FinancialEntryStudent>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  });
}

/// @nodoc
class _$FinancialEntryStudentCopyWithImpl<
  $Res,
  $Val extends FinancialEntryStudent
>
    implements $FinancialEntryStudentCopyWith<$Res> {
  _$FinancialEntryStudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialEntryStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialEntryStudentImplCopyWith<$Res>
    implements $FinancialEntryStudentCopyWith<$Res> {
  factory _$$FinancialEntryStudentImplCopyWith(
    _$FinancialEntryStudentImpl value,
    $Res Function(_$FinancialEntryStudentImpl) then,
  ) = __$$FinancialEntryStudentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
  });
}

/// @nodoc
class __$$FinancialEntryStudentImplCopyWithImpl<$Res>
    extends
        _$FinancialEntryStudentCopyWithImpl<$Res, _$FinancialEntryStudentImpl>
    implements _$$FinancialEntryStudentImplCopyWith<$Res> {
  __$$FinancialEntryStudentImplCopyWithImpl(
    _$FinancialEntryStudentImpl _value,
    $Res Function(_$FinancialEntryStudentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialEntryStudent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(
      _$FinancialEntryStudentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialEntryStudentImpl implements _FinancialEntryStudent {
  const _$FinancialEntryStudentImpl({
    required this.id,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
  });

  factory _$FinancialEntryStudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialEntryStudentImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;

  @override
  String toString() {
    return 'FinancialEntryStudent(id: $id, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialEntryStudentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName);

  /// Create a copy of FinancialEntryStudent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialEntryStudentImplCopyWith<_$FinancialEntryStudentImpl>
  get copyWith =>
      __$$FinancialEntryStudentImplCopyWithImpl<_$FinancialEntryStudentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialEntryStudentImplToJson(this);
  }
}

abstract class _FinancialEntryStudent implements FinancialEntryStudent {
  const factory _FinancialEntryStudent({
    required final int id,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
  }) = _$FinancialEntryStudentImpl;

  factory _FinancialEntryStudent.fromJson(Map<String, dynamic> json) =
      _$FinancialEntryStudentImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;

  /// Create a copy of FinancialEntryStudent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialEntryStudentImplCopyWith<_$FinancialEntryStudentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

FinancialNet _$FinancialNetFromJson(Map<String, dynamic> json) {
  return _FinancialNet.fromJson(json);
}

/// @nodoc
mixin _$FinancialNet {
  int get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'margin_percent')
  int? get marginPercent => throw _privateConstructorUsedError;

  /// Serializes this FinancialNet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialNet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialNetCopyWith<FinancialNet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialNetCopyWith<$Res> {
  factory $FinancialNetCopyWith(
    FinancialNet value,
    $Res Function(FinancialNet) then,
  ) = _$FinancialNetCopyWithImpl<$Res, FinancialNet>;
  @useResult
  $Res call({int amount, @JsonKey(name: 'margin_percent') int? marginPercent});
}

/// @nodoc
class _$FinancialNetCopyWithImpl<$Res, $Val extends FinancialNet>
    implements $FinancialNetCopyWith<$Res> {
  _$FinancialNetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialNet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? marginPercent = freezed}) {
    return _then(
      _value.copyWith(
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            marginPercent: freezed == marginPercent
                ? _value.marginPercent
                : marginPercent // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialNetImplCopyWith<$Res>
    implements $FinancialNetCopyWith<$Res> {
  factory _$$FinancialNetImplCopyWith(
    _$FinancialNetImpl value,
    $Res Function(_$FinancialNetImpl) then,
  ) = __$$FinancialNetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int amount, @JsonKey(name: 'margin_percent') int? marginPercent});
}

/// @nodoc
class __$$FinancialNetImplCopyWithImpl<$Res>
    extends _$FinancialNetCopyWithImpl<$Res, _$FinancialNetImpl>
    implements _$$FinancialNetImplCopyWith<$Res> {
  __$$FinancialNetImplCopyWithImpl(
    _$FinancialNetImpl _value,
    $Res Function(_$FinancialNetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialNet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? amount = null, Object? marginPercent = freezed}) {
    return _then(
      _$FinancialNetImpl(
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        marginPercent: freezed == marginPercent
            ? _value.marginPercent
            : marginPercent // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialNetImpl implements _FinancialNet {
  const _$FinancialNetImpl({
    this.amount = 0,
    @JsonKey(name: 'margin_percent') this.marginPercent,
  });

  factory _$FinancialNetImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialNetImplFromJson(json);

  @override
  @JsonKey()
  final int amount;
  @override
  @JsonKey(name: 'margin_percent')
  final int? marginPercent;

  @override
  String toString() {
    return 'FinancialNet(amount: $amount, marginPercent: $marginPercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialNetImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.marginPercent, marginPercent) ||
                other.marginPercent == marginPercent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, amount, marginPercent);

  /// Create a copy of FinancialNet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialNetImplCopyWith<_$FinancialNetImpl> get copyWith =>
      __$$FinancialNetImplCopyWithImpl<_$FinancialNetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialNetImplToJson(this);
  }
}

abstract class _FinancialNet implements FinancialNet {
  const factory _FinancialNet({
    final int amount,
    @JsonKey(name: 'margin_percent') final int? marginPercent,
  }) = _$FinancialNetImpl;

  factory _FinancialNet.fromJson(Map<String, dynamic> json) =
      _$FinancialNetImpl.fromJson;

  @override
  int get amount;
  @override
  @JsonKey(name: 'margin_percent')
  int? get marginPercent;

  /// Create a copy of FinancialNet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialNetImplCopyWith<_$FinancialNetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
