import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_rating_aggregate.freezed.dart';
part 'venue_rating_aggregate.g.dart';

@freezed
class VenueRatingAggregate with _$VenueRatingAggregate {
  const factory VenueRatingAggregate({
    required String venueId,
    required double averageRating,
    required int totalReviews,
    @Default({}) Map<int, int> distribution,
  }) = _VenueRatingAggregate;

  factory VenueRatingAggregate.fromJson(Map<String, dynamic> json) =>
      _$VenueRatingAggregateFromJson(json);
}
