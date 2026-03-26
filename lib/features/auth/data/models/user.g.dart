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
  avatarUrl: json['avatar_url'] as String?,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  isVerified: json['is_verified'] as bool? ?? false,
  tenantId: (json['tenant_id'] as num?)?.toInt(),
  tenantSlug: json['tenant_slug'] as String?,
  tenantName: json['tenant_name'] as String?,
  activeRole: json['active_role'] as String?,
  locale: json['locale'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'role': _$UserRoleEnumMap[instance.role]!,
      'is_verified': instance.isVerified,
      'tenant_id': instance.tenantId,
      'tenant_slug': instance.tenantSlug,
      'tenant_name': instance.tenantName,
      'active_role': instance.activeRole,
      'locale': instance.locale,
    };

const _$UserRoleEnumMap = {
  UserRole.player: 'player',
  UserRole.coach: 'coach',
  UserRole.organizer: 'organizer',
  UserRole.courtOwner: 'courtOwner',
};
