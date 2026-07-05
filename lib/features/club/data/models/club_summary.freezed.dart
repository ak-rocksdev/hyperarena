// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClubSummary _$ClubSummaryFromJson(Map<String, dynamic> json) {
  return _ClubSummary.fromJson(json);
}

/// @nodoc
mixin _$ClubSummary {
  ClubTenant get tenant => throw _privateConstructorUsedError;
  ClubStats get stats => throw _privateConstructorUsedError;

  /// Serializes this ClubSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubSummaryCopyWith<ClubSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubSummaryCopyWith<$Res> {
  factory $ClubSummaryCopyWith(
    ClubSummary value,
    $Res Function(ClubSummary) then,
  ) = _$ClubSummaryCopyWithImpl<$Res, ClubSummary>;
  @useResult
  $Res call({ClubTenant tenant, ClubStats stats});

  $ClubTenantCopyWith<$Res> get tenant;
  $ClubStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$ClubSummaryCopyWithImpl<$Res, $Val extends ClubSummary>
    implements $ClubSummaryCopyWith<$Res> {
  _$ClubSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tenant = null, Object? stats = null}) {
    return _then(
      _value.copyWith(
            tenant: null == tenant
                ? _value.tenant
                : tenant // ignore: cast_nullable_to_non_nullable
                      as ClubTenant,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as ClubStats,
          )
          as $Val,
    );
  }

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubTenantCopyWith<$Res> get tenant {
    return $ClubTenantCopyWith<$Res>(_value.tenant, (value) {
      return _then(_value.copyWith(tenant: value) as $Val);
    });
  }

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClubStatsCopyWith<$Res> get stats {
    return $ClubStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ClubSummaryImplCopyWith<$Res>
    implements $ClubSummaryCopyWith<$Res> {
  factory _$$ClubSummaryImplCopyWith(
    _$ClubSummaryImpl value,
    $Res Function(_$ClubSummaryImpl) then,
  ) = __$$ClubSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ClubTenant tenant, ClubStats stats});

  @override
  $ClubTenantCopyWith<$Res> get tenant;
  @override
  $ClubStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$ClubSummaryImplCopyWithImpl<$Res>
    extends _$ClubSummaryCopyWithImpl<$Res, _$ClubSummaryImpl>
    implements _$$ClubSummaryImplCopyWith<$Res> {
  __$$ClubSummaryImplCopyWithImpl(
    _$ClubSummaryImpl _value,
    $Res Function(_$ClubSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tenant = null, Object? stats = null}) {
    return _then(
      _$ClubSummaryImpl(
        tenant: null == tenant
            ? _value.tenant
            : tenant // ignore: cast_nullable_to_non_nullable
                  as ClubTenant,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as ClubStats,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubSummaryImpl implements _ClubSummary {
  const _$ClubSummaryImpl({required this.tenant, required this.stats});

  factory _$ClubSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubSummaryImplFromJson(json);

  @override
  final ClubTenant tenant;
  @override
  final ClubStats stats;

  @override
  String toString() {
    return 'ClubSummary(tenant: $tenant, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubSummaryImpl &&
            (identical(other.tenant, tenant) || other.tenant == tenant) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tenant, stats);

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubSummaryImplCopyWith<_$ClubSummaryImpl> get copyWith =>
      __$$ClubSummaryImplCopyWithImpl<_$ClubSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubSummaryImplToJson(this);
  }
}

abstract class _ClubSummary implements ClubSummary {
  const factory _ClubSummary({
    required final ClubTenant tenant,
    required final ClubStats stats,
  }) = _$ClubSummaryImpl;

  factory _ClubSummary.fromJson(Map<String, dynamic> json) =
      _$ClubSummaryImpl.fromJson;

  @override
  ClubTenant get tenant;
  @override
  ClubStats get stats;

  /// Create a copy of ClubSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubSummaryImplCopyWith<_$ClubSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubTenant _$ClubTenantFromJson(Map<String, dynamic> json) {
  return _ClubTenant.fromJson(json);
}

/// @nodoc
mixin _$ClubTenant {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'sport_name')
  String? get sportName => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_color')
  String? get brandColor => throw _privateConstructorUsedError;

  /// Serializes this ClubTenant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubTenantCopyWith<ClubTenant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubTenantCopyWith<$Res> {
  factory $ClubTenantCopyWith(
    ClubTenant value,
    $Res Function(ClubTenant) then,
  ) = _$ClubTenantCopyWithImpl<$Res, ClubTenant>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String slug,
    @JsonKey(name: 'sport_name') String? sportName,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
    String? city,
    @JsonKey(name: 'brand_color') String? brandColor,
  });
}

