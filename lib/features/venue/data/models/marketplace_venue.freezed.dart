// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketplaceVenue _$MarketplaceVenueFromJson(Map<String, dynamic> json) {
  return _MarketplaceVenue.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceVenue {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  SportInfo? get sport => throw _privateConstructorUsedError;
  VenueLocation? get location => throw _privateConstructorUsedError;
  List<VenuePhoto> get photos => throw _privateConstructorUsedError;
  @JsonKey(name: 'tenant_id')
  int? get tenantId => throw _privateConstructorUsedError;

  /// BE-resolved card cover image — uploaded photo if any, else Google
  /// Street View at the venue's lat/lng. Null when neither is available
  /// (no photos AND no location/no API key configured); caller renders
  /// a placeholder. Prefer this over reading [photos] directly so the
  /// fallback to Street View imagery is automatic.
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl => throw _privateConstructorUsedError;

  /// Serializes this MarketplaceVenue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketplaceVenueCopyWith<MarketplaceVenue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceVenueCopyWith<$Res> {
  factory $MarketplaceVenueCopyWith(
    MarketplaceVenue value,
    $Res Function(MarketplaceVenue) then,
  ) = _$MarketplaceVenueCopyWithImpl<$Res, MarketplaceVenue>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String status,
    SportInfo? sport,
    VenueLocation? location,
    List<VenuePhoto> photos,
    @JsonKey(name: 'tenant_id') int? tenantId,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
  });

  $SportInfoCopyWith<$Res>? get sport;
  $VenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$MarketplaceVenueCopyWithImpl<$Res, $Val extends MarketplaceVenue>
    implements $MarketplaceVenueCopyWith<$Res> {
  _$MarketplaceVenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? sport = freezed,
    Object? location = freezed,
    Object? photos = null,
    Object? tenantId = freezed,
    Object? coverImageUrl = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            sport: freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                      as SportInfo?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as VenueLocation?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<VenuePhoto>,
            tenantId: freezed == tenantId
                ? _value.tenantId
                : tenantId // ignore: cast_nullable_to_non_nullable
                      as int?,
            coverImageUrl: freezed == coverImageUrl
                ? _value.coverImageUrl
                : coverImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketplaceVenue
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

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VenueLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $VenueLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketplaceVenueImplCopyWith<$Res>
    implements $MarketplaceVenueCopyWith<$Res> {
  factory _$$MarketplaceVenueImplCopyWith(
    _$MarketplaceVenueImpl value,
    $Res Function(_$MarketplaceVenueImpl) then,
  ) = __$$MarketplaceVenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    String name,
    String status,
    SportInfo? sport,
    VenueLocation? location,
    List<VenuePhoto> photos,
    @JsonKey(name: 'tenant_id') int? tenantId,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
  });

  @override
  $SportInfoCopyWith<$Res>? get sport;
  @override
  $VenueLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$MarketplaceVenueImplCopyWithImpl<$Res>
    extends _$MarketplaceVenueCopyWithImpl<$Res, _$MarketplaceVenueImpl>
    implements _$$MarketplaceVenueImplCopyWith<$Res> {
  __$$MarketplaceVenueImplCopyWithImpl(
    _$MarketplaceVenueImpl _value,
    $Res Function(_$MarketplaceVenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? sport = freezed,
    Object? location = freezed,
    Object? photos = null,
    Object? tenantId = freezed,
    Object? coverImageUrl = freezed,
  }) {
    return _then(
      _$MarketplaceVenueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        sport: freezed == sport
            ? _value.sport
            : sport // ignore: cast_nullable_to_non_nullable
                  as SportInfo?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as VenueLocation?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<VenuePhoto>,
        tenantId: freezed == tenantId
            ? _value.tenantId
            : tenantId // ignore: cast_nullable_to_non_nullable
                  as int?,
        coverImageUrl: freezed == coverImageUrl
            ? _value.coverImageUrl
            : coverImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceVenueImpl implements _MarketplaceVenue {
  const _$MarketplaceVenueImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    required this.name,
    this.status = 'active',
    this.sport,
    this.location,
    final List<VenuePhoto> photos = const [],
    @JsonKey(name: 'tenant_id') this.tenantId,
    @JsonKey(name: 'cover_image_url') this.coverImageUrl,
  }) : _photos = photos;

  factory _$MarketplaceVenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceVenueImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String status;
  @override
  final SportInfo? sport;
  @override
  final VenueLocation? location;
  final List<VenuePhoto> _photos;
  @override
  @JsonKey()
  List<VenuePhoto> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey(name: 'tenant_id')
  final int? tenantId;

  /// BE-resolved card cover image — uploaded photo if any, else Google
  /// Street View at the venue's lat/lng. Null when neither is available
  /// (no photos AND no location/no API key configured); caller renders
  /// a placeholder. Prefer this over reading [photos] directly so the
  /// fallback to Street View imagery is automatic.
  @override
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;

  @override
  String toString() {
    return 'MarketplaceVenue(id: $id, name: $name, status: $status, sport: $sport, location: $location, photos: $photos, tenantId: $tenantId, coverImageUrl: $coverImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceVenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.tenantId, tenantId) ||
                other.tenantId == tenantId) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    status,
    sport,
    location,
    const DeepCollectionEquality().hash(_photos),
    tenantId,
    coverImageUrl,
  );

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceVenueImplCopyWith<_$MarketplaceVenueImpl> get copyWith =>
      __$$MarketplaceVenueImplCopyWithImpl<_$MarketplaceVenueImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceVenueImplToJson(this);
  }
}

