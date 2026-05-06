// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_progress_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionProgressDetailImpl _$$SessionProgressDetailImplFromJson(
  Map<String, dynamic> json,
) => _$SessionProgressDetailImpl(
  sessionProgress:
      (json['session_progress'] as List<dynamic>?)
          ?.map((e) => SessionProgressEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SessionProgressEntry>[],
  skillProgress:
      (json['skill_progress'] as List<dynamic>?)
          ?.map((e) => SkillProgressEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SkillProgressEntry>[],
);

Map<String, dynamic> _$$SessionProgressDetailImplToJson(
  _$SessionProgressDetailImpl instance,
) => <String, dynamic>{
  'session_progress': instance.sessionProgress,
  'skill_progress': instance.skillProgress,
};

_$SessionProgressEntryImpl _$$SessionProgressEntryImplFromJson(
  Map<String, dynamic> json,
) => _$SessionProgressEntryImpl(
  id: idFromJson(json['id']),
  studentProfileId: idFromJson(json['student_profile_id']),
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$SessionProgressEntryImplToJson(
  _$SessionProgressEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_profile_id': instance.studentProfileId,
  'status': instance.status,
  'score': instance.score,
  'notes': instance.notes,
};

_$SkillProgressEntryImpl _$$SkillProgressEntryImplFromJson(
  Map<String, dynamic> json,
) => _$SkillProgressEntryImpl(
  id: idFromJson(json['id']),
  studentProfileId: idFromJson(json['student_profile_id']),
  levelSkillId: idFromJson(json['level_skill_id']),
  status: json['status'] as String?,
  score: (json['score'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$SkillProgressEntryImplToJson(
  _$SkillProgressEntryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_profile_id': instance.studentProfileId,
  'level_skill_id': instance.levelSkillId,
  'status': instance.status,
  'score': instance.score,
  'notes': instance.notes,
};
