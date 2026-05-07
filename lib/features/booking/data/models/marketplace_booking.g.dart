// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceBookingImpl _$$MarketplaceBookingImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceBookingImpl(
  bookingId: idFromJson(json['booking_id']),
  bookedAt: DateTime.parse(json['booked_at'] as String),
  paymentStatus: json['payment_status'] as String?,
  session: BookingSession.fromJson(json['session'] as Map<String, dynamic>),
  canReview: json['can_review'] as bool? ?? false,
  reviewBlockedReason: json['review_blocked_reason'] as String?,
);

Map<String, dynamic> _$$MarketplaceBookingImplToJson(
  _$MarketplaceBookingImpl instance,
) => <String, dynamic>{
  'booking_id': instance.bookingId,
  'booked_at': instance.bookedAt.toIso8601String(),
  'payment_status': instance.paymentStatus,
  'session': instance.session,
  'can_review': instance.canReview,
  'review_blocked_reason': instance.reviewBlockedReason,
};

_$BookingSessionImpl _$$BookingSessionImplFromJson(Map<String, dynamic> json) =>
    _$BookingSessionImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      type: json['type'] as String?,
      startAt: DateTime.parse(json['start_at'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      tenant: json['tenant'] == null
          ? null
          : BookingTenant.fromJson(json['tenant'] as Map<String, dynamic>),
      venue: json['venue'] == null
          ? null
          : BookingVenue.fromJson(json['venue'] as Map<String, dynamic>),
      coaches:
          (json['coaches'] as List<dynamic>?)
              ?.map((e) => BookingCoach.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BookingCoach>[],
      title: json['title'] as String?,
      displayTitle: json['display_title'] as String?,
      photoPath: json['photo_path'] as String?,
      photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$BookingSessionImplToJson(
  _$BookingSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'start_at': instance.startAt.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'tenant': instance.tenant,
  'venue': instance.venue,
  'coaches': instance.coaches,
  'title': instance.title,
  'display_title': instance.displayTitle,
  'photo_path': instance.photoPath,
  'photo_urls': instance.photoUrls,
};

_$BookingTenantImpl _$$BookingTenantImplFromJson(Map<String, dynamic> json) =>
    _$BookingTenantImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      slug: json['slug'] as String?,
      brandColor: json['brand_color'] as String?,
      logoUrls: (json['logo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$BookingTenantImplToJson(_$BookingTenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'brand_color': instance.brandColor,
      'logo_urls': instance.logoUrls,
    };

_$BookingVenueImpl _$$BookingVenueImplFromJson(Map<String, dynamic> json) =>
    _$BookingVenueImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      location: json['location'] == null
          ? null
          : BookingVenueLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$BookingVenueImplToJson(_$BookingVenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
    };

_$BookingVenueLocationImpl _$$BookingVenueLocationImplFromJson(
  Map<String, dynamic> json,
) => _$BookingVenueLocationImpl(
  address: json['address'] as String?,
  lat: latLngFromJson(json['lat']),
  lng: latLngFromJson(json['lng']),
);

Map<String, dynamic> _$$BookingVenueLocationImplToJson(
  _$BookingVenueLocationImpl instance,
) => <String, dynamic>{
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
};

_$BookingCoachImpl _$$BookingCoachImplFromJson(Map<String, dynamic> json) =>
    _$BookingCoachImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$$BookingCoachImplToJson(_$BookingCoachImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_url': instance.photoUrl,
    };