abstract class _MarketplaceVenue implements MarketplaceVenue {
  const factory _MarketplaceVenue({
    @JsonKey(fromJson: idFromJson) required final String id,
    required final String name,
    final String status,
    final SportInfo? sport,
    final VenueLocation? location,
    final List<VenuePhoto> photos,
    @JsonKey(name: 'tenant_id') final int? tenantId,
    @JsonKey(name: 'cover_image_url') final String? coverImageUrl,
  }) = _$MarketplaceVenueImpl;

  factory _MarketplaceVenue.fromJson(Map<String, dynamic> json) =
      _$MarketplaceVenueImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  String get name;
  @override
  String get status;
  @override
  SportInfo? get sport;
  @override
  VenueLocation? get location;
  @override
  List<VenuePhoto> get photos;
  @override
  @JsonKey(name: 'tenant_id')
  int? get tenantId;

  /// BE-resolved card cover image — uploaded photo if any, else Google
  /// Street View at the venue's lat/lng. Null when neither is available
  /// (no photos AND no location/no API key configured); caller renders
  /// a placeholder. Prefer this over reading [photos] directly so the
  /// fallback to Street View imagery is automatic.
  @override
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl;

  /// Create a copy of MarketplaceVenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketplaceVenueImplCopyWith<_$MarketplaceVenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenueLocation _$VenueLocationFromJson(Map<String, dynamic> json) {
  return _VenueLocation.fromJson(json);
}

