import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/review/data/mock_venue_review_repository.dart';
import 'package:hyperarena/features/review/data/models/venue_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/venue_review.dart';
import 'package:hyperarena/features/review/data/venue_review_repository.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

// ── DI ──────────────────────────────────────────────────────────

final venueReviewRepositoryProvider = Provider<VenueReviewRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return MockVenueReviewRepository(config);
});

// ── Venue reviews (all reviews for a venue — PUBLIC) ────────────

final venueReviewsProvider =
    FutureProvider.family<List<VenueReview>, String>((ref, venueId) async {
  final repo = ref.watch(venueReviewRepositoryProvider);
  return repo.getVenueReviews(venueId);
});

// ── Player's venue reviews (reviews they wrote) ─────────────────

final playerVenueReviewsProvider =
    FutureProvider.family<List<VenueReview>, String>((ref, playerId) async {
  final repo = ref.watch(venueReviewRepositoryProvider);
  return repo.getPlayerVenueReviews(playerId);
});

// ── Has reviewed booking check ──────────────────────────────────

final hasReviewedBookingProvider = FutureProvider.family<bool,
    ({String reviewerId, String bookingId})>((ref, params) async {
  final repo = ref.watch(venueReviewRepositoryProvider);
  return repo.hasReviewedBooking(
    reviewerId: params.reviewerId,
    bookingId: params.bookingId,
  );
});

// ── Venue aggregate rating ──────────────────────────────────────

final venueRatingProvider =
    FutureProvider.family<VenueRatingAggregate, String>((ref, venueId) async {
  final repo = ref.watch(venueReviewRepositoryProvider);
  return repo.getVenueRating(venueId);
});
