import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/review/data/mock_review_repository.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/review_repository.dart';
// ── DI ──────────────────────────────────────────────────────────

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return MockReviewRepository();
});

// ── Coach reviews (coach views their own reviews) ───────────────

final coachReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachReviews(coachId);
});

// ── Player reviews (player views reviews they wrote) ────────────

final myReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, playerId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getPlayerReviews(playerId);
});

// ── Session reviews ─────────────────────────────────────────────

final sessionReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, sessionId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getSessionReviews(sessionId);
});

// ── Has reviewed check ──────────────────────────────────────────

final hasReviewedProvider = FutureProvider.family<bool,
    ({String reviewerId, String sessionId})>((ref, params) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.hasReviewed(
    reviewerId: params.reviewerId,
    sessionId: params.sessionId,
  );
});

// ── Coach aggregate rating (public-safe) ────────────────────────

final coachRatingProvider =
    FutureProvider.family<CoachRatingAggregate, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachRating(coachId);
});
