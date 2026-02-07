// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return _Venue.fromJson(json);
}

/// @nodoc
mixin _$Venue {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get whatsappNumber => throw _privateConstructorUsedError;
  List<String> get facilities => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  List<Court> get courts => throw _privateConstructorUsedError;

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueCopyWith<Venue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueCopyWith<$Res> {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) then) =
      _$VenueCopyWithImpl<$Res, Venue>;
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String description,
    String address,
    String city,
    double latitude,
    double longitude,
    String? phone,
    String? whatsappNumber,
    List<String> facilities,
    List<String> photos,
    bool isVerified,
    double avgRating,
    int totalReviews,
    List<Court> courts,
  });
}

/// @nodoc
class _$VenueCopyWithImpl<$Res, $Val extends Venue>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? city = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = freezed,
    Object? whatsappNumber = freezed,
    Object? facilities = null,
    Object? photos = null,
    Object? isVerified = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? courts = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            whatsappNumber: freezed == whatsappNumber
                ? _value.whatsappNumber
                : whatsappNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            facilities: null == facilities
                ? _value.facilities
                : facilities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVerified: null == isVerified
                ? _value.isVerified
                : isVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            courts: null == courts
                ? _value.courts
                : courts // ignore: cast_nullable_to_non_nullable
                      as List<Court>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VenueImplCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$$VenueImplCopyWith(
    _$VenueImpl value,
    $Res Function(_$VenueImpl) then,
  ) = __$$VenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ownerId,
    String name,
    String description,
    String address,
    String city,
    double latitude,
    double longitude,
    String? phone,
    String? whatsappNumber,
    List<String> facilities,
    List<String> photos,
    bool isVerified,
    double avgRating,
    int totalReviews,
    List<Court> courts,
  });
}

/// @nodoc
class __$$VenueImplCopyWithImpl<$Res>
    extends _$VenueCopyWithImpl<$Res, _$VenueImpl>
    implements _$$VenueImplCopyWith<$Res> {
  __$$VenueImplCopyWithImpl(
    _$VenueImpl _value,
    $Res Function(_$VenueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? city = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = freezed,
    Object? whatsappNumber = freezed,
    Object? facilities = null,
    Object? photos = null,
    Object? isVerified = null,
    Object? avgRating = null,
    Object? totalReviews = null,
    Object? courts = null,
  }) {
    return _then(
      _$VenueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        whatsappNumber: freezed == whatsappNumber
            ? _value.whatsappNumber
            : whatsappNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        facilities: null == facilities
            ? _value._facilities
            : facilities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVerified: null == isVerified
            ? _value.isVerified
            : isVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        courts: null == courts
            ? _value._courts
            : courts // ignore: cast_nullable_to_non_nullable
                  as List<Court>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueImpl implements _Venue {
  const _$VenueImpl({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.whatsappNumber,
    final List<String> facilities = const [],
    final List<String> photos = const [],
    this.isVerified = false,
    this.avgRating = 0.0,
    this.totalReviews = 0,
    final List<Court> courts = const [],
  }) : _facilities = facilities,
       _photos = photos,
       _courts = courts;

  factory _$VenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String description;
  @override
  final String address;
  @override
  final String city;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? phone;
  @override
  final String? whatsappNumber;
  final List<String> _facilities;
  @override
  @JsonKey()
  List<String> get facilities {
    if (_facilities is EqualUnmodifiableListView) return _facilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facilities);
  }

  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final double avgRating;
  @override
  @JsonKey()
  final int totalReviews;
  final List<Court> _courts;
  @override
  @JsonKey()
  List<Court> get courts {
    if (_courts is EqualUnmodifiableListView) return _courts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_courts);
  }

  @override
  String toString() {
    return 'Venue(id: $id, ownerId: $ownerId, name: $name, description: $description, address: $address, city: $city, latitude: $latitude, longitude: $longitude, phone: $phone, whatsappNumber: $whatsappNumber, facilities: $facilities, photos: $photos, isVerified: $isVerified, avgRating: $avgRating, totalReviews: $totalReviews, courts: $courts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            const DeepCollectionEquality().equals(
              other._facilities,
              _facilities,
            ) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality().equals(other._courts, _courts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    description,
    address,
    city,
    latitude,
    longitude,
    phone,
    whatsappNumber,
    const DeepCollectionEquality().hash(_facilities),
    const DeepCollectionEquality().hash(_photos),
    isVerified,
    avgRating,
    totalReviews,
    const DeepCollectionEquality().hash(_courts),
  );

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      __$$VenueImplCopyWithImpl<_$VenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueImplToJson(this);
  }
}

abstract class _Venue implements Venue {
  const factory _Venue({
    required final String id,
    required final String ownerId,
    required final String name,
    required final String description,
    required final String address,
    required final String city,
    required final double latitude,
    required final double longitude,
    final String? phone,
    final String? whatsappNumber,
    final List<String> facilities,
    final List<String> photos,
    final bool isVerified,
    final double avgRating,
    final int totalReviews,
    final List<Court> courts,
  }) = _$VenueImpl;

  factory _Venue.fromJson(Map<String, dynamic> json) = _$VenueImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get name;
  @override
  String get description;
  @override
  String get address;
  @override
  String get city;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get phone;
  @override
  String? get whatsappNumber;
  @override
  List<String> get facilities;
  @override
  List<String> get photos;
  @override
  bool get isVerified;
  @override
  double get avgRating;
  @override
  int get totalReviews;
  @override
  List<Court> get courts;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
