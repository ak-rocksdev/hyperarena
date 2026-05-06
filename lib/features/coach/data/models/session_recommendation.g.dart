// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionRecommendationImpl _$$SessionRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$SessionRecommendationImpl(
  studentProfileId: idFromJson(json['student_profile_id']),
  hasEnrollment: json['has_enrollment'] as bool? ?? false,
  programName: json['program_name'] as String?,
  levelName: json['level_name'] as String?,
  focus:
      (json['focus'] as List<dynamic>?)
          ?.map((e) => RecommendationSkill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecommendationSkill>[],
  introduce:
      (json['introduce'] as List<dynamic>?)
          ?.map((e) => RecommendationSkill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecommendationSkill>[],
  review:
      (json['review'] as List<dynamic>?)
          ?.map((e) => RecommendationSkill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecommendationSkill>[],
);

Map<String, dynamic> _$$SessionRecommendationImplToJson(
  _$SessionRecommendationImpl instance,
) => <String, dynamic>{
  'student_profile_id': instance.studentProfileId,
  'has_enrollment': instance.hasEnrollment,
  'program_name': instance.programName,
  'level_name': instance.levelName,
  'focus': instance.focus,
  'introduce': instance.introduce,
  'review': instance.review,
};

_$RecommendationSkillImpl _$$RecommendationSkillImplFromJson(
  Map<String, dynamic> json,
) => _$RecommendationSkillImpl(
  levelSkillId: idFromJson(json['level_skill_id']),
  skillName: json['skill_name'] as String,
  category: json['category'] as String?,
  lastStatus: json['last_status'] as String?,
  score: (json['score'] as num?)?.toInt(),
  lastPracticedAt: json['last_practiced_at'] as String?,
);

Map<String, dynamic> _$$RecommendationSkillImplToJson(
  _$RecommendationSkillImpl instance,
) => <String, dynamic>{
  'level_skill_id': instance.levelSkillId,
  'skill_name': instance.skillName,
  'category': instance.category,
  'last_status': instance.lastStatus,
  'score': instance.score,
  'last_practiced_at': instance.lastPracticedAt,
};
