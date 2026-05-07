// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceSessionImpl _$$MarketplaceSessionImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceSessionImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String? ?? 'Sesi Latihan',
  type: json['type'] as String?,
  startAt: tenantWallClockFromJson(json['start_at'] as String),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  capacity: (json['capacity'] as num?)?.toInt() ?? 0,
  bookedCount: (json['booked_count'] as num?)?.toInt() ?? 0,
  notes: json['notes'] as String?,
  tenant: json['tenant'] == null
      ? null
      : SessionTenant.fromJson(json['tenant'] as Map<String, dynamic>),
  venue: json['venue'] == null
      ? null
      : MarketplaceSessionVenue.fromJson(json['venue'] as Map<String, dynamic>),
  coaches:
      (json['coaches'] as List<dynamic>?)
          ?.map((e) => SessionCoach.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => SessionParticipant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isEnrolled: json['is_enrolled'] as bool? ?? false,
  title: json['title'] as String?,
  displayTitle: json['display_title'] as String?,
  photoPath: json['photo_path'] as String?,
  photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$$MarketplaceSessionImplToJson(
  _$MarketplaceSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'start_at': instance.startAt.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'capacity': instance.capacity,
  'booked_count': instance.bookedCount,
  'notes': instance.notes,
  'tenant': instance.tenant,
  'venue': instance.venue,
  'coaches': instance.coaches,
  'participants': instance.participants,
  'is_enrolled': instance.isEnrolled,
  'title': instance.title,
  'display_title': instance.displayTitle,
  'photo_path': instance.photoPath,
  'photo_urls': instance.photoUrls,
};

_$SessionTenantImpl _$$SessionTenantImplFromJson(Map<String, dynamic> json) =>
    _$SessionTenantImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      slug: json['slug'] as String?,
      brandColor: json['brand_color'] as String?,
      logoUrls: (json['logo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$SessionTenantImplToJson(_$SessionTenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'brand_color': instance.brandColor,
      'logo_urls': instance.logoUrls,
    };

_$MarketplaceSessionVenueImpl _$$MarketplaceSessionVenueImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceSessionVenueImpl(
  name: json['name'] as String,
  location: json['location'] == null
      ? null
      : VenueLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$MarketplaceSessionVenueImplToJson(
  _$MarketplaceSessionVenueImpl instance,
) => <String, dynamic>{'name': instance.name, 'location': instance.location};

_$SessionParticipantImpl _$$SessionParticipantImplFromJson(
  Map<String, dynamic> json,
) => _$SessionParticipantImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  photoUrl: json['photo_url'] as String?,
  bookedAt: json['booked_at'] == null
      ? null
      : DateTime.parse(json['booked_at'] as String),
);

Map<String, dynamic> _$$SessionParticipantImplToJson(
  _$SessionParticipantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'photo_url': instance.photoUrl,
  'booked_at': instance.bookedAt?.toIso8601String(),
};

_$SessionCoachImpl _$$SessionCoachImplFromJson(Map<String, dynamic> json) =>
    _$SessionCoachImpl(
      id: idFromJson(json['id']),
      user: json['user'] == null
          ? null
          : CoachUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SessionCoachImplToJson(_$SessionCoachImpl instance) =>
    <String, dynamic>{'id': instance.id, 'user': instance.user};
