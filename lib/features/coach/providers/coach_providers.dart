import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/api_coach_repository.dart';
import 'package:hyperarena/features/coach/data/coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
// ── DI ──────────────────────────────────────────────────────────

final coachRepositoryProvider = Provider<CoachRepository>((ref) {
  return ApiCoachRepository(
    ref.watch(marketplaceCoachRepoProvider),
    ref.watch(coachSessionRepoProvider),
  );
});

// ── Filter state ────────────────────────────────────────────────

final coachFilterProvider =
    NotifierProvider<CoachFilterNotifier, Sport?>(CoachFilterNotifier.new);

class CoachFilterNotifier extends Notifier<Sport?> {
  @override
  Sport? build() => null;

  void setSport(Sport? sport) {
    state = state == sport ? null : sport;
  }

  void reset() => state = null;
}

// ── Coach list ──────────────────────────────────────────────────

final coachListProvider = FutureProvider<List<Coach>>((ref) {
  final repo = ref.watch(coachRepositoryProvider);
  final sport = ref.watch(coachFilterProvider);
  return repo.getCoaches(sport: sport);
});