/// @nodoc
class _$ClubTenantCopyWithImpl<$Res, $Val extends ClubTenant>
    implements $ClubTenantCopyWith<$Res> {
  _$ClubTenantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? sportName = freezed,
    Object? logoUrls = freezed,
    Object? city = freezed,
    Object? brandColor = freezed,
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
            slug: null == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String,
            sportName: freezed == sportName
                ? _value.sportName
                : sportName // ignore: cast_nullable_to_non_nullable
                      as String?,
            logoUrls: freezed == logoUrls
                ? _value.logoUrls
                : logoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            brandColor: freezed == brandColor
                ? _value.brandColor
                : brandColor // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClubTenantImplCopyWith<$Res>
    implements $ClubTenantCopyWith<$Res> {
  factory _$$ClubTenantImplCopyWith(
    _$ClubTenantImpl value,
    $Res Function(_$ClubTenantImpl) then,
  ) = __$$ClubTenantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String slug,
    @JsonKey(name: 'sport_name') String? sportName,
    @JsonKey(name: 'logo_urls') Map<String, String>? logoUrls,
    String? city,
    @JsonKey(name: 'brand_color') String? brandColor,
  });
}

/// @nodoc
class __$$ClubTenantImplCopyWithImpl<$Res>
    extends _$ClubTenantCopyWithImpl<$Res, _$ClubTenantImpl>
    implements _$$ClubTenantImplCopyWith<$Res> {
  __$$ClubTenantImplCopyWithImpl(
    _$ClubTenantImpl _value,
    $Res Function(_$ClubTenantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClubTenant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? sportName = freezed,
    Object? logoUrls = freezed,
    Object? city = freezed,
    Object? brandColor = freezed,
  }) {
    return _then(
      _$ClubTenantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        slug: null == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String,
        sportName: freezed == sportName
            ? _value.sportName
            : sportName // ignore: cast_nullable_to_non_nullable
                  as String?,
        logoUrls: freezed == logoUrls
            ? _value._logoUrls
            : logoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        brandColor: freezed == brandColor
            ? _value.brandColor
            : brandColor // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubTenantImpl implements _ClubTenant {
  const _$ClubTenantImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    required this.slug,
    @JsonKey(name: 'sport_name') this.sportName,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
    this.city,
    @JsonKey(name: 'brand_color') this.brandColor,
  }) : _logoUrls = logoUrls;

  factory _$ClubTenantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubTenantImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  @JsonKey(name: 'sport_name')
  final String? sportName;
  final Map<String, String>? _logoUrls;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls {
    final value = _logoUrls;
    if (value == null) return null;
    if (_logoUrls is EqualUnmodifiableMapView) return _logoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? city;
  @override
  @JsonKey(name: 'brand_color')
  final String? brandColor;

  @override
  String toString() {
    return 'ClubTenant(id: $id, name: $name, slug: $slug, sportName: $sportName, logoUrls: $logoUrls, city: $city, brandColor: $brandColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubTenantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.sportName, sportName) ||
                other.sportName == sportName) &&
            const DeepCollectionEquality().equals(other._logoUrls, _logoUrls) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.brandColor, brandColor) ||
                other.brandColor == brandColor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    slug,
    sportName,
    const DeepCollectionEquality().hash(_logoUrls),
    city,
    brandColor,
  );

  /// Create a copy of ClubTenant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubTenantImplCopyWith<_$ClubTenantImpl> get copyWith =>
      __$$ClubTenantImplCopyWithImpl<_$ClubTenantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubTenantImplToJson(this);
  }
}

abstract class _ClubTenant implements ClubTenant {
  const factory _ClubTenant({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    required final String slug,
    @JsonKey(name: 'sport_name') final String? sportName,
    @JsonKey(name: 'logo_urls') final Map<String, String>? logoUrls,
    final String? city,
    @JsonKey(name: 'brand_color') final String? brandColor,
  }) = _$ClubTenantImpl;

