// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceSessionImpl _$$MarketplaceSessionImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceSessionImpl(
  id: _idFromJson(json['id']),
  name: json['name'] as String,
  type: json['type'] as String?,
  startAt: DateTime.parse(json['start_at'] as String),
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
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
};

_$SessionTenantImpl _$$SessionTenantImplFromJson(Map<String, dynamic> json) =>
    _$SessionTenantImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$SessionTenantImplToJson(_$SessionTenantImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

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

_$SessionCoachImpl _$$SessionCoachImplFromJson(Map<String, dynamic> json) =>
    _$SessionCoachImpl(
      id: _idFromJson(json['id']),
      name: json['name'] as String,
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$$SessionCoachImplToJson(_$SessionCoachImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo_path': instance.photoPath,
    };
