import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_rating_aggregate.freezed.dart';
part 'coach_rating_aggregate.g.dart';

@freezed
class CoachRatingAggregate with _$CoachRatingAggregate {
  const factory CoachRatingAggregate({
    required String coachId,
    required double averageRating,
    required int totalReviews,
    @Default({}) Map<int, int> distribution,
  }) = _CoachRatingAggregate;

  factory CoachRatingAggregate.fromJson(Map<String, dynamic> json) =>
      _$CoachRatingAggregateFromJson(json);
}
