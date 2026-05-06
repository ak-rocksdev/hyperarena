// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LevelSkillImpl _$$LevelSkillImplFromJson(Map<String, dynamic> json) =>
    _$LevelSkillImpl(
      id: idFromJson(json['id']),
      levelId: idFromJson(json['level_id']),
      studentProfileId: nullableIdFromJson(json['student_profile_id']),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      skill: json['skill'] == null
          ? null
          : Skill.fromJson(json['skill'] as Map<String, dynamic>),
      isOverride: json['is_override'] as bool? ?? false,
    );

Map<String, dynamic> _$$LevelSkillImplToJson(_$LevelSkillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level_id': instance.levelId,
      'student_profile_id': instance.studentProfileId,
      'sort_order': instance.sortOrder,
      'skill': instance.skill,
      'is_override': instance.isOverride,
    };

_$SkillImpl _$$SkillImplFromJson(Map<String, dynamic> json) => _$SkillImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  category: json['category'] as String?,
);

Map<String, dynamic> _$$SkillImplToJson(_$SkillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
    };
