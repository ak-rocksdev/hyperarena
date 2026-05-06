import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/review/data/api_review_repository.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/review_repository.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

// ── DI ──────────────────────────────────────────────────────────

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ApiReviewRepository(ref.watch(apiClientProvider));
});

// ── Player-facing providers ─────────────────────────────────────

/// The current student's review for a specific session, or `null` if none.
/// Drives the post-session review banner's three-state UI.
final myReviewProvider =
    FutureProvider.family<Review?, String>((ref, sessionId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getMyReview(sessionId);
});

/// The current student's full review history (first 20 items).
final myReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getPlayerReviews();
});

// ── Admin-facing providers (deferred wire-up) ────────────────────
// These hit `/v1/admin/coaches/{id}/...` endpoints — only safe to read from
// admin role surfaces. Coach role MUST NOT consume these per Issue 13. The
// existing consumers (`coach_detail_screen`, `coach_review_list_screen`) are
// orphan/deferred admin-domain UI — they will throw 403 if reached as a
// player, which is the correct failure mode until proper admin gating lands.

final coachReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachReviews(coachId);
});

final coachRatingProvider =
    FutureProvider.family<CoachRatingAggregate, String>((ref, coachId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getCoachRating(coachId);
});
