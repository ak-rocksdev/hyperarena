import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_review.freezed.dart';
part 'venue_review.g.dart';

@freezed
class VenueReview with _$VenueReview {
  const factory VenueReview({
    required String id,
    required String reviewerId,
    required String reviewerName,
    required String venueId,
    required String venueName,
    required String bookingId,
    String? courtName,
    required DateTime date,
    required int rating,
    String? comment,
  }) = _VenueReview;

  factory VenueReview.fromJson(Map<String, dynamic> json) =>
      _$VenueReviewFromJson(json);
}
