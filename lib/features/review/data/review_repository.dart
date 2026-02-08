import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getCoachReviews(String coachId);
  Future<List<Review>> getPlayerReviews(String reviewerId);
  Future<List<Review>> getSessionReviews(String sessionId);
  Future<bool> hasReviewed({
    required String reviewerId,
    required String sessionId,
  });
  Future<Review> submitReview({
    required String coachId,
    required String sessionId,
    required int rating,
    String? comment,
  });
  Future<CoachRatingAggregate> getCoachRating(String coachId);
}
