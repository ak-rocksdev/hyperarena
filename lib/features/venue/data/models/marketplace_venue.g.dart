// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceVenueImpl _$$MarketplaceVenueImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceVenueImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String,
  status: json['status'] as String,
  sport: json['sport'] == null
      ? null
      : SportInfo.fromJson(json['sport'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : VenueLocation.fromJson(json['location'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => VenuePhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MarketplaceVenueImplToJson(
  _$MarketplaceVenueImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'sport': instance.sport,
  'location': instance.location,
  'photos': instance.photos,
};

_$VenueLocationImpl _$$VenueLocationImplFromJson(Map<String, dynamic> json) =>
    _$VenueLocationImpl(
      name: json['name'] as String,
      address: json['address'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$VenueLocationImplToJson(_$VenueLocationImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_$VenuePhotoImpl _$$VenuePhotoImplFromJson(Map<String, dynamic> json) =>
    _$VenuePhotoImpl(
      url: json['url'] as String,
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$$VenuePhotoImplToJson(_$VenuePhotoImpl instance) =>
    <String, dynamic>{'url': instance.url, 'caption': instance.caption};

_$SportInfoImpl _$$SportInfoImplFromJson(Map<String, dynamic> json) =>
    _$SportInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$SportInfoImplToJson(_$SportInfoImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
