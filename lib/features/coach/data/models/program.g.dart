// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgramImpl _$$ProgramImplFromJson(Map<String, dynamic> json) =>
    _$ProgramImpl(
      id: idFromJson(json['id']),
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ProgramImplToJson(_$ProgramImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
    };

_$ProgramLevelImpl _$$ProgramLevelImplFromJson(Map<String, dynamic> json) =>
    _$ProgramLevelImpl(
      id: idFromJson(json['id']),
      programId: idFromJson(json['program_id']),
      name: json['name'] as String,
      description: json['description'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ProgramLevelImplToJson(_$ProgramLevelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'program_id': instance.programId,
      'name': instance.name,
      'description': instance.description,
      'sort_order': instance.sortOrder,
    };
