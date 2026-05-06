// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoringConfigImpl _$$ScoringConfigImplFromJson(
  Map<String, dynamic> json,
) => _$ScoringConfigImpl(
  sessionScoringType: json['session_scoring_type'] as String? ?? 'status',
  skillScoringType: json['skill_scoring_type'] as String? ?? 'status',
  showNumericToMembers: json['show_numeric_to_members'] as bool? ?? true,
  sessionLabels: json['session_labels'] == null
      ? const ScoringLabels()
      : ScoringLabels.fromJson(json['session_labels'] as Map<String, dynamic>),
  skillLabels: json['skill_labels'] == null
      ? const ScoringLabels()
      : ScoringLabels.fromJson(json['skill_labels'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ScoringConfigImplToJson(_$ScoringConfigImpl instance) =>
    <String, dynamic>{
      'session_scoring_type': instance.sessionScoringType,
      'skill_scoring_type': instance.skillScoringType,
      'show_numeric_to_members': instance.showNumericToMembers,
      'session_labels': instance.sessionLabels,
      'skill_labels': instance.skillLabels,
    };

_$ScoringLabelsImpl _$$ScoringLabelsImplFromJson(Map<String, dynamic> json) =>
    _$ScoringLabelsImpl(
      status:
          (json['status'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      numeric:
          (json['numeric'] as List<dynamic>?)
              ?.map((e) => NumericRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NumericRange>[],
    );

Map<String, dynamic> _$$ScoringLabelsImplToJson(_$ScoringLabelsImpl instance) =>
    <String, dynamic>{'status': instance.status, 'numeric': instance.numeric};

_$NumericRangeImpl _$$NumericRangeImplFromJson(Map<String, dynamic> json) =>
    _$NumericRangeImpl(
      min: (json['min'] as num).toInt(),
      max: (json['max'] as num).toInt(),
      label: json['label'] as String,
      color: json['color'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$NumericRangeImplToJson(_$NumericRangeImpl instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'label': instance.label,
      'color': instance.color,
      'status': instance.status,
    };