  factory _ClubTenant.fromJson(Map<String, dynamic> json) =
      _$ClubTenantImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(name: 'sport_name')
  String? get sportName;
  @override
  @JsonKey(name: 'logo_urls')
  Map<String, String>? get logoUrls;
  @override
  String? get city;
  @override
  @JsonKey(name: 'brand_color')
  String? get brandColor;

  /// Create a copy of ClubTenant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubTenantImplCopyWith<_$ClubTenantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClubStats _$ClubStatsFromJson(Map<String, dynamic> json) {
  return _ClubStats.fromJson(json);
}

/// @nodoc
mixin _$ClubStats {
  @JsonKey(name: 'total_members_count')
  int get totalMembersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_members_count')
  int get activeMembersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_coaches_count')
  int get activeCoachesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sessions_this_month')
  int get sessionsThisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_total')
  int get outstandingTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount => throw _privateConstructorUsedError;

  /// Serializes this ClubStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClubStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubStatsCopyWith<ClubStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubStatsCopyWith<$Res> {
  factory $ClubStatsCopyWith(ClubStats value, $Res Function(ClubStats) then) =
      _$ClubStatsCopyWithImpl<$Res, ClubStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_members_count') int totalMembersCount,
    @JsonKey(name: 'active_members_count') int activeMembersCount,
    @JsonKey(name: 'active_coaches_count') int activeCoachesCount,
    @JsonKey(name: 'sessions_this_month') int sessionsThisMonth,
    @JsonKey(name: 'outstanding_total') int outstandingTotal,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
  });
}

/// @nodoc
class _$ClubStatsCopyWithImpl<$Res, $Val extends ClubStats>
    implements $ClubStatsCopyWith<$Res> {
  _$ClubStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClubStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembersCount = null,
    Object? activeMembersCount = null,
    Object? activeCoachesCount = null,
    Object? sessionsThisMonth = null,
    Object? outstandingTotal = null,
    Object? outstandingCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalMembersCount: null == totalMembersCount
                ? _value.totalMembersCount
                : totalMembersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            activeMembersCount: null == activeMembersCount
                ? _value.activeMembersCount
                : activeMembersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            activeCoachesCount: null == activeCoachesCount
                ? _value.activeCoachesCount
                : activeCoachesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsThisMonth: null == sessionsThisMonth
                ? _value.sessionsThisMonth
                : sessionsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingTotal: null == outstandingTotal
                ? _value.outstandingTotal
                : outstandingTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            outstandingCount: null == outstandingCount
                ? _value.outstandingCount
                : outstandingCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClubStatsImplCopyWith<$Res>
    implements $ClubStatsCopyWith<$Res> {
  factory _$$ClubStatsImplCopyWith(
    _$ClubStatsImpl value,
    $Res Function(_$ClubStatsImpl) then,
  ) = __$$ClubStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_members_count') int totalMembersCount,
    @JsonKey(name: 'active_members_count') int activeMembersCount,
    @JsonKey(name: 'active_coaches_count') int activeCoachesCount,
    @JsonKey(name: 'sessions_this_month') int sessionsThisMonth,
    @JsonKey(name: 'outstanding_total') int outstandingTotal,
    @JsonKey(name: 'outstanding_count') int outstandingCount,
  });
}

