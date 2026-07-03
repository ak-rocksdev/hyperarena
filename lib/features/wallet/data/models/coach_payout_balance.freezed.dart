// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_payout_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoachPayoutBalance _$CoachPayoutBalanceFromJson(Map<String, dynamic> json) {
  return _CoachPayoutBalance.fromJson(json);
}

/// @nodoc
mixin _$CoachPayoutBalance {
  @JsonKey(name: 'outstanding_cents')
  int get outstandingCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_cents')
  int get requestedCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_cents')
  int get approvedCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_cents')
  int get paidCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_session_count')
  int get outstandingSessionCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_periods')
  List<String> get outstandingPeriods => throw _privateConstructorUsedError;

  /// Serializes this CoachPayoutBalance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachPayoutBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachPayoutBalanceCopyWith<CoachPayoutBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachPayoutBalanceCopyWith<$Res> {
  factory $CoachPayoutBalanceCopyWith(
    CoachPayoutBalance value,
    $Res Function(CoachPayoutBalance) then,
  ) = _$CoachPayoutBalanceCopyWithImpl<$Res, CoachPayoutBalance>;
  @useResult
  $Res call({
    @JsonKey(name: 'outstanding_cents') int outstandingCents,
    @JsonKey(name: 'requested_cents') int requestedCents,
    @JsonKey(name: 'approved_cents') int approvedCents,
    @JsonKey(name: 'paid_cents') int paidCents,
    @JsonKey(name: 'outstanding_session_count') int outstandingSessionCount,
    @JsonKey(name: 'outstanding_periods') List<String> outstandingPeriods,
  });
}

/// @nodoc
class _$CoachPayoutBalanceCopyWithImpl<$Res, $Val extends CoachPayoutBalance>
    implements $CoachPayoutBalanceCopyWith<$Res> {
  _$CoachPayoutBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachPayoutBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? outstandingCents = null,
    Object? requestedCents = null,
    Object? approvedCents = null,
    Object? paidCents = null,
    Object? outstandingSessionCount = null,
    Object? outstandingPeriods = null,
  }) {
    return _then(
      _value.copyWith(
            outstandingCents: null == outstandingCents
                ? _value.outstandingCents
                : outstandingCents // ignore: cast_nullable_to_non_nullable
                      as int,
            requestedCents: null == requestedCents
                ? _value.requestedCents
                : requestedCents // ignore: cast_nullable_to_non_nullable
                      as int,
            approvedCents: null == approvedCents
                ? _value.approvedCents
                : approvedCents // ignore: cast_nullable_to_non_nullable
                      as int,
            paidCents: null == paidCents
                ? _value.paidCents
                : paidCents // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingSessionCount: null == outstandingSessionCount
                ? _value.outstandingSessionCount
                : outstandingSessionCount // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingPeriods: null == outstandingPeriods
                ? _value.outstandingPeriods
                : outstandingPeriods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachPayoutBalanceImplCopyWith<$Res>
    implements $CoachPayoutBalanceCopyWith<$Res> {
  factory _$$CoachPayoutBalanceImplCopyWith(
    _$CoachPayoutBalanceImpl value,
    $Res Function(_$CoachPayoutBalanceImpl) then,
  ) = __$$CoachPayoutBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'outstanding_cents') int outstandingCents,
    @JsonKey(name: 'requested_cents') int requestedCents,
    @JsonKey(name: 'approved_cents') int approvedCents,
    @JsonKey(name: 'paid_cents') int paidCents,
    @JsonKey(name: 'outstanding_session_count') int outstandingSessionCount,
    @JsonKey(name: 'outstanding_periods') List<String> outstandingPeriods,
  });
}

