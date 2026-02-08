// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_rating_aggregate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueRatingAggregateImpl _$$VenueRatingAggregateImplFromJson(
  Map<String, dynamic> json,
) => _$VenueRatingAggregateImpl(
  venueId: json['venue_id'] as String,
  averageRating: (json['average_rating'] as num).toDouble(),
  totalReviews: (json['total_reviews'] as num).toInt(),
  distribution:
      (json['distribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$$VenueRatingAggregateImplToJson(
  _$VenueRatingAggregateImpl instance,
) => <String, dynamic>{
  'venue_id': instance.venueId,
  'average_rating': instance.averageRating,
  'total_reviews': instance.totalReviews,
  'distribution': instance.distribution.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
};
