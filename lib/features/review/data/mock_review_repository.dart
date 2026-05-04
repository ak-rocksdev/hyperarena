import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/review_repository.dart';

class MockReviewRepository implements ReviewRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  static const _currentPlayerId = 'user-001';
  static const _currentPlayerName = 'Budi Santoso';

  MockReviewRepository();

  @override
  Future<List<Review>> getCoachReviews(String coachId) async {
    await Future.delayed(_delay);
    return MockData.reviews.where((r) => r.coachId == coachId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Review>> getPlayerReviews(String reviewerId) async {
    await Future.delayed(_delay);
    return MockData.reviews.where((r) => r.reviewerId == reviewerId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Review>> getSessionReviews(String sessionId) async {
    await Future.delayed(_delay);
    return MockData.reviews.where((r) => r.sessionId == sessionId).toList();
  }

  @override
  Future<bool> hasReviewed({
    required String reviewerId,
    required String sessionId,
  }) async {
    await Future.delayed(_delay);
    return MockData.reviews.any(
      (r) => r.reviewerId == reviewerId && r.sessionId == sessionId,
    );
  }

  @override
  Future<Review> submitReview({
    required String coachId,
    required String sessionId,
    required int rating,
    String? comment,
  }) async {
    await Future.delayed(_delay);
    final session = MockData.sessions.firstWhere((s) => s.id == sessionId);
    final coach = MockData.coaches.firstWhere((c) => c.id == coachId);
    final review = Review(
      id: 'review-${DateTime.now().millisecondsSinceEpoch}',
      reviewerId: _currentPlayerId,
      reviewerName: _currentPlayerName,
      coachId: coachId,
      coachName: coach.name,
      sessionId: sessionId,
      sessionTitle: session.title,
      sport: session.sport,
      date: DateTime.now(),
      rating: rating,
      comment: comment,
    );
    MockData.addReview(review);
    return review;
  }

  @override
  Future<CoachRatingAggregate> getCoachRating(String coachId) async {
    await Future.delayed(_delay);
    final reviews =
        MockData.reviews.where((r) => r.coachId == coachId).toList();
    if (reviews.isEmpty) {
      return CoachRatingAggregate(
        coachId: coachId,
        averageRating: 0,
        totalReviews: 0,
      );
    }
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    final distribution = <int, int>{};
    for (var star = 1; star <= 5; star++) {
      distribution[star] = reviews.where((r) => r.rating == star).length;
    }
    return CoachRatingAggregate(
      coachId: coachId,
      averageRating: total / reviews.length,
      totalReviews: reviews.length,
      distribution: distribution,
    );
  }
}