/// @nodoc
class __$$ClubStatsImplCopyWithImpl<$Res>
    extends _$ClubStatsCopyWithImpl<$Res, _$ClubStatsImpl>
    implements _$$ClubStatsImplCopyWith<$Res> {
  __$$ClubStatsImplCopyWithImpl(
    _$ClubStatsImpl _value,
    $Res Function(_$ClubStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClubStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembersCount = null,
    Object? activeMembersCount = null,
    Object? activeCoachesCount = null,
    Object? sessionsThisMonth = null,
    Object? outstandingTotal = null,
    Object? outstandingCount = null,
  }) {
    return _then(
      _$ClubStatsImpl(
        totalMembersCount: null == totalMembersCount
            ? _value.totalMembersCount
            : totalMembersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        activeMembersCount: null == activeMembersCount
            ? _value.activeMembersCount
            : activeMembersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        activeCoachesCount: null == activeCoachesCount
            ? _value.activeCoachesCount
            : activeCoachesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsThisMonth: null == sessionsThisMonth
            ? _value.sessionsThisMonth
            : sessionsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingTotal: null == outstandingTotal
            ? _value.outstandingTotal
            : outstandingTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        outstandingCount: null == outstandingCount
            ? _value.outstandingCount
            : outstandingCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClubStatsImpl implements _ClubStats {
  const _$ClubStatsImpl({
    @JsonKey(name: 'total_members_count') this.totalMembersCount = 0,
    @JsonKey(name: 'active_members_count') this.activeMembersCount = 0,
    @JsonKey(name: 'active_coaches_count') this.activeCoachesCount = 0,
    @JsonKey(name: 'sessions_this_month') this.sessionsThisMonth = 0,
    @JsonKey(name: 'outstanding_total') this.outstandingTotal = 0,
    @JsonKey(name: 'outstanding_count') this.outstandingCount = 0,
  });

  factory _$ClubStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_members_count')
  final int totalMembersCount;
  @override
  @JsonKey(name: 'active_members_count')
  final int activeMembersCount;
  @override
  @JsonKey(name: 'active_coaches_count')
  final int activeCoachesCount;
  @override
  @JsonKey(name: 'sessions_this_month')
  final int sessionsThisMonth;
  @override
  @JsonKey(name: 'outstanding_total')
  final int outstandingTotal;
  @override
  @JsonKey(name: 'outstanding_count')
  final int outstandingCount;

  @override
  String toString() {
    return 'ClubStats(totalMembersCount: $totalMembersCount, activeMembersCount: $activeMembersCount, activeCoachesCount: $activeCoachesCount, sessionsThisMonth: $sessionsThisMonth, outstandingTotal: $outstandingTotal, outstandingCount: $outstandingCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubStatsImpl &&
            (identical(other.totalMembersCount, totalMembersCount) ||
                other.totalMembersCount == totalMembersCount) &&
            (identical(other.activeMembersCount, activeMembersCount) ||
                other.activeMembersCount == activeMembersCount) &&
            (identical(other.activeCoachesCount, activeCoachesCount) ||
                other.activeCoachesCount == activeCoachesCount) &&
            (identical(other.sessionsThisMonth, sessionsThisMonth) ||
                other.sessionsThisMonth == sessionsThisMonth) &&
            (identical(other.outstandingTotal, outstandingTotal) ||
                other.outstandingTotal == outstandingTotal) &&
            (identical(other.outstandingCount, outstandingCount) ||
                other.outstandingCount == outstandingCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalMembersCount,
    activeMembersCount,
    activeCoachesCount,
    sessionsThisMonth,
    outstandingTotal,
    outstandingCount,
  );

  /// Create a copy of ClubStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubStatsImplCopyWith<_$ClubStatsImpl> get copyWith =>
      __$$ClubStatsImplCopyWithImpl<_$ClubStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubStatsImplToJson(this);
  }
}

abstract class _ClubStats implements ClubStats {
  const factory _ClubStats({
    @JsonKey(name: 'total_members_count') final int totalMembersCount,
    @JsonKey(name: 'active_members_count') final int activeMembersCount,
    @JsonKey(name: 'active_coaches_count') final int activeCoachesCount,
    @JsonKey(name: 'sessions_this_month') final int sessionsThisMonth,
    @JsonKey(name: 'outstanding_total') final int outstandingTotal,
    @JsonKey(name: 'outstanding_count') final int outstandingCount,
  }) = _$ClubStatsImpl;

  factory _ClubStats.fromJson(Map<String, dynamic> json) =
      _$ClubStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_members_count')
  int get totalMembersCount;
  @override
  @JsonKey(name: 'active_members_count')
  int get activeMembersCount;
  @override
  @JsonKey(name: 'active_coaches_count')
  int get activeCoachesCount;
  @override
  @JsonKey(name: 'sessions_this_month')
  int get sessionsThisMonth;
  @override
  @JsonKey(name: 'outstanding_total')
  int get outstandingTotal;
  @override
  @JsonKey(name: 'outstanding_count')
  int get outstandingCount;

  /// Create a copy of ClubStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubStatsImplCopyWith<_$ClubStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
