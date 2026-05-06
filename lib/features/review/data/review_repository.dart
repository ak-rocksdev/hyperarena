import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';

/// Coach review repository.
/// - Player-facing: [submitReview], [getMyReview], [getPlayerReviews].
/// - Admin-facing: [getCoachReviews], [getCoachRating] — backed by
///   `/v1/admin/...` endpoints. Coach role must never call these; the BE
///   returns 403 if a non-admin reaches them.
abstract class ReviewRepository {
  /// Returns the student's review for [sessionId], or `null` if none.
  Future<Review?> getMyReview(String sessionId);

  /// Returns the student's review history (first 20 items).
  Future<List<Review>> getPlayerReviews();

  /// One-shot submit. BE enforces: session past, student attended, no prior
  /// review for `(coach, student, session)`.
  Future<Review> submitReview({
    required String sessionId,
    required String coachId,
    required int rating,
    String? comment,
  });

  /// Admin-only.
  Future<List<Review>> getCoachReviews(String coachId);

  /// Admin-only.
  Future<CoachRatingAggregate> getCoachRating(String coachId);
}
