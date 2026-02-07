// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssessmentImpl _$$AssessmentImplFromJson(Map<String, dynamic> json) =>
    _$AssessmentImpl(
      id: json['id'] as String,
      coachId: json['coach_id'] as String,
      coachName: json['coach_name'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      sport: $enumDecode(_$SportEnumMap, json['sport']),
      date: DateTime.parse(json['date'] as String),
      technique: (json['technique'] as num).toInt(),
      stamina: (json['stamina'] as num).toInt(),
      tactics: (json['tactics'] as num).toInt(),
      mentality: (json['mentality'] as num).toInt(),
      consistency: (json['consistency'] as num).toInt(),
      notes: json['notes'] as String?,
      recommendedLevel:
          $enumDecodeNullable(_$LevelTierEnumMap, json['recommended_level']) ??
          LevelTier.rookie,
    );

Map<String, dynamic> _$$AssessmentImplToJson(_$AssessmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coach_id': instance.coachId,
      'coach_name': instance.coachName,
      'student_id': instance.studentId,
      'student_name': instance.studentName,
      'sport': _$SportEnumMap[instance.sport]!,
      'date': instance.date.toIso8601String(),
      'technique': instance.technique,
      'stamina': instance.stamina,
      'tactics': instance.tactics,
      'mentality': instance.mentality,
      'consistency': instance.consistency,
      'notes': instance.notes,
      'recommended_level': _$LevelTierEnumMap[instance.recommendedLevel]!,
    };

const _$SportEnumMap = {
  Sport.tennis: 'tennis',
  Sport.padel: 'padel',
  Sport.badminton: 'badminton',
  Sport.futsal: 'futsal',
  Sport.basketball: 'basketball',
  Sport.volleyball: 'volleyball',
  Sport.tableTennis: 'tableTennis',
};

const _$LevelTierEnumMap = {
  LevelTier.rookie: 'rookie',
  LevelTier.amateur: 'amateur',
  LevelTier.intermediate: 'intermediate',
  LevelTier.advanced: 'advanced',
  LevelTier.pro: 'pro',
};
