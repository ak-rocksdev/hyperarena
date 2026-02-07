// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  phone: json['phone'] as String?,
  whatsappNumber: json['whatsapp_number'] as String?,
  facilities:
      (json['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isVerified: json['is_verified'] as bool? ?? false,
  avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
  courts:
      (json['courts'] as List<dynamic>?)
          ?.map((e) => Court.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'whatsapp_number': instance.whatsappNumber,
      'facilities': instance.facilities,
      'photos': instance.photos,
      'is_verified': instance.isVerified,
      'avg_rating': instance.avgRating,
      'total_reviews': instance.totalReviews,
      'courts': instance.courts,
    };
