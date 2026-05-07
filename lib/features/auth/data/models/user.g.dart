// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  bio: json['bio'] as String?,
  city: json['city'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isVerified: json['is_verified'] as bool? ?? false,
  tenantId: (json['tenant_id'] as num?)?.toInt(),
  tenantSlug: json['tenant_slug'] as String?,
  tenantName: json['tenant_name'] as String?,
  tenantCurrency: json['tenant_currency'] as String?,
  tenantTimezone: json['tenant_timezone'] as String?,
  activeRole: json['active_role'] as String?,
  locale: json['locale'] as String?,
  availableRoles:
      (json['available_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'bio': instance.bio,
      'city': instance.city,
      'avatar_url': instance.avatarUrl,
      'role': _$UserRoleEnumMap[instance.role]!,
      'is_verified': instance.isVerified,
      'tenant_id': instance.tenantId,
      'tenant_slug': instance.tenantSlug,
      'tenant_name': instance.tenantName,
      'tenant_currency': instance.tenantCurrency,
      'tenant_timezone': instance.tenantTimezone,
      'active_role': instance.activeRole,
      'locale': instance.locale,
      'available_roles': instance.availableRoles,
    };

const _$UserRoleEnumMap = {
  UserRole.player: 'player',
  UserRole.coach: 'coach',
  UserRole.organizer: 'organizer',
  UserRole.courtOwner: 'courtOwner',
};
