import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/features/coach/presentation/widgets/coach_card.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:intl/intl.dart';

class CoachListScreen extends ConsumerStatefulWidget {
  final String searchQuery;
  const CoachListScreen({super.key, this.searchQuery = ''});

  @override
  ConsumerState<CoachListScreen> createState() => _CoachListScreenState();
}

class _CoachListScreenState extends ConsumerState<CoachListScreen> {
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
      ref.read(marketplaceCoachListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final useMock = ref.watch(appConfigProvider).useMockData;
    return useMock ? _buildMock() : _buildApi();
  }

  // ── Mock mode (unchanged logic) ──────────────────────────

  Widget _buildMock() {
    final filter = ref.watch(coachFilterProvider);
    final coachList = ref.watch(coachListProvider);

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
                      ref.read(coachFilterProvider.notifier).setSport(sport),
                ),
              );
            }).toList(),
          ),
        ),

        // Coach list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(coachListProvider.future),
            child: AsyncValueWidget(
              value: coachList,
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                itemCount: 3,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 160),
                ),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(coachListProvider),
              ),
              data: (coaches) {
                final searchQuery = widget.searchQuery;
                var filtered = coaches;
                if (searchQuery.isNotEmpty) {
                  filtered = coaches
                      .where((c) =>
                          c.name.toLowerCase().contains(searchQuery) ||
                          c.city.toLowerCase().contains(searchQuery) ||
                          c.sports.any((s) =>
                              s.name.toLowerCase().contains(searchQuery)))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada coach ditemukan',
                    icon: Icons.school_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: CoachCard(coach: filtered[i]),
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
    final state = ref.watch(marketplaceCoachListProvider);

    if (state.isLoading) {
      return _buildShimmer(height: 160);
    }

    if (state.error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        message: 'Gagal memuat coach',
        actionLabel: 'Coba lagi',
        onAction: () =>
            ref.read(marketplaceCoachListProvider.notifier).loadInitial(),
      );
    }

    if (state.isEmpty) {
      return const EmptyState(
        icon: Icons.person_outlined,
        message: 'Belum ada coach tersedia',
      );
    }

    final items = state.items;
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(marketplaceCoachListProvider.notifier).loadInitial(),
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
          final coach = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: _MarketplaceCoachCard(coach: coach),
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

/// Lightweight card for API marketplace coaches.
class _MarketplaceCoachCard extends StatelessWidget {
  final MarketplaceCoach coach;
  const _MarketplaceCoachCard({required this.coach});

  static final _currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: coach.user?.photoPath != null
                  ? NetworkImage(coach.user!.photoPath!)
                  : null,
              child: coach.user?.photoPath == null
                  ? const Icon(Icons.person, size: 28)
                  : null,
            ),
            const SizedBox(width: AppDimensions.md),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.user?.name ?? 'Coach',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (coach.sport != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      coach.sport!.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  if (coach.bio != null && coach.bio!.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      coach.bio!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (coach.ratePerSession != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      '${_currencyFormat.format(coach.ratePerSession)}/sesi',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
