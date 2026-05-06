// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionRecommendationImpl _$$SessionRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$SessionRecommendationImpl(
  studentProfileId: nullableIdFromJson(json['student_profile_id']),
  studentName: json['student_name'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  skills:
      (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$$SessionRecommendationImplToJson(
  _$SessionRecommendationImpl instance,
) => <String, dynamic>{
  'student_profile_id': instance.studentProfileId,
  'student_name': instance.studentName,
  'title': instance.title,
  'description': instance.description,
  'skills': instance.skills,
};
