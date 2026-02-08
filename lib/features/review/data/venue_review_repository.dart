import 'package:hyperarena/features/review/data/models/venue_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/venue_review.dart';

abstract class VenueReviewRepository {
  Future<List<VenueReview>> getVenueReviews(String venueId);
  Future<List<VenueReview>> getPlayerVenueReviews(String reviewerId);
  Future<bool> hasReviewedBooking({
    required String reviewerId,
    required String bookingId,
  });
  Future<VenueReview> submitVenueReview({
    required String venueId,
    required String bookingId,
    required int rating,
    String? comment,
  });
  Future<VenueRatingAggregate> getVenueRating(String venueId);
}
