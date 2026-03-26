// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TenantSummaryImpl _$$TenantSummaryImplFromJson(Map<String, dynamic> json) =>
    _$TenantSummaryImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logo_url'] as String?,
    );

Map<String, dynamic> _$$TenantSummaryImplToJson(_$TenantSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logo_url': instance.logoUrl,
    };
