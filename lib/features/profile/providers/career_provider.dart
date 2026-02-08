import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';

/// All assessments for a player, newest first.
final playerAssessmentsProvider =
    FutureProvider.family<List<Assessment>, String>((ref, studentId) async {
  final repo = ref.watch(coachRepositoryProvider);
  final all = await repo.getAssessments(studentId: studentId);
  return [...all]..sort((a, b) => b.date.compareTo(a.date));
});

/// Latest assessment per sport for a player.
final latestAssessmentPerSportProvider =
    FutureProvider.family<Map<Sport, Assessment>, String>(
        (ref, studentId) async {
  final all = await ref.watch(playerAssessmentsProvider(studentId).future);
  final map = <Sport, Assessment>{};
  for (final a in all) {
    map.putIfAbsent(a.sport, () => a);
  }
  return map;
});

/// Reviews written by a player (for the review history tab).
final playerWrittenReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, playerId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.getPlayerReviews(playerId);
});
