// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_coach.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketplaceCoach _$MarketplaceCoachFromJson(Map<String, dynamic> json) {
  return _MarketplaceCoach.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceCoach {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  CoachUser? get user => throw _privateConstructorUsedError;
  SportInfo? get sport => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate_per_session')
  int? get ratePerSession => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceCoach to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceCoachCopyWith<MarketplaceCoach> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceCoachCopyWith<$Res> {
  factory $MarketplaceCoachCopyWith(
    MarketplaceCoach value,
    $Res Function(MarketplaceCoach) then,
  ) = _$MarketplaceCoachCopyWithImpl<$Res, MarketplaceCoach>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String? bio,
    CoachUser? user,
    SportInfo? sport,
    @JsonKey(name: 'rate_per_session') int? ratePerSession,
    String? currency,
  });

  $CoachUserCopyWith<$Res>? get user;
  $SportInfoCopyWith<$Res>? get sport;
}

/// @nodoc
class _$MarketplaceCoachCopyWithImpl<$Res, $Val extends MarketplaceCoach>
    implements $MarketplaceCoachCopyWith<$Res> {
  _$MarketplaceCoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bio = freezed,
    Object? user = freezed,
    Object? sport = freezed,
    Object? ratePerSession = freezed,
    Object? currency = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as CoachUser?,
            sport: freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as SportInfo?,
            ratePerSession: freezed == ratePerSession
                ? _value.ratePerSession
                : ratePerSession // ignore: cast_nullable_to_non_nullable
                      as int?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CoachUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $CoachUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SportInfoCopyWith<$Res>? get sport {
    if (_value.sport == null) {
      return null;
    }

    return $SportInfoCopyWith<$Res>(_value.sport!, (value) {
      return _then(_value.copyWith(sport: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceCoachImplCopyWith<$Res>
    implements $MarketplaceCoachCopyWith<$Res> {
  factory _$$MarketplaceCoachImplCopyWith(
    _$MarketplaceCoachImpl value,
    $Res Function(_$MarketplaceCoachImpl) then,
  ) = __$$MarketplaceCoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String? bio,
    CoachUser? user,
    SportInfo? sport,
    @JsonKey(name: 'rate_per_session') int? ratePerSession,
    String? currency,
  });

  @override
  $CoachUserCopyWith<$Res>? get user;
  @override
  $SportInfoCopyWith<$Res>? get sport;
}

/// @nodoc
class __$$MarketplaceCoachImplCopyWithImpl<$Res>
    extends _$MarketplaceCoachCopyWithImpl<$Res, _$MarketplaceCoachImpl>
    implements _$$MarketplaceCoachImplCopyWith<$Res> {
  __$$MarketplaceCoachImplCopyWithImpl(
    _$MarketplaceCoachImpl _value,
    $Res Function(_$MarketplaceCoachImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bio = freezed,
    Object? user = freezed,
    Object? sport = freezed,
    Object? ratePerSession = freezed,
    Object? currency = freezed,
  }) {
    return _then(
      _$MarketplaceCoachImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as CoachUser?,
        sport: freezed == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as SportInfo?,
        ratePerSession: freezed == ratePerSession
            ? _value.ratePerSession
            : ratePerSession // ignore: cast_nullable_to_non_nullable
                  as int?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceCoachImpl implements _MarketplaceCoach {
  const _$MarketplaceCoachImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    this.bio,
    this.user,
    this.sport,
    @JsonKey(name: 'rate_per_session') this.ratePerSession,
    this.currency,
  });

  factory _$MarketplaceCoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceCoachImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String? bio;
  @override
  final CoachUser? user;
  @override
  final SportInfo? sport;
  @override
  @JsonKey(name: 'rate_per_session')
  final int? ratePerSession;
  @override
  final String? currency;

  @override
  String toString() {
    return 'MarketplaceCoach(id: $id, bio: $bio, user: $user, sport: $sport, ratePerSession: $ratePerSession, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceCoachImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.ratePerSession, ratePerSession) ||
                other.ratePerSession == ratePerSession) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, bio, user, sport, ratePerSession, currency);

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceCoachImplCopyWith<_$MarketplaceCoachImpl> get copyWith =>
      __$$MarketplaceCoachImplCopyWithImpl<_$MarketplaceCoachImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceCoachImplToJson(this);
  }
}

abstract class _MarketplaceCoach implements MarketplaceCoach {
  const factory _MarketplaceCoach({
    @JsonKey(fromJson: idFromJson) required final String id,
    final String? bio,
    final CoachUser? user,
    final SportInfo? sport,
    @JsonKey(name: 'rate_per_session') final int? ratePerSession,
    final String? currency,
  }) = _$MarketplaceCoachImpl;

  factory _MarketplaceCoach.fromJson(Map<String, dynamic> json) =
      _$MarketplaceCoachImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String? get bio;
  @override
  CoachUser? get user;
  @override
  SportInfo? get sport;
  @override
  @JsonKey(name: 'rate_per_session')
  int? get ratePerSession;
  @override
  String? get currency;

  /// Create a copy of MarketplaceCoach
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceCoachImplCopyWith<_$MarketplaceCoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CoachUser _$CoachUserFromJson(Map<String, dynamic> json) {
  return _CoachUser.fromJson(json);
}

/// @nodoc
mixin _$CoachUser {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;

  /// Serializes this CoachUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoachUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoachUserCopyWith<CoachUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachUserCopyWith<$Res> {
  factory $CoachUserCopyWith(CoachUser value, $Res Function(CoachUser) then) =
      _$CoachUserCopyWithImpl<$Res, CoachUser>;
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });
}

/// @nodoc
class _$CoachUserCopyWithImpl<$Res, $Val extends CoachUser>
    implements $CoachUserCopyWith<$Res> {
  _$CoachUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoachUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? photoUrls = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachUserImplCopyWith<$Res>
    implements $CoachUserCopyWith<$Res> {
  factory _$$CoachUserImplCopyWith(
    _$CoachUserImpl value,
    $Res Function(_$CoachUserImpl) then,
  ) = __$$CoachUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
  });
}

/// @nodoc
class __$$CoachUserImplCopyWithImpl<$Res>
    extends _$CoachUserCopyWithImpl<$Res, _$CoachUserImpl>
    implements _$$CoachUserImplCopyWith<$Res> {
  __$$CoachUserImplCopyWithImpl(
    _$CoachUserImpl _value,
    $Res Function(_$CoachUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoachUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? photoUrls = freezed}) {
    return _then(
      _$CoachUserImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CoachUserImpl implements _CoachUser {
  const _$CoachUserImpl({
    required this.name,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) : _photoUrls = photoUrls;

  factory _$CoachUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachUserImplFromJson(json);

  @override
  final String name;
  final Map<String, String>? _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableMapView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CoachUser(name: $name, photoUrls: $photoUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachUserImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_photoUrls),
  );

  /// Create a copy of CoachUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachUserImplCopyWith<_$CoachUserImpl> get copyWith =>
      __$$CoachUserImplCopyWithImpl<_$CoachUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachUserImplToJson(this);
  }
}

abstract class _CoachUser implements CoachUser {
  const factory _CoachUser({
    required final String name,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
  }) = _$CoachUserImpl;

  factory _CoachUser.fromJson(Map<String, dynamic> json) =
      _$CoachUserImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;

  /// Create a copy of CoachUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoachUserImplCopyWith<_$CoachUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
