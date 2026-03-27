import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/presentation/widgets/session_card.dart';
import 'package:hyperarena/features/session/providers/session_providers.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:intl/intl.dart';

class SessionListScreen extends ConsumerStatefulWidget {
  final String searchQuery;
  const SessionListScreen({super.key, this.searchQuery = ''});

  @override
  ConsumerState<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends ConsumerState<SessionListScreen> {
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
      ref.read(marketplaceSessionListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final useMock = ref.watch(appConfigProvider).useMockData;
    return useMock ? _buildMock() : _buildApi();
  }

  // ── Mock mode (unchanged logic) ──────────────────────────

  Widget _buildMock() {
    final filter = ref.watch(sessionFilterProvider);
    final sessionList = ref.watch(sessionListProvider);

    return Column(
      children: [
        // Sport filter chips
        SizedBox(
          height: AppDimensions.chipHeight + AppDimensions.base,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.sm,
            ),
            children: Sport.values.map((sport) {
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.sm),
                child: SportChipSelector(
                  sport: sport,
                  isSelected: filter == sport,
                  onToggle: (_) =>
                      ref.read(sessionFilterProvider.notifier).setSport(sport),
                ),
              );
            }).toList(),
          ),
        ),

        // Session list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(sessionListProvider.future),
            child: AsyncValueWidget(
              value: sessionList,
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                itemCount: 3,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 200),
                ),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(sessionListProvider),
              ),
              data: (sessions) {
                final searchQuery = widget.searchQuery;
                var filtered = sessions;
                if (searchQuery.isNotEmpty) {
                  filtered = sessions
                      .where((s) =>
                          s.title.toLowerCase().contains(searchQuery) ||
                          s.venueName.toLowerCase().contains(searchQuery) ||
                          s.hostName.toLowerCase().contains(searchQuery) ||
                          s.sport.name.toLowerCase().contains(searchQuery))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada sesi terbuka',
                    icon: Icons.groups_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: SessionCard(session: filtered[i]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── API mode ─────────────────────────────────────────────

  Widget _buildApi() {
    final state = ref.watch(marketplaceSessionListProvider);

    if (state.isLoading) {
      return _buildShimmer(height: 200);
    }

    if (state.error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        message: 'Gagal memuat sesi',
        actionLabel: 'Coba lagi',
        onAction: () =>
            ref.read(marketplaceSessionListProvider.notifier).loadInitial(),
      );
    }

    if (state.isEmpty) {
      return const EmptyState(
        icon: Icons.event_outlined,
        message: 'Belum ada sesi tersedia',
      );
    }

    final items = state.items;
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(marketplaceSessionListProvider.notifier).loadInitial(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal,
        ),
        itemCount: items.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= items.length) {
            return const ListLoadingIndicator();
          }
          final session = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: _MarketplaceSessionCard(session: session),
          );
        },
      ),
    );
  }

  Widget _buildShimmer({required double height}) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      itemCount: 3,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: ShimmerLoading.card(height: height),
      ),
    );
  }
}

/// Lightweight card for API marketplace sessions.
class _MarketplaceSessionCard extends StatelessWidget {
  final MarketplaceSession session;
  const _MarketplaceSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, d MMM yyyy • HH:mm', 'id');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.name, style: theme.textTheme.titleMedium),
            if (session.tenant != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                'oleh ${session.tenant!.name}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            if (session.venue != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      session.venue!.name,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppDimensions.sm),
            Row(
              children: [
                Icon(Icons.schedule,
                    size: 14, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(session.startAt.toLocal()),
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '${session.bookedCount}/${session.capacity} peserta',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