/// @nodoc
mixin _$VenueLocation {
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lat => throw _privateConstructorUsedError;
  @JsonKey(fromJson: latLngFromJson)
  double? get lng => throw _privateConstructorUsedError;

  /// Serializes this VenueLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueLocationCopyWith<VenueLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueLocationCopyWith<$Res> {
  factory $VenueLocationCopyWith(
    VenueLocation value,
    $Res Function(VenueLocation) then,
  ) = _$VenueLocationCopyWithImpl<$Res, VenueLocation>;
  @useResult
  $Res call({
    String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class _$VenueLocationCopyWithImpl<$Res, $Val extends VenueLocation>
    implements $VenueLocationCopyWith<$Res> {
  _$VenueLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            lat: freezed == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double?,
            lng: freezed == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VenueLocationImplCopyWith<$Res>
    implements $VenueLocationCopyWith<$Res> {
  factory _$$VenueLocationImplCopyWith(
    _$VenueLocationImpl value,
    $Res Function(_$VenueLocationImpl) then,
  ) = __$$VenueLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  });
}

/// @nodoc
class __$$VenueLocationImplCopyWithImpl<$Res>
    extends _$VenueLocationCopyWithImpl<$Res, _$VenueLocationImpl>
    implements _$$VenueLocationImplCopyWith<$Res> {
  __$$VenueLocationImplCopyWithImpl(
    _$VenueLocationImpl _value,
    $Res Function(_$VenueLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
  }) {
    return _then(
      _$VenueLocationImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double?,
        lng: freezed == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueLocationImpl implements _VenueLocation {
  const _$VenueLocationImpl({
    required this.name,
    this.address,
    @JsonKey(fromJson: latLngFromJson) this.lat,
    @JsonKey(fromJson: latLngFromJson) this.lng,
  });

  factory _$VenueLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueLocationImplFromJson(json);

  @override
  final String name;
  @override
  final String? address;
  @override
  @JsonKey(fromJson: latLngFromJson)
  final double? lat;
  @override
  @JsonKey(fromJson: latLngFromJson)
  final double? lng;

  @override
  String toString() {
    return 'VenueLocation(name: $name, address: $address, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueLocationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, address, lat, lng);

  /// Create a copy of VenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueLocationImplCopyWith<_$VenueLocationImpl> get copyWith =>
      __$$VenueLocationImplCopyWithImpl<_$VenueLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueLocationImplToJson(this);
  }
}

abstract class _VenueLocation implements VenueLocation {
  const factory _VenueLocation({
    required final String name,
    final String? address,
    @JsonKey(fromJson: latLngFromJson) final double? lat,
    @JsonKey(fromJson: latLngFromJson) final double? lng,
  }) = _$VenueLocationImpl;

  factory _VenueLocation.fromJson(Map<String, dynamic> json) =
      _$VenueLocationImpl.fromJson;

  @override
  String get name;
  @override
  String? get address;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lat;
  @override
  @JsonKey(fromJson: latLngFromJson)
  double? get lng;

  /// Create a copy of VenueLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueLocationImplCopyWith<_$VenueLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VenuePhoto _$VenuePhotoFromJson(Map<String, dynamic> json) {
  return _VenuePhoto.fromJson(json);
}

/// @nodoc
mixin _$VenuePhoto {
  String get url => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;

  /// Serializes this VenuePhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VenuePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenuePhotoCopyWith<VenuePhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenuePhotoCopyWith<$Res> {
  factory $VenuePhotoCopyWith(
    VenuePhoto value,
    $Res Function(VenuePhoto) then,
  ) = _$VenuePhotoCopyWithImpl<$Res, VenuePhoto>;
  @useResult
  $Res call({String url, String? caption});
}

/// @nodoc
class _$VenuePhotoCopyWithImpl<$Res, $Val extends VenuePhoto>
    implements $VenuePhotoCopyWith<$Res> {
  _$VenuePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VenuePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? caption = freezed}) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VenuePhotoImplCopyWith<$Res>
    implements $VenuePhotoCopyWith<$Res> {
  factory _$$VenuePhotoImplCopyWith(
    _$VenuePhotoImpl value,
    $Res Function(_$VenuePhotoImpl) then,
  ) = __$$VenuePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String? caption});
}

/// @nodoc
class __$$VenuePhotoImplCopyWithImpl<$Res>
    extends _$VenuePhotoCopyWithImpl<$Res, _$VenuePhotoImpl>
    implements _$$VenuePhotoImplCopyWith<$Res> {
  __$$VenuePhotoImplCopyWithImpl(
    _$VenuePhotoImpl _value,
    $Res Function(_$VenuePhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VenuePhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? caption = freezed}) {
    return _then(
      _$VenuePhotoImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VenuePhotoImpl implements _VenuePhoto {
  const _$VenuePhotoImpl({required this.url, this.caption});

  factory _$VenuePhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenuePhotoImplFromJson(json);

  @override
  final String url;
  @override
  final String? caption;

  @override
  String toString() {
    return 'VenuePhoto(url: $url, caption: $caption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenuePhotoImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, caption);

  /// Create a copy of VenuePhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenuePhotoImplCopyWith<_$VenuePhotoImpl> get copyWith =>
      __$$VenuePhotoImplCopyWithImpl<_$VenuePhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenuePhotoImplToJson(this);
  }
}

abstract class _VenuePhoto implements VenuePhoto {
  const factory _VenuePhoto({
    required final String url,
    final String? caption,
  }) = _$VenuePhotoImpl;

  factory _VenuePhoto.fromJson(Map<String, dynamic> json) =
      _$VenuePhotoImpl.fromJson;

  @override
  String get url;
  @override
  String? get caption;

  /// Create a copy of VenuePhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenuePhotoImplCopyWith<_$VenuePhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SportInfo _$SportInfoFromJson(Map<String, dynamic> json) {
  return _SportInfo.fromJson(json);
}

/// @nodoc
mixin _$SportInfo {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SportInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SportInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SportInfoCopyWith<SportInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SportInfoCopyWith<$Res> {
  factory $SportInfoCopyWith(SportInfo value, $Res Function(SportInfo) then) =
      _$SportInfoCopyWithImpl<$Res, SportInfo>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$SportInfoCopyWithImpl<$Res, $Val extends SportInfo>
    implements $SportInfoCopyWith<$Res> {
  _$SportInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SportInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SportInfoImplCopyWith<$Res>
    implements $SportInfoCopyWith<$Res> {
  factory _$$SportInfoImplCopyWith(
    _$SportInfoImpl value,
    $Res Function(_$SportInfoImpl) then,
  ) = __$$SportInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$SportInfoImplCopyWithImpl<$Res>
    extends _$SportInfoCopyWithImpl<$Res, _$SportInfoImpl>
    implements _$$SportInfoImplCopyWith<$Res> {
  __$$SportInfoImplCopyWithImpl(
    _$SportInfoImpl _value,
    $Res Function(_$SportInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SportInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$SportInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SportInfoImpl implements _SportInfo {
  const _$SportInfoImpl({required this.id, required this.name});

  factory _$SportInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SportInfoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'SportInfo(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SportInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SportInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SportInfoImplCopyWith<_$SportInfoImpl> get copyWith =>
      __$$SportInfoImplCopyWithImpl<_$SportInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SportInfoImplToJson(this);
  }
}

abstract class _SportInfo implements SportInfo {
  const factory _SportInfo({
    required final int id,
    required final String name,
  }) = _$SportInfoImpl;

  factory _SportInfo.fromJson(Map<String, dynamic> json) =
      _$SportInfoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of SportInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SportInfoImplCopyWith<_$SportInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
