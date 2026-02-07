// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OwnerDashboardStats _$OwnerDashboardStatsFromJson(Map<String, dynamic> json) {
  return _OwnerDashboardStats.fromJson(json);
}

/// @nodoc
mixin _$OwnerDashboardStats {
  int get bookingsToday => throw _privateConstructorUsedError;
  int get pendingConfirmations => throw _privateConstructorUsedError;
  int get todayRevenue => throw _privateConstructorUsedError;
  int get monthlyRevenue => throw _privateConstructorUsedError;
  double get occupancyRate => throw _privateConstructorUsedError;

  /// Serializes this OwnerDashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OwnerDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OwnerDashboardStatsCopyWith<OwnerDashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OwnerDashboardStatsCopyWith<$Res> {
  factory $OwnerDashboardStatsCopyWith(
    OwnerDashboardStats value,
    $Res Function(OwnerDashboardStats) then,
  ) = _$OwnerDashboardStatsCopyWithImpl<$Res, OwnerDashboardStats>;
  @useResult
  $Res call({
    int bookingsToday,
    int pendingConfirmations,
    int todayRevenue,
    int monthlyRevenue,
    double occupancyRate,
  });
}

/// @nodoc
class _$OwnerDashboardStatsCopyWithImpl<$Res, $Val extends OwnerDashboardStats>
    implements $OwnerDashboardStatsCopyWith<$Res> {
  _$OwnerDashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OwnerDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingsToday = null,
    Object? pendingConfirmations = null,
    Object? todayRevenue = null,
    Object? monthlyRevenue = null,
    Object? occupancyRate = null,
  }) {
    return _then(
      _value.copyWith(
            bookingsToday: null == bookingsToday
                ? _value.bookingsToday
                : bookingsToday // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingConfirmations: null == pendingConfirmations
                ? _value.pendingConfirmations
                : pendingConfirmations // ignore: cast_nullable_to_non_nullable
                      as int,
            todayRevenue: null == todayRevenue
                ? _value.todayRevenue
                : todayRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            monthlyRevenue: null == monthlyRevenue
                ? _value.monthlyRevenue
                : monthlyRevenue // ignore: cast_nullable_to_non_nullable
                      as int,
            occupancyRate: null == occupancyRate
                ? _value.occupancyRate
                : occupancyRate // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OwnerDashboardStatsImplCopyWith<$Res>
    implements $OwnerDashboardStatsCopyWith<$Res> {
  factory _$$OwnerDashboardStatsImplCopyWith(
    _$OwnerDashboardStatsImpl value,
    $Res Function(_$OwnerDashboardStatsImpl) then,
  ) = __$$OwnerDashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int bookingsToday,
    int pendingConfirmations,
    int todayRevenue,
    int monthlyRevenue,
    double occupancyRate,
  });
}

/// @nodoc
class __$$OwnerDashboardStatsImplCopyWithImpl<$Res>
    extends _$OwnerDashboardStatsCopyWithImpl<$Res, _$OwnerDashboardStatsImpl>
    implements _$$OwnerDashboardStatsImplCopyWith<$Res> {
  __$$OwnerDashboardStatsImplCopyWithImpl(
    _$OwnerDashboardStatsImpl _value,
    $Res Function(_$OwnerDashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OwnerDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingsToday = null,
    Object? pendingConfirmations = null,
    Object? todayRevenue = null,
    Object? monthlyRevenue = null,
    Object? occupancyRate = null,
  }) {
    return _then(
      _$OwnerDashboardStatsImpl(
        bookingsToday: null == bookingsToday
            ? _value.bookingsToday
            : bookingsToday // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingConfirmations: null == pendingConfirmations
            ? _value.pendingConfirmations
            : pendingConfirmations // ignore: cast_nullable_to_non_nullable
                  as int,
        todayRevenue: null == todayRevenue
            ? _value.todayRevenue
            : todayRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        monthlyRevenue: null == monthlyRevenue
            ? _value.monthlyRevenue
            : monthlyRevenue // ignore: cast_nullable_to_non_nullable
                  as int,
        occupancyRate: null == occupancyRate
            ? _value.occupancyRate
            : occupancyRate // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OwnerDashboardStatsImpl implements _OwnerDashboardStats {
  const _$OwnerDashboardStatsImpl({
    this.bookingsToday = 0,
    this.pendingConfirmations = 0,
    this.todayRevenue = 0,
    this.monthlyRevenue = 0,
    this.occupancyRate = 0.0,
  });

  factory _$OwnerDashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OwnerDashboardStatsImplFromJson(json);

  @override
  @JsonKey()
  final int bookingsToday;
  @override
  @JsonKey()
  final int pendingConfirmations;
  @override
  @JsonKey()
  final int todayRevenue;
  @override
  @JsonKey()
  final int monthlyRevenue;
  @override
  @JsonKey()
  final double occupancyRate;

  @override
  String toString() {
    return 'OwnerDashboardStats(bookingsToday: $bookingsToday, pendingConfirmations: $pendingConfirmations, todayRevenue: $todayRevenue, monthlyRevenue: $monthlyRevenue, occupancyRate: $occupancyRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OwnerDashboardStatsImpl &&
            (identical(other.bookingsToday, bookingsToday) ||
                other.bookingsToday == bookingsToday) &&
            (identical(other.pendingConfirmations, pendingConfirmations) ||
                other.pendingConfirmations == pendingConfirmations) &&
            (identical(other.todayRevenue, todayRevenue) ||
                other.todayRevenue == todayRevenue) &&
            (identical(other.monthlyRevenue, monthlyRevenue) ||
                other.monthlyRevenue == monthlyRevenue) &&
            (identical(other.occupancyRate, occupancyRate) ||
                other.occupancyRate == occupancyRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bookingsToday,
    pendingConfirmations,
    todayRevenue,
    monthlyRevenue,
    occupancyRate,
  );

  /// Create a copy of OwnerDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OwnerDashboardStatsImplCopyWith<_$OwnerDashboardStatsImpl> get copyWith =>
      __$$OwnerDashboardStatsImplCopyWithImpl<_$OwnerDashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OwnerDashboardStatsImplToJson(this);
  }
}

abstract class _OwnerDashboardStats implements OwnerDashboardStats {
  const factory _OwnerDashboardStats({
    final int bookingsToday,
    final int pendingConfirmations,
    final int todayRevenue,
    final int monthlyRevenue,
    final double occupancyRate,
  }) = _$OwnerDashboardStatsImpl;

  factory _OwnerDashboardStats.fromJson(Map<String, dynamic> json) =
      _$OwnerDashboardStatsImpl.fromJson;

  @override
  int get bookingsToday;
  @override
  int get pendingConfirmations;
  @override
  int get todayRevenue;
  @override
  int get monthlyRevenue;
  @override
  double get occupancyRate;

  /// Create a copy of OwnerDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OwnerDashboardStatsImplCopyWith<_$OwnerDashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
