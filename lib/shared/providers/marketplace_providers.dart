import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/api_marketplace_coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/session/data/api_marketplace_session_repository.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session_detail.dart';
import 'package:hyperarena/features/venue/data/api_marketplace_venue_repository.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/shared/data/api_sport_repository.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';
import 'package:hyperarena/shared/data/models/sport_filter.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

// ── Repository providers ──────────────────────────────────

final marketplaceVenueRepoProvider = Provider<ApiMarketplaceVenueRepository>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiMarketplaceVenueRepository(apiClient);
});

final marketplaceSessionRepoProvider =
    Provider<ApiMarketplaceSessionRepository>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return ApiMarketplaceSessionRepository(apiClient);
    });

final marketplaceCoachRepoProvider = Provider<ApiMarketplaceCoachRepository>((
  ref,
) {
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
      SportFiltersNotifier.new,
    );

class SportFiltersNotifier extends AsyncNotifier<List<SportFilter>> {
  @override
  Future<List<SportFilter>> build() async {
    final repo = ref.read(sportRepoProvider);
    // Return cache immediately, refresh in background
    final cached = repo.getCached();
    if (cached.isNotEmpty) {
      // Fire-and-forget refresh
      repo
          .fetchAndCache()
          .then((fresh) {
            if (state.hasValue) state = AsyncData(fresh);
          })
          .catchError((_) {});
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
  final Object? error;

  /// Set when a `loadMore` page fails. Surfaces as a retry tile at the
  /// list footer; the next successful `loadMore` clears it.
  final Object? loadMoreError;

  const MarketplaceListState({
    this.items = const [],
    this.nextCursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
  });

  bool get hasMore => nextCursor != null;
  bool get isEmpty => items.isEmpty && !isLoading;

  MarketplaceListState<T> copyWith({
    List<T>? items,
    String? Function()? nextCursor,
    bool? isLoading,
    bool? isLoadingMore,
    Object? Function()? error,
    Object? Function()? loadMoreError,
  }) {
    return MarketplaceListState(
      items: items ?? this.items,
      nextCursor: nextCursor != null ? nextCursor() : this.nextCursor,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error != null ? error() : this.error,
      loadMoreError: loadMoreError != null
          ? loadMoreError()
          : this.loadMoreError,
    );
  }
}

/// Base notifier for the 3 marketplace browse lists (Sesi/Lapangan/Coach).
/// Subclasses only have to bind a [fetchPage] hook to their repo's pagination
/// method — every other state transition (initial load, load-more, retry,
/// gating) lives here so the 3 lists can't drift.
abstract class MarketplaceListNotifier<T>
    extends Notifier<MarketplaceListState<T>> {
  String? _searchQuery;

  /// Fetch a single page. `cursor == null` means initial/refresh; the
  /// `prioritizeTenantSlug` is only honored on the initial page (BE
  /// rejects it combined with cursor).
  Future<CursorPage<T>> fetchPage({
    int? sportId,
    String? search,
    String? cursor,
    String? prioritizeTenantSlug,
  });

  @override
  MarketplaceListState<T> build() {
    ref.watch(selectedSportIdProvider);
    Future.microtask(loadInitial);
    return const MarketplaceListState(isLoading: true);
  }

  Future<void> loadInitial({String? search}) async {
    if (search != null) _searchQuery = search;
    state = const MarketplaceListState(isLoading: true);
    try {
      final page = await fetchPage(
        sportId: ref.read(selectedSportIdProvider),
        search: _searchQuery,
        prioritizeTenantSlug: ref.read(tenantSlugProvider),
      );
      state = MarketplaceListState(
        items: page.items,
        nextCursor: page.nextCursor,
      );
    } catch (e) {
      state = MarketplaceListState(error: e);
    }
  }

  /// User-driven retry (footer "Coba Lagi" button). Clears the gate so
  /// [loadMore] can fire again.
  Future<void> retryLoadMore() async {
    state = state.copyWith(loadMoreError: () => null);
    await loadMore();
  }

  Future<void> loadMore() async {
    // Gate on loadMoreError so the scroll listener can't silently
    // re-fire the same failing request — only [retryLoadMore] clears it.
    if (state.isLoadingMore || !state.hasMore || state.loadMoreError != null) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await fetchPage(
        sportId: ref.read(selectedSportIdProvider),
        search: _searchQuery,
        cursor: state.nextCursor,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        nextCursor: () => page.nextCursor,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, loadMoreError: () => e);
    }
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

final marketplaceVenueListProvider =
    NotifierProvider<
      MarketplaceVenueListNotifier,
      MarketplaceListState<MarketplaceVenue>
    >(MarketplaceVenueListNotifier.new);

class MarketplaceVenueListNotifier
    extends MarketplaceListNotifier<MarketplaceVenue> {
  @override
  Future<CursorPage<MarketplaceVenue>> fetchPage({
    int? sportId,
    String? search,
    String? cursor,
    String? prioritizeTenantSlug,
  }) => ref
      .read(marketplaceVenueRepoProvider)
      .getVenues(
        sportId: sportId,
        search: search,
        cursor: cursor,
        prioritizeTenantSlug: prioritizeTenantSlug,
      );
}

// ── Session list notifier ─────────────────────────────────

final marketplaceSessionListProvider =
    NotifierProvider<
      MarketplaceSessionListNotifier,
      MarketplaceListState<MarketplaceSession>
    >(MarketplaceSessionListNotifier.new);

class MarketplaceSessionListNotifier
    extends MarketplaceListNotifier<MarketplaceSession> {
  @override
  Future<CursorPage<MarketplaceSession>> fetchPage({
    int? sportId,
    String? search,
    String? cursor,
    String? prioritizeTenantSlug,
  }) => ref
      .read(marketplaceSessionRepoProvider)
      .getSessions(
        sportId: sportId,
        search: search,
        cursor: cursor,
        prioritizeTenantSlug: prioritizeTenantSlug,
      );
}

// ── Coach list notifier ───────────────────────────────────

final marketplaceCoachListProvider =
    NotifierProvider<
      MarketplaceCoachListNotifier,
      MarketplaceListState<MarketplaceCoach>
    >(MarketplaceCoachListNotifier.new);

class MarketplaceCoachListNotifier
    extends MarketplaceListNotifier<MarketplaceCoach> {
  @override
  Future<CursorPage<MarketplaceCoach>> fetchPage({
    int? sportId,
    String? search,
    String? cursor,
    String? prioritizeTenantSlug,
  }) => ref
      .read(marketplaceCoachRepoProvider)
      .getCoaches(
        sportId: sportId,
        search: search,
        cursor: cursor,
        prioritizeTenantSlug: prioritizeTenantSlug,
      );
}
