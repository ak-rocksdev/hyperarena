// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubSummaryImpl _$$ClubSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ClubSummaryImpl(
      tenant: ClubTenant.fromJson(json['tenant'] as Map<String, dynamic>),
      stats: ClubStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ClubSummaryImplToJson(_$ClubSummaryImpl instance) =>
    <String, dynamic>{'tenant': instance.tenant, 'stats': instance.stats};

_$ClubTenantImpl _$$ClubTenantImplFromJson(Map<String, dynamic> json) =>
    _$ClubTenantImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      slug: json['slug'] as String,
      sportName: json['sport_name'] as String?,
      logoUrls: (json['logo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      city: json['city'] as String?,
      brandColor: json['brand_color'] as String?,
    );

Map<String, dynamic> _$$ClubTenantImplToJson(_$ClubTenantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'sport_name': instance.sportName,
      'logo_urls': instance.logoUrls,
      'city': instance.city,
      'brand_color': instance.brandColor,
    };

_$ClubStatsImpl _$$ClubStatsImplFromJson(Map<String, dynamic> json) =>
    _$ClubStatsImpl(
      activeMembersCount: (json['active_members_count'] as num?)?.toInt() ?? 0,
      activeCoachesCount: (json['active_coaches_count'] as num?)?.toInt() ?? 0,
      sessionsThisMonth: (json['sessions_this_month'] as num?)?.toInt() ?? 0,
      outstandingTotal: (json['outstanding_total'] as num?)?.toInt() ?? 0,
      outstandingCount: (json['outstanding_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ClubStatsImplToJson(_$ClubStatsImpl instance) =>
    <String, dynamic>{
      'active_members_count': instance.activeMembersCount,
      'active_coaches_count': instance.activeCoachesCount,
      'sessions_this_month': instance.sessionsThisMonth,
      'outstanding_total': instance.outstandingTotal,
      'outstanding_count': instance.outstandingCount,
    };
