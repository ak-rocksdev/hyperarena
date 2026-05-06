import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/api_coach_enrollment_repository.dart';
import 'package:hyperarena/features/coach/data/api_coach_program_repository.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/features/coach/data/models/enrollment.dart';
import 'package:hyperarena/features/coach/data/models/level_skill.dart';
import 'package:hyperarena/features/coach/data/models/program.dart';
import 'package:hyperarena/features/coach/data/models/session_progress_detail.dart';
import 'package:hyperarena/features/coach/data/models/session_recommendation.dart';
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

// ── Grading ─────────────────────────────────────────────

final coachEnrollmentRepoProvider =
    Provider<ApiCoachEnrollmentRepository>((ref) {
  return ApiCoachEnrollmentRepository(ref.watch(apiClientProvider));
});

final coachProgramRepoProvider = Provider<ApiCoachProgramRepository>((ref) {
  return ApiCoachProgramRepository(ref.watch(apiClientProvider));
});

/// Active enrollment for one student. `null` when not enrolled.
final coachStudentEnrollmentProvider =
    FutureProvider.family<Enrollment?, int>((ref, studentProfileId) async {
  final repo = ref.watch(coachEnrollmentRepoProvider);
  return repo.getActiveForStudent(studentProfileId);
});

/// Standard level skills + per-student personal overrides, merged into one
/// list ordered by sort_order. Used by the grading panel.
final coachStudentLevelSkillsProvider = FutureProvider.family<
    List<LevelSkill>, ({int studentProfileId, int levelId})>((ref, k) async {
  final repo = ref.watch(coachEnrollmentRepoProvider);
  final results = await Future.wait([
    repo.getLevelSkills(k.levelId),
    // Overrides are best-effort: a 403/404 just means the student has no
    // personal skills configured. Swallow + return empty to keep the panel
    // rendering with the standard list.
    repo
        .getStudentOverrides(
            studentProfileId: k.studentProfileId, levelId: k.levelId)
        .catchError((_) => <LevelSkill>[]),
  ]);
  final all = [...results[0], ...results[1]];
  all.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return all;
});

/// Existing session_progress + skill_progress for a session — hydrates the
/// grading drafts on first render.
final coachSessionProgressProvider =
    FutureProvider.family<SessionProgressDetail, String>(
        (ref, sessionId) async {
  final repo = ref.watch(coachSessionRepoProvider);
  try {
    return await repo.getSessionProgress(int.parse(sessionId));
  } catch (_) {
    // No progress yet — render an empty detail rather than an error state.
    return const SessionProgressDetail();
  }
});

/// "Fokus yang Disarankan" panel data. Errors are swallowed (panel just
/// won't render).
final coachSessionRecommendationsProvider =
    FutureProvider.family<List<SessionRecommendation>, String>(
        (ref, sessionId) async {
  final repo = ref.watch(coachSessionRepoProvider);
  try {
    return await repo.getRecommendations(int.parse(sessionId));
  } catch (_) {
    return const [];
  }
});

/// Programs available for enrollment (cached for the dialog dropdown).
final coachProgramsProvider = FutureProvider<List<Program>>((ref) async {
  final repo = ref.watch(coachProgramRepoProvider);
  return repo.getPrograms();
});

/// Levels for one program — cascading dropdown on the enrollment dialog.
final coachProgramLevelsProvider =
    FutureProvider.family<List<ProgramLevel>, int>((ref, programId) async {
  final repo = ref.watch(coachProgramRepoProvider);
  return repo.getLevels(programId);
});
