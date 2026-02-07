// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerProfile _$PlayerProfileFromJson(Map<String, dynamic> json) {
  return _PlayerProfile.fromJson(json);
}

/// @nodoc
mixin _$PlayerProfile {
  String get userId => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  List<Sport> get sports => throw _privateConstructorUsedError;
  Map<String, String> get selfAssessedLevels =>
      throw _privateConstructorUsedError;
  int get totalXp => throw _privateConstructorUsedError;
  LevelTier get levelTier => throw _privateConstructorUsedError;
  int get profileCompletionPct => throw _privateConstructorUsedError;

  /// Serializes this PlayerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerProfileCopyWith<PlayerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerProfileCopyWith<$Res> {
  factory $PlayerProfileCopyWith(
    PlayerProfile value,
    $Res Function(PlayerProfile) then,
  ) = _$PlayerProfileCopyWithImpl<$Res, PlayerProfile>;
  @useResult
  $Res call({
    String userId,
    String? bio,
    String city,
    List<Sport> sports,
    Map<String, String> selfAssessedLevels,
    int totalXp,
    LevelTier levelTier,
    int profileCompletionPct,
  });
}

/// @nodoc
class _$PlayerProfileCopyWithImpl<$Res, $Val extends PlayerProfile>
    implements $PlayerProfileCopyWith<$Res> {
  _$PlayerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? bio = freezed,
    Object? city = null,
    Object? sports = null,
    Object? selfAssessedLevels = null,
    Object? totalXp = null,
    Object? levelTier = null,
    Object? profileCompletionPct = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            sports: null == sports
                ? _value.sports
                : sports // ignore: cast_nullable_to_non_nullable
                      as List<Sport>,
            selfAssessedLevels: null == selfAssessedLevels
                ? _value.selfAssessedLevels
                : selfAssessedLevels // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            levelTier: null == levelTier
                ? _value.levelTier
                : levelTier // ignore: cast_nullable_to_non_nullable
                      as LevelTier,
            profileCompletionPct: null == profileCompletionPct
                ? _value.profileCompletionPct
                : profileCompletionPct // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerProfileImplCopyWith<$Res>
    implements $PlayerProfileCopyWith<$Res> {
  factory _$$PlayerProfileImplCopyWith(
    _$PlayerProfileImpl value,
    $Res Function(_$PlayerProfileImpl) then,
  ) = __$$PlayerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String? bio,
    String city,
    List<Sport> sports,
    Map<String, String> selfAssessedLevels,
    int totalXp,
    LevelTier levelTier,
    int profileCompletionPct,
  });
}

/// @nodoc
class __$$PlayerProfileImplCopyWithImpl<$Res>
    extends _$PlayerProfileCopyWithImpl<$Res, _$PlayerProfileImpl>
    implements _$$PlayerProfileImplCopyWith<$Res> {
  __$$PlayerProfileImplCopyWithImpl(
    _$PlayerProfileImpl _value,
    $Res Function(_$PlayerProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? bio = freezed,
    Object? city = null,
    Object? sports = null,
    Object? selfAssessedLevels = null,
    Object? totalXp = null,
    Object? levelTier = null,
    Object? profileCompletionPct = null,
  }) {
    return _then(
      _$PlayerProfileImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        sports: null == sports
            ? _value._sports
            : sports // ignore: cast_nullable_to_non_nullable
                  as List<Sport>,
        selfAssessedLevels: null == selfAssessedLevels
            ? _value._selfAssessedLevels
            : selfAssessedLevels // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        levelTier: null == levelTier
            ? _value.levelTier
            : levelTier // ignore: cast_nullable_to_non_nullable
                  as LevelTier,
        profileCompletionPct: null == profileCompletionPct
            ? _value.profileCompletionPct
            : profileCompletionPct // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerProfileImpl implements _PlayerProfile {
  const _$PlayerProfileImpl({
    required this.userId,
    this.bio,
    required this.city,
    final List<Sport> sports = const [],
    final Map<String, String> selfAssessedLevels = const {},
    this.totalXp = 0,
    this.levelTier = LevelTier.rookie,
    this.profileCompletionPct = 0,
  }) : _sports = sports,
       _selfAssessedLevels = selfAssessedLevels;

  factory _$PlayerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String? bio;
  @override
  final String city;
  final List<Sport> _sports;
  @override
  @JsonKey()
  List<Sport> get sports {
    if (_sports is EqualUnmodifiableListView) return _sports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sports);
  }

  final Map<String, String> _selfAssessedLevels;
  @override
  @JsonKey()
  Map<String, String> get selfAssessedLevels {
    if (_selfAssessedLevels is EqualUnmodifiableMapView)
      return _selfAssessedLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_selfAssessedLevels);
  }

  @override
  @JsonKey()
  final int totalXp;
  @override
  @JsonKey()
  final LevelTier levelTier;
  @override
  @JsonKey()
  final int profileCompletionPct;

  @override
  String toString() {
    return 'PlayerProfile(userId: $userId, bio: $bio, city: $city, sports: $sports, selfAssessedLevels: $selfAssessedLevels, totalXp: $totalXp, levelTier: $levelTier, profileCompletionPct: $profileCompletionPct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.city, city) || other.city == city) &&
            const DeepCollectionEquality().equals(other._sports, _sports) &&
            const DeepCollectionEquality().equals(
              other._selfAssessedLevels,
              _selfAssessedLevels,
            ) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.levelTier, levelTier) ||
                other.levelTier == levelTier) &&
            (identical(other.profileCompletionPct, profileCompletionPct) ||
                other.profileCompletionPct == profileCompletionPct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    bio,
    city,
    const DeepCollectionEquality().hash(_sports),
    const DeepCollectionEquality().hash(_selfAssessedLevels),
    totalXp,
    levelTier,
    profileCompletionPct,
  );

  /// Create a copy of PlayerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerProfileImplCopyWith<_$PlayerProfileImpl> get copyWith =>
      __$$PlayerProfileImplCopyWithImpl<_$PlayerProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerProfileImplToJson(this);
  }
}

abstract class _PlayerProfile implements PlayerProfile {
  const factory _PlayerProfile({
    required final String userId,
    final String? bio,
    required final String city,
    final List<Sport> sports,
    final Map<String, String> selfAssessedLevels,
    final int totalXp,
    final LevelTier levelTier,
    final int profileCompletionPct,
  }) = _$PlayerProfileImpl;

  factory _PlayerProfile.fromJson(Map<String, dynamic> json) =
      _$PlayerProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String? get bio;
  @override
  String get city;
  @override
  List<Sport> get sports;
  @override
  Map<String, String> get selfAssessedLevels;
  @override
  int get totalXp;
  @override
  LevelTier get levelTier;
  @override
  int get profileCompletionPct;

  /// Create a copy of PlayerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerProfileImplCopyWith<_$PlayerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
