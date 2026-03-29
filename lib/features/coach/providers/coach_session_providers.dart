import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

// ── Repository ──────────────────────────────────────────

final coachSessionRepoProvider =
    Provider<ApiCoachSessionRepository>((ref) {
  return ApiCoachSessionRepository(ref.watch(apiClientProvider));
});

// ── Session list state ──────────────────────────────────

class CoachSessionListState {
  final List<CoachSession> items;
  final int currentPage;
  final int lastPage;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const CoachSessionListState({
    this.items = const [],
    this.currentPage = 0,
    this.lastPage = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => currentPage < lastPage;
  bool get isEmpty => items.isEmpty && !isLoading;

  CoachSessionListState copyWith({
    List<CoachSession>? items,
    int? currentPage,
    int? lastPage,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
  }) {
    return CoachSessionListState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
    );
  }
}

final coachSessionListProvider = NotifierProvider<
    CoachSessionListNotifier, CoachSessionListState>(
    CoachSessionListNotifier.new);

class CoachSessionListNotifier extends Notifier<CoachSessionListState> {
  @override
  CoachSessionListState build() {
    Future.microtask(() => loadInitial());
    return const CoachSessionListState(isLoading: true);
  }

  Future<void> loadInitial() async {
    state = const CoachSessionListState(isLoading: true);
    try {
      final repo = ref.read(coachSessionRepoProvider);
      final page = await repo.getSessions();
      state = CoachSessionListState(
        items: page.items,
        currentPage: page.currentPage,
        lastPage: page.lastPage,
      );
    } catch (e) {
      state = CoachSessionListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final repo = ref.read(coachSessionRepoProvider);
      final page = await repo.getSessions(page: state.currentPage + 1);
      state = state.copyWith(
        items: [...state.items, ...page.items],
        currentPage: page.currentPage,
        lastPage: page.lastPage,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Session detail ──────────────────────────────────────

final coachSessionDetailProvider =
    FutureProvider.family<CoachSession, String>((ref, id) async {
  final repo = ref.watch(coachSessionRepoProvider);
  return repo.getSessionDetail(int.parse(id));
});

// ── Attendance local state ──────────────────────────────

/// Maps student_profile_id → status (present/absent/late).
/// Pre-loaded from existing attendances, mutated locally, then bulk-saved.
final attendanceLocalStateProvider =
    StateProvider.family<Map<String, String>, String>(
  (ref, sessionId) => {},
);
