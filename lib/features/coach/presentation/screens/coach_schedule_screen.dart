import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';
import 'package:hyperarena/features/coach/providers/coach_session_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';

/// Coach's schedule tab screen with "Mendatang" (upcoming) and "Selesai" (done) tabs.
class CoachScheduleScreen extends ConsumerStatefulWidget {
  const CoachScheduleScreen({super.key});

  @override
  ConsumerState<CoachScheduleScreen> createState() =>
      _CoachScheduleScreenState();
}

class _CoachScheduleScreenState extends ConsumerState<CoachScheduleScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(coachSessionListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coachSessionListProvider);
    final filter =
        GoRouterState.of(context).uri.queryParameters['filter'];

    if (filter == 'unmarked' || filter == 'ungraded') {
      return _buildFilteredView(context, state, filter!);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal Coaching'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            labelStyle: AppTypography.labelMedium,
            unselectedLabelStyle: AppTypography.labelMedium,
            tabs: const [
              Tab(text: 'Mendatang'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: state.isLoading
            ? _buildShimmer()
            : state.error != null
                ? EmptyState(
                    icon: Icons.error_outline,
                    message: 'Gagal memuat jadwal',
                    actionLabel: 'Coba lagi',
                    onAction: () => ref
                        .read(coachSessionListProvider.notifier)
                        .loadInitial(),
                  )
                : TabBarView(
                    children: [
                      _SessionTab(
                        sessions: _upcoming(state.items),
                        isLoadingMore: state.isLoadingMore,
                        scrollController: _scrollController,
                        emptyText: 'Belum ada jadwal mendatang',
                        onRefresh: () => ref
                            .read(coachSessionListProvider.notifier)
                            .loadInitial(),
                      ),
                      _SessionTab(
                        sessions: _completed(state.items),
                        isLoadingMore: false,
                        scrollController: null,
                        emptyText: 'Belum ada riwayat sesi',
                        onRefresh: () => ref
                            .read(coachSessionListProvider.notifier)
                            .loadInitial(),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFilteredView(
    BuildContext context,
    CoachSessionListState state,
    String filter,
  ) {
    final wantedState =
        filter == 'unmarked' ? 'needs_attendance' : 'needs_grading';
    final bannerText = filter == 'unmarked'
        ? 'Menampilkan sesi yang perlu di-mark kehadirannya'
        : 'Menampilkan sesi yang perlu dinilai';
    final emptyMessage = filter == 'unmarked'
        ? 'Tidak ada sesi yang perlu di-mark'
        : 'Tidak ada sesi yang perlu dinilai';

    final filtered = state.items
        .where((s) => s.completionState == wantedState)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Coaching'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppDimensions.base),
            padding: const EdgeInsets.all(AppDimensions.base),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_alt, color: AppColors.warning),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    bannerText,
                    style: AppTypography.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/coach/schedule'),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? EmptyState(
                        icon: Icons.check_circle_outline,
                        message: emptyMessage,
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.screenHorizontal,
                          AppDimensions.screenHorizontal,
                          AppDimensions.screenHorizontal,
                          AppDimensions.xxxl,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppDimensions.md),
                          child: _CoachSessionCard(session: filtered[i]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
      itemCount: 4,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: ShimmerLoading.card(height: 100),
      ),
    );
  }

  /// Sessions still in their active window. A row drops to "Selesai" once
  /// either the BE flips status='completed' OR the wall-clock end time
  /// passes — whichever comes first. Without the time check, a session
  /// whose end-time passed an hour ago still shows up here until the BE
  /// auto-complete cron runs.
  List<CoachSession> _upcoming(List<CoachSession> all) {
    final now = DateTime.now();
    return all
        .where(
          (s) =>
              s.status != 'completed' &&
              s.status != 'cancelled' &&
              s.endAt.isAfter(now),
        )
        .toList();
  }

  /// Completed, cancelled, or end-time-passed sessions.
  List<CoachSession> _completed(List<CoachSession> all) {
    final now = DateTime.now();
    return all
        .where(
          (s) =>
              s.status == 'completed' ||
              s.status == 'cancelled' ||
              !s.endAt.isAfter(now),
        )
        .toList();
  }
}

class _SessionTab extends StatelessWidget {
  final List<CoachSession> sessions;
  final bool isLoadingMore;
  final ScrollController? scrollController;
  final String emptyText;
  final Future<void> Function() onRefresh;

  const _SessionTab({
    required this.sessions,
    required this.isLoadingMore,
    this.scrollController,
    required this.emptyText,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Empty state must also support pull-to-refresh — otherwise a coach
    // who lands on an empty tab has no way to retry without leaving and
    // re-entering the screen.
    if (sessions.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 320,
              child: Center(
                child: Text(
                  emptyText,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        // Extra bottom padding so the last card has clear breathing room
        // above the bottom navigation bar instead of butting against it.
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontal,
          AppDimensions.screenHorizontal,
          AppDimensions.screenHorizontal,
          AppDimensions.xxxl,
        ),
        itemCount: sessions.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= sessions.length) {
            return const ListLoadingIndicator();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: _CoachSessionCard(session: sessions[i]),
          );
        },
      ),
    );
  }
}

class _CoachSessionCard extends StatelessWidget {
  final CoachSession session;
  const _CoachSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.coachSessionDetail(session.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 16:9 hero — falls back to tenant logo when session has no
            // photo. Listing card uses md (640×360) per BE size guidance.
            SessionHero(
              photoUrls: session.photoUrls,
              photoPath: session.photoPath,
              size: SessionHeroSize.md,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + type chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(session.safeTitle,
                            style: AppTypography.titleMedium),
                      ),
                  if (session.type != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        _typeLabel(session.type!),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),

              // Venue
              if (session.venue != null) ...[
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.venue!.name,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppDimensions.sm),

              // Date/time + capacity
              Row(
                children: [
                  Icon(Icons.schedule,
                      size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    // session.startAt is already in tenant wall-clock —
                    // tenantWallClockFromJson preserves BE's offset components.
                    Formatters.formatDateTimeCompact(session.startAt),
                    style: AppTypography.bodySmall,
                  ),
                  const Spacer(),
                  Icon(Icons.people_outline,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${session.bookedStudentsCount}/${session.capacity}',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(String type) => switch (type) {
        'private' => 'Privat',
        'group' => 'Grup',
        'clinic' => 'Klinik',
        _ => type,
      };
}
