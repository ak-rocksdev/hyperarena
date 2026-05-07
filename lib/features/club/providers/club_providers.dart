import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/club/data/api_club_repository.dart';
import 'package:hyperarena/features/club/data/models/admin_student_roster_item.dart';
import 'package:hyperarena/features/club/data/models/club_summary.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final clubRepositoryProvider = Provider<ApiClubRepository>((ref) {
  return ApiClubRepository(ref.watch(apiClientProvider));
});

/// 19.4 — Klub hero + vital stats.
final clubSummaryProvider = FutureProvider<ClubSummary>((ref) async {
  return ref.watch(clubRepositoryProvider).getClubSummary();
});

/// 19.1 — coach roster list state, cursor-paginated. The screen reads
/// this and calls `loadMore()` from a scroll listener.
class CoachStudentsListState {
  final List<CoachStudentRosterItem> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const CoachStudentsListState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;

  CoachStudentsListState copyWith({
    List<CoachStudentRosterItem>? items,
    String? Function()? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
  }) {
    return CoachStudentsListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
    );
  }
}

final coachStudentsListProvider = NotifierProvider<CoachStudentsListNotifier,
    CoachStudentsListState>(CoachStudentsListNotifier.new);

class CoachStudentsListNotifier extends Notifier<CoachStudentsListState> {
  String? _searchQuery;

  @override
  CoachStudentsListState build() {
    Future.microtask(loadInitial);
    return const CoachStudentsListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    if (search != null) _searchQuery = search;
    state = const CoachStudentsListState(isLoading: true);
    try {
      final page = await ref
          .read(clubRepositoryProvider)
          .getCoachStudents(search: _searchQuery);
      state = CoachStudentsListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = CoachStudentsListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await ref.read(clubRepositoryProvider).getCoachStudents(
            cursor: state.nextCursor,
            search: _searchQuery,
          );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

/// 19.2 — coach-scope student detail (read-only profile).
final coachStudentDetailProvider =
    FutureProvider.family<StudentDetail, int>((ref, studentProfileId) async {
  return ref
      .read(clubRepositoryProvider)
      .getCoachStudentDetail(studentProfileId);
});

/// 19.3 — admin-scope student detail (adds financial sections).
final adminStudentDetailProvider =
    FutureProvider.family<AdminStudentDetail, int>(
        (ref, studentProfileId) async {
  return ref
      .read(clubRepositoryProvider)
      .getAdminStudentDetail(studentProfileId);
});

/// 19.5 — tenant-wide roster for the organizer Klub list, cursor-paginated.
/// Search lives in state so `loadMore()` continues the same query.
class AdminRosterListState {
  final List<AdminStudentRosterItem> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String search;

  const AdminRosterListState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.search = '',
  });

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;

  AdminRosterListState copyWith({
    List<AdminStudentRosterItem>? items,
    String? Function()? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
    String? search,
  }) {
    return AdminRosterListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
      search: search ?? this.search,
    );
  }
}

final adminRosterListProvider =
    NotifierProvider<AdminRosterListNotifier, AdminRosterListState>(
  AdminRosterListNotifier.new,
);

class AdminRosterListNotifier extends Notifier<AdminRosterListState> {
  @override
  AdminRosterListState build() {
    Future.microtask(loadInitial);
    return const AdminRosterListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    final query = search ?? state.search;
    state = AdminRosterListState(isLoading: true, search: query);
    try {
      final page = await ref
          .read(clubRepositoryProvider)
          .getAdminRoster(search: query.isEmpty ? null : query);
      state = AdminRosterListState(
        items: page.items,
        nextCursor: page.nextCursor,
        search: query,
      );
    } catch (e) {
      state = AdminRosterListState(error: e.toString(), search: query);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await ref.read(clubRepositoryProvider).getAdminRoster(
            cursor: state.nextCursor,
            search: state.search.isEmpty ? null : state.search,
          );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

typedef CoachStudentsPage = CursorPage<CoachStudentRosterItem>;
typedef AdminRosterPage = CursorPage<AdminStudentRosterItem>;
