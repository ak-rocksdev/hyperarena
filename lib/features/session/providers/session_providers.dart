import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/mock_session_repository.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/session_repository.dart';
// ── DI ──────────────────────────────────────────────────────────

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return MockSessionRepository();
});

// ── Filter state ────────────────────────────────────────────────

final sessionFilterProvider =
    NotifierProvider<SessionFilterNotifier, Sport?>(SessionFilterNotifier.new);

class SessionFilterNotifier extends Notifier<Sport?> {
  @override
  Sport? build() => null;

  void setSport(Sport? sport) {
    state = state == sport ? null : sport;
  }

  void reset() => state = null;
}

// ── Session list ────────────────────────────────────────────────

final sessionListProvider = FutureProvider<List<OpenSession>>((ref) {
  final repo = ref.watch(sessionRepositoryProvider);
  final sport = ref.watch(sessionFilterProvider);
  return repo.getSessions(sport: sport);
});
