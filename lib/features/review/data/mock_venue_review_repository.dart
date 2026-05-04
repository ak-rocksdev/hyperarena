import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/features/review/data/models/venue_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/venue_review.dart';
import 'package:hyperarena/features/review/data/venue_review_repository.dart';

class MockVenueReviewRepository implements VenueReviewRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  static const _currentPlayerId = 'user-001';
  static const _currentPlayerName = 'Budi Santoso';

  MockVenueReviewRepository();

  @override
  Future<List<VenueReview>> getVenueReviews(String venueId) async {
    await Future.delayed(_delay);
    return MockData.venueReviews.where((r) => r.venueId == venueId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<VenueReview>> getPlayerVenueReviews(String reviewerId) async {
    await Future.delayed(_delay);
    return MockData.venueReviews
        .where((r) => r.reviewerId == reviewerId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<bool> hasReviewedBooking({
    required String reviewerId,
    required String bookingId,
  }) async {
    await Future.delayed(_delay);
    return MockData.venueReviews.any(
      (r) => r.reviewerId == reviewerId && r.bookingId == bookingId,
    );
  }

  @override
  Future<VenueReview> submitVenueReview({
    required String venueId,
    required String bookingId,
    required int rating,
    String? comment,
  }) async {
    await Future.delayed(_delay);
    final booking = MockData.bookings.firstWhere((b) => b.id == bookingId);
    final review = VenueReview(
      id: 'vr-${DateTime.now().millisecondsSinceEpoch}',
      reviewerId: _currentPlayerId,
      reviewerName: _currentPlayerName,
      venueId: venueId,
      venueName: booking.venueName ?? '',
      bookingId: bookingId,
      courtName: booking.courtName,
      date: DateTime.now(),
      rating: rating,
      comment: comment,
    );
    MockData.addVenueReview(review);
    return review;
  }

  @override
  Future<VenueRatingAggregate> getVenueRating(String venueId) async {
    await Future.delayed(_delay);
    final reviews =
        MockData.venueReviews.where((r) => r.venueId == venueId).toList();
    if (reviews.isEmpty) {
      return VenueRatingAggregate(
        venueId: venueId,
        averageRating: 0,
        totalReviews: 0,
      );
    }
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    final distribution = <int, int>{};
    for (var star = 1; star <= 5; star++) {
      distribution[star] = reviews.where((r) => r.rating == star).length;
    }
    return VenueRatingAggregate(
      venueId: venueId,
      averageRating: total / reviews.length,
      totalReviews: reviews.length,
      distribution: distribution,
    );
  }
}
