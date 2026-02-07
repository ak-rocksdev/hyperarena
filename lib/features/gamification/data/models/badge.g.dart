// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeImpl _$$BadgeImplFromJson(Map<String, dynamic> json) => _$BadgeImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconName: json['icon_name'] as String,
  isUnlocked: json['is_unlocked'] as bool? ?? false,
  unlockedAt: json['unlocked_at'] == null
      ? null
      : DateTime.parse(json['unlocked_at'] as String),
  xpReward: (json['xp_reward'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$BadgeImplToJson(_$BadgeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon_name': instance.iconName,
      'is_unlocked': instance.isUnlocked,
      'unlocked_at': instance.unlockedAt?.toIso8601String(),
      'xp_reward': instance.xpReward,
    };