/// @nodoc
class __$$CoachPayoutBalanceImplCopyWithImpl<$Res>
    extends _$CoachPayoutBalanceCopyWithImpl<$Res, _$CoachPayoutBalanceImpl>
    implements _$$CoachPayoutBalanceImplCopyWith<$Res> {
  __$$CoachPayoutBalanceImplCopyWithImpl(
    _$CoachPayoutBalanceImpl _value,
    $Res Function(_$CoachPayoutBalanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachPayoutBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? outstandingCents = null,
    Object? requestedCents = null,
    Object? approvedCents = null,
    Object? paidCents = null,
    Object? outstandingSessionCount = null,
    Object? outstandingPeriods = null,
  }) {
    return _then(
      _$CoachPayoutBalanceImpl(
        outstandingCents: null == outstandingCents
            ? _value.outstandingCents
            : outstandingCents // ignore: cast_nullable_to_non_nullable
                  as int,
        requestedCents: null == requestedCents
            ? _value.requestedCents
            : requestedCents // ignore: cast_nullable_to_non_nullable
                  as int,
        approvedCents: null == approvedCents
            ? _value.approvedCents
            : approvedCents // ignore: cast_nullable_to_non_nullable
                  as int,
        paidCents: null == paidCents
            ? _value.paidCents
            : paidCents // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingSessionCount: null == outstandingSessionCount
            ? _value.outstandingSessionCount
            : outstandingSessionCount // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingPeriods: null == outstandingPeriods
            ? _value._outstandingPeriods
            : outstandingPeriods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachPayoutBalanceImpl extends _CoachPayoutBalance {
  const _$CoachPayoutBalanceImpl({
    @JsonKey(name: 'outstanding_cents') this.outstandingCents = 0,
    @JsonKey(name: 'requested_cents') this.requestedCents = 0,
    @JsonKey(name: 'approved_cents') this.approvedCents = 0,
    @JsonKey(name: 'paid_cents') this.paidCents = 0,
    @JsonKey(name: 'outstanding_session_count')
    this.outstandingSessionCount = 0,
    @JsonKey(name: 'outstanding_periods')
    final List<String> outstandingPeriods = const <String>[],
  }) : _outstandingPeriods = outstandingPeriods,
       super._();

  factory _$CoachPayoutBalanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachPayoutBalanceImplFromJson(json);

  @override
  @JsonKey(name: 'outstanding_cents')
  final int outstandingCents;
  @override
  @JsonKey(name: 'requested_cents')
  final int requestedCents;
  @override
  @JsonKey(name: 'approved_cents')
  final int approvedCents;
  @override
  @JsonKey(name: 'paid_cents')
  final int paidCents;
  @override
  @JsonKey(name: 'outstanding_session_count')
  final int outstandingSessionCount;
  final List<String> _outstandingPeriods;
  @override
  @JsonKey(name: 'outstanding_periods')
  List<String> get outstandingPeriods {
    if (_outstandingPeriods is EqualUnmodifiableListView)
      return _outstandingPeriods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_outstandingPeriods);
  }

  @override
  String toString() {
    return 'CoachPayoutBalance(outstandingCents: $outstandingCents, requestedCents: $requestedCents, approvedCents: $approvedCents, paidCents: $paidCents, outstandingSessionCount: $outstandingSessionCount, outstandingPeriods: $outstandingPeriods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachPayoutBalanceImpl &&
            (identical(other.outstandingCents, outstandingCents) ||
                other.outstandingCents == outstandingCents) &&
            (identical(other.requestedCents, requestedCents) ||
                other.requestedCents == requestedCents) &&
            (identical(other.approvedCents, approvedCents) ||
                other.approvedCents == approvedCents) &&
            (identical(other.paidCents, paidCents) ||
                other.paidCents == paidCents) &&
            (identical(
                  other.outstandingSessionCount,
                  outstandingSessionCount,
                ) ||
                other.outstandingSessionCount == outstandingSessionCount) &&
            const DeepCollectionEquality().equals(
              other._outstandingPeriods,
              _outstandingPeriods,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    outstandingCents,
    requestedCents,
    approvedCents,
    paidCents,
    outstandingSessionCount,
    const DeepCollectionEquality().hash(_outstandingPeriods),
  );

  /// Create a copy of CoachPayoutBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachPayoutBalanceImplCopyWith<_$CoachPayoutBalanceImpl> get copyWith =>
      __$$CoachPayoutBalanceImplCopyWithImpl<_$CoachPayoutBalanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachPayoutBalanceImplToJson(this);
  }
}

abstract class _CoachPayoutBalance extends CoachPayoutBalance {
  const factory _CoachPayoutBalance({
    @JsonKey(name: 'outstanding_cents') final int outstandingCents,
    @JsonKey(name: 'requested_cents') final int requestedCents,
    @JsonKey(name: 'approved_cents') final int approvedCents,
    @JsonKey(name: 'paid_cents') final int paidCents,
    @JsonKey(name: 'outstanding_session_count')
    final int outstandingSessionCount,
    @JsonKey(name: 'outstanding_periods') final List<String> outstandingPeriods,
  }) = _$CoachPayoutBalanceImpl;
  const _CoachPayoutBalance._() : super._();

  factory _CoachPayoutBalance.fromJson(Map<String, dynamic> json) =
      _$CoachPayoutBalanceImpl.fromJson;

  @override
  @JsonKey(name: 'outstanding_cents')
  int get outstandingCents;
  @override
  @JsonKey(name: 'requested_cents')
  int get requestedCents;
  @override
  @JsonKey(name: 'approved_cents')
  int get approvedCents;
  @override
  @JsonKey(name: 'paid_cents')
  int get paidCents;
  @override
  @JsonKey(name: 'outstanding_session_count')
  int get outstandingSessionCount;
  @override
  @JsonKey(name: 'outstanding_periods')
  List<String> get outstandingPeriods;

  /// Create a copy of CoachPayoutBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachPayoutBalanceImplCopyWith<_$CoachPayoutBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
