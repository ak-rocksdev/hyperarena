// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_student_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminStudentSummaryImpl _$$AdminStudentSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$AdminStudentSummaryImpl(
  id: idFromJson(json['id']),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  gender: json['gender'] as String?,
  photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$AdminStudentSummaryImplToJson(
  _$AdminStudentSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'gender': instance.gender,
  'photo_urls': instance.photoUrls,
  'created_at': instance.createdAt?.toIso8601String(),
};
