// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Coach _$CoachFromJson(Map<String, dynamic> json) {
  return _Coach.fromJson(json);
}

/// @nodoc
mixin _$Coach {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  List<Sport> get sports => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  int get hourlyRate => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  LevelTier get level => throw _privateConstructorUsedError;
  int get totalStudents => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;

  /// Serializes this Coach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachCopyWith<Coach> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachCopyWith<$Res> {
  factory $CoachCopyWith(Coach value, $Res Function(Coach) then) =
      _$CoachCopyWithImpl<$Res, Coach>;
  @useResult
  $Res call({
    String id,
    String name,
    String bio,
    String? avatarUrl,
    List<Sport> sports,
    double rating,
    int totalReviews,
    int hourlyRate,
    String city,
    bool isVerified,
    LevelTier level,
    int totalStudents,
    List<String> certifications,
  });
}

/// @nodoc
class _$CoachCopyWithImpl<$Res, $Val extends Coach>
    implements $CoachCopyWith<$Res> {
  _$CoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? bio = null,
    Object? avatarUrl = freezed,
    Object? sports = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? hourlyRate = null,
    Object? city = null,
    Object? isVerified = null,
    Object? level = null,
    Object? totalStudents = null,
    Object? certifications = null,
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
            bio: null == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            sports: null == sports
                ? _value.sports
                : sports // ignore: cast_nullable_to_non_nullable
                      as List<Sport>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            hourlyRate: null == hourlyRate
                ? _value.hourlyRate
                : hourlyRate // ignore: cast_nullable_to_non_nullable
                      as int,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as LevelTier,
            totalStudents: null == totalStudents
                ? _value.totalStudents
                : totalStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            certifications: null == certifications
                ? _value.certifications
                : certifications // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachImplCopyWith<$Res> implements $CoachCopyWith<$Res> {
  factory _$$CoachImplCopyWith(
    _$CoachImpl value,
    $Res Function(_$CoachImpl) then,
  ) = __$$CoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String bio,
    String? avatarUrl,
    List<Sport> sports,
    double rating,
    int totalReviews,
    int hourlyRate,
    String city,
    bool isVerified,
    LevelTier level,
    int totalStudents,
    List<String> certifications,
  });
}

/// @nodoc
class __$$CoachImplCopyWithImpl<$Res>
    extends _$CoachCopyWithImpl<$Res, _$CoachImpl>
    implements _$$CoachImplCopyWith<$Res> {
  __$$CoachImplCopyWithImpl(
    _$CoachImpl _value,
    $Res Function(_$CoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? bio = null,
    Object? avatarUrl = freezed,
    Object? sports = null,
    Object? rating = null,
    Object? totalReviews = null,
    Object? hourlyRate = null,
    Object? city = null,
    Object? isVerified = null,
    Object? level = null,
    Object? totalStudents = null,
    Object? certifications = null,
  }) {
    return _then(
      _$CoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: null == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        sports: null == sports
            ? _value._sports
            : sports // ignore: cast_nullable_to_non_nullable
                  as List<Sport>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        hourlyRate: null == hourlyRate
            ? _value.hourlyRate
            : hourlyRate // ignore: cast_nullable_to_non_nullable
                  as int,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as LevelTier,
        totalStudents: null == totalStudents
            ? _value.totalStudents
            : totalStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        certifications: null == certifications
            ? _value._certifications
            : certifications // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachImpl implements _Coach {
  const _$CoachImpl({
    required this.id,
    required this.name,
    required this.bio,
    this.avatarUrl,
    final List<Sport> sports = const [],
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.hourlyRate,
    required this.city,
    this.isVerified = false,
    this.level = LevelTier.amateur,
    this.totalStudents = 0,
    final List<String> certifications = const [],
  }) : _sports = sports,
       _certifications = certifications;

  factory _$CoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String bio;
  @override
  final String? avatarUrl;
  final List<Sport> _sports;
  @override
  @JsonKey()
  List<Sport> get sports {
    if (_sports is EqualUnmodifiableListView) return _sports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sports);
  }

  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalReviews;
  @override
  final int hourlyRate;
  @override
  final String city;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final LevelTier level;
  @override
  @JsonKey()
  final int totalStudents;
  final List<String> _certifications;
  @override
  @JsonKey()
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  @override
  String toString() {
    return 'Coach(id: $id, name: $name, bio: $bio, avatarUrl: $avatarUrl, sports: $sports, rating: $rating, totalReviews: $totalReviews, hourlyRate: $hourlyRate, city: $city, isVerified: $isVerified, level: $level, totalStudents: $totalStudents, certifications: $certifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality().equals(other._sports, _sports) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.hourlyRate, hourlyRate) ||
                other.hourlyRate == hourlyRate) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            const DeepCollectionEquality().equals(
              other._certifications,
              _certifications,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    bio,
    avatarUrl,
    const DeepCollectionEquality().hash(_sports),
    rating,
    totalReviews,
    hourlyRate,
    city,
    isVerified,
    level,
    totalStudents,
    const DeepCollectionEquality().hash(_certifications),
  );

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      __$$CoachImplCopyWithImpl<_$CoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachImplToJson(this);
  }
}

abstract class _Coach implements Coach {
  const factory _Coach({
    required final String id,
    required final String name,
    required final String bio,
    final String? avatarUrl,
    final List<Sport> sports,
    final double rating,
    final int totalReviews,
    required final int hourlyRate,
    required final String city,
    final bool isVerified,
    final LevelTier level,
    final int totalStudents,
    final List<String> certifications,
  }) = _$CoachImpl;

  factory _Coach.fromJson(Map<String, dynamic> json) = _$CoachImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get bio;
  @override
  String? get avatarUrl;
  @override
  List<Sport> get sports;
  @override
  double get rating;
  @override
  int get totalReviews;
  @override
  int get hourlyRate;
  @override
  String get city;
  @override
  bool get isVerified;
  @override
  LevelTier get level;
  @override
  int get totalStudents;
  @override
  List<String> get certifications;

  /// Create a copy of Coach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
