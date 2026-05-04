import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';

class VenueListScreen extends ConsumerStatefulWidget {
  final String searchQuery;
  const VenueListScreen({super.key, this.searchQuery = ''});

  @override
  ConsumerState<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends ConsumerState<VenueListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant VenueListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      ref
          .read(marketplaceVenueListProvider.notifier)
          .loadInitial(search: widget.searchQuery);
    }
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
      ref.read(marketplaceVenueListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildApi();
  }

  // ── API mode ─────────────────────────────────────────────

  Widget _buildApi() {
    final state = ref.watch(marketplaceVenueListProvider);

    if (state.isLoading) {
      return _buildShimmer(height: 220);
    }

    if (state.error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        message: 'Gagal memuat lapangan',
        actionLabel: 'Coba lagi',
        onAction: () =>
            ref.read(marketplaceVenueListProvider.notifier).loadInitial(),
      );
    }

    if (state.isEmpty) {
      return const EmptyState(
        icon: Icons.store_outlined,
        message: 'Belum ada lapangan tersedia',
      );
    }

    final items = state.items;
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(marketplaceVenueListProvider.notifier).loadInitial(),
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
          final venue = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: _MarketplaceVenueCard(venue: venue),
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

/// Lightweight card for API marketplace venues.
class _MarketplaceVenueCard extends StatelessWidget {
  final MarketplaceVenue venue;
  const _MarketplaceVenueCard({required this.venue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.marketplaceVenue(venue.id)),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo or placeholder
          if (venue.photos.isNotEmpty)
            Image.network(
              venue.photos.first.url,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 140,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            )
          else
            Container(
              height: 140,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Center(
                child: Icon(Icons.sports, size: 48),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venue.name, style: theme.textTheme.titleMedium),
                if (venue.sport != null) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    venue.sport!.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
                if (venue.location != null) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.location!.name,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
