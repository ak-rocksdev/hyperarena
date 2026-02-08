// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_rating_aggregate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachRatingAggregateImpl _$$CoachRatingAggregateImplFromJson(
  Map<String, dynamic> json,
) => _$CoachRatingAggregateImpl(
  coachId: json['coach_id'] as String,
  averageRating: (json['average_rating'] as num).toDouble(),
  totalReviews: (json['total_reviews'] as num).toInt(),
  distribution:
      (json['distribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$$CoachRatingAggregateImplToJson(
  _$CoachRatingAggregateImpl instance,
) => <String, dynamic>{
  'coach_id': instance.coachId,
  'average_rating': instance.averageRating,
  'total_reviews': instance.totalReviews,
  'distribution': instance.distribution.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
};
