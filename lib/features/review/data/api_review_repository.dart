import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/review_repository.dart';

/// Live HTTP implementation of [ReviewRepository].
class ApiReviewRepository implements ReviewRepository {
  final ApiClient _api;
  ApiReviewRepository(this._api);

  @override
  Future<Review> submitReview({
    required String sessionId,
    required String coachId,
    required int rating,
    String? comment,
  }) async {
    final response = await _api.post(
      '/v1/coach/sessions/$sessionId/reviews',
      data: {
        // BE expects integer coach_id. Throws if upstream passes non-numeric —
        // that's a programming error, not a recoverable condition.
        'coach_id': int.parse(coachId),
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    return Review.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Review?> getMyReview(String sessionId) async {
    final response =
        await _api.get('/v1/coach/sessions/$sessionId/my-review');
    final data = response.data as Map<String, dynamic>;
    final review = data['review'];
    return review == null
        ? null
        : Review.fromJson(review as Map<String, dynamic>);
  }

  @override
  Future<List<Review>> getPlayerReviews() async {
    final response = await _api.get('/v1/me/reviews', queryParameters: {
      'per_page': 20,
    });
    final list = (response.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Review.fromListJson).toList();
  }

  /// Admin-only — wired against `/v1/admin/coaches/{id}/reviews`. Coach role
  /// must never call this; player marketplace surfaces should not either
  /// until a public-safe rating endpoint exists. See Issue 13 spec.
  @override
  Future<List<Review>> getCoachReviews(String coachId) async {
    final response =
        await _api.get('/v1/admin/coaches/$coachId/reviews', queryParameters: {
      'per_page': 20,
    });
    final list = (response.data['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Review.fromListJson).toList();
  }

  /// Admin-only — see [getCoachReviews] caveat.
  @override
  Future<CoachRatingAggregate> getCoachRating(String coachId) async {
    final response =
        await _api.get('/v1/admin/coaches/$coachId/reviews/aggregate');
    final data = response.data as Map<String, dynamic>;
    final distRaw = data['distribution'] as Map<String, dynamic>? ?? const {};
    final distribution = <int, int>{
      for (final entry in distRaw.entries)
        int.parse(entry.key): (entry.value as num).toInt(),
    };
    return CoachRatingAggregate(
      coachId: coachId,
      averageRating: (data['average_rating'] as num).toDouble(),
      totalReviews: data['count'] as int,
      distribution: distribution,
    );
  }
}
