import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/review_repository.dart';

/// In-memory mock for unit tests. Production code uses [ApiReviewRepository].
class MockReviewRepository implements ReviewRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  final List<Review> _store = [];

  MockReviewRepository();

  @override
  Future<Review?> getMyReview(String sessionId) async {
    await Future.delayed(_delay);
    final index = _store.indexWhere((r) => r.sessionId == sessionId);
    return index == -1 ? null : _store[index];
  }

  @override
  Future<List<Review>> getPlayerReviews() async {
    await Future.delayed(_delay);
    return [..._store]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Review> submitReview({
    required String sessionId,
    required String coachId,
    required int rating,
    String? comment,
  }) async {
    await Future.delayed(_delay);
    final review = Review(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      coachId: coachId,
      sessionId: sessionId,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _store.add(review);
    return review;
  }

  @override
  Future<List<Review>> getCoachReviews(String coachId) async {
    await Future.delayed(_delay);
    return _store.where((r) => r.coachId == coachId).toList();
  }

  @override
  Future<CoachRatingAggregate> getCoachRating(String coachId) async {
    await Future.delayed(_delay);
    final reviews = _store.where((r) => r.coachId == coachId).toList();
    if (reviews.isEmpty) {
      return const CoachRatingAggregate(
        coachId: '',
        averageRating: 0,
        totalReviews: 0,
      );
    }
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    final distribution = <int, int>{
      for (var star = 1; star <= 5; star++)
        star: reviews.where((r) => r.rating == star).length,
    };
    return CoachRatingAggregate(
      coachId: coachId,
      averageRating: total / reviews.length,
      totalReviews: reviews.length,
      distribution: distribution,
    );
  }
}
