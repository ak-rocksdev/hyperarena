import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/api_marketplace_coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/session/data/api_marketplace_session_repository.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session_detail.dart';
import 'package:hyperarena/features/venue/data/api_marketplace_venue_repository.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/api_sport_repository.dart';
import 'package:hyperarena/shared/data/models/sport_filter.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

// ── Repository providers ──────────────────────────────────

final marketplaceVenueRepoProvider =
    Provider<ApiMarketplaceVenueRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceVenueRepository(apiClient);
});

final marketplaceSessionRepoProvider =
    Provider<ApiMarketplaceSessionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceSessionRepository(apiClient);
});

final marketplaceCoachRepoProvider =
    Provider<ApiMarketplaceCoachRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceCoachRepository(apiClient);
});

final sportRepoProvider = Provider<ApiSportRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApiSportRepository(apiClient, prefs);
});

// ── Sport filter chips ────────────────────────────────────

final sportFiltersProvider =
    AsyncNotifierProvider<SportFiltersNotifier, List<SportFilter>>(
        SportFiltersNotifier.new);

class SportFiltersNotifier extends AsyncNotifier<List<SportFilter>> {
  @override
  Future<List<SportFilter>> build() async {
    final repo = ref.read(sportRepoProvider);
    // Return cache immediately, refresh in background
    final cached = repo.getCached();
    if (cached.isNotEmpty) {
      // Fire-and-forget refresh
      repo.fetchAndCache().then((fresh) {
        if (state.hasValue) state = AsyncData(fresh);
      }).catchError((_) {});
      return cached;
    }
    return repo.fetchAndCache();
  }
}

/// Currently selected sport filter (null = all sports).
final selectedSportIdProvider = StateProvider<int?>((ref) => null);

// ── Marketplace list state ────────────────────────────────

class MarketplaceListState<T> {
  final List<T> items;
  final String? nextCursor;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const MarketplaceListState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;

  MarketplaceListState<T> copyWith({
    List<T>? items,
    String? Function()? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    String? Function()? error,
  }) {
    return MarketplaceListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
    );
  }
}

// ── Session detail ────────────────────────────────────────

final marketplaceSessionDetailProvider =
    FutureProvider.family<MarketplaceSessionDetail, String>((ref, id) async {
  final repo = ref.watch(marketplaceSessionRepoProvider);
  return repo.getSessionDetail(int.parse(id));
});

// ── Venue detail ─────────────────────────────────────────

final marketplaceVenueDetailProvider =
    FutureProvider.family<MarketplaceVenue, String>((ref, id) async {
  final repo = ref.watch(marketplaceVenueRepoProvider);
  return repo.getVenueDetail(int.parse(id));
});

// ── Venue list notifier ───────────────────────────────────

final marketplaceVenueListProvider = NotifierProvider<
    MarketplaceVenueListNotifier,
    MarketplaceListState<MarketplaceVenue>>(MarketplaceVenueListNotifier.new);

class MarketplaceVenueListNotifier
    extends Notifier<MarketplaceListState<MarketplaceVenue>> {
  String? _searchQuery;

  @override
  MarketplaceListState<MarketplaceVenue> build() {
    // Auto-refresh when sport filter changes
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    if (search != null) _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceVenueRepoProvider);
      final page = await repo.getVenues(
        sportId: sportId,
        search: _searchQuery,
        prioritizeTenantSlug: ref.read(tenantSlugProvider),
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceVenueRepoProvider);
      final page = await repo.getVenues(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Session list notifier ─────────────────────────────────

final marketplaceSessionListProvider = NotifierProvider<
    MarketplaceSessionListNotifier,
    MarketplaceListState<MarketplaceSession>>(
    MarketplaceSessionListNotifier.new);

class MarketplaceSessionListNotifier
    extends Notifier<MarketplaceListState<MarketplaceSession>> {
  String? _searchQuery;

  @override
  MarketplaceListState<MarketplaceSession> build() {
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    if (search != null) _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceSessionRepoProvider);
      final page = await repo.getSessions(
        sportId: sportId,
        search: _searchQuery,
        prioritizeTenantSlug: ref.read(tenantSlugProvider),
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceSessionRepoProvider);
      final page = await repo.getSessions(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

// ── Coach list notifier ───────────────────────────────────

final marketplaceCoachListProvider = NotifierProvider<
    MarketplaceCoachListNotifier,
    MarketplaceListState<MarketplaceCoach>>(MarketplaceCoachListNotifier.new);

class MarketplaceCoachListNotifier
    extends Notifier<MarketplaceListState<MarketplaceCoach>> {
  String? _searchQuery;

  @override
  MarketplaceListState<MarketplaceCoach> build() {
    ref.watch(selectedSportIdProvider);
    Future.microtask(() => loadInitial());
    return const MarketplaceListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    if (search != null) _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceCoachRepoProvider);
      final page = await repo.getCoaches(
        sportId: sportId,
        search: _searchQuery,
        prioritizeTenantSlug: ref.read(tenantSlugProvider),
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final sportId = ref.read(selectedSportIdProvider);
      final repo = ref.read(marketplaceCoachRepoProvider);
      final page = await repo.getCoaches(
        sportId: sportId,
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}
