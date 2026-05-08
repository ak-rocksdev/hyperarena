import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/venue/data/models/marketplace_venue.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/other_tenant_caption.dart';
import 'package:hyperarena/shared/widgets/paginated_list_view.dart';

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

    Future<void> reload() =>
        ref.read(marketplaceVenueListProvider.notifier).loadInitial();

    if (state.error != null) {
      return RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyState(
                icon: Icons.error_outline,
                message: 'Gagal memuat lapangan',
                actionLabel: 'Coba lagi',
                onAction: reload,
              ),
            ),
          ],
        ),
      );
    }

    if (state.isEmpty) {
      return RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const EmptyState(
                icon: Icons.store_outlined,
                message: 'Belum ada lapangan tersedia',
              ),
            ),
          ],
        ),
      );
    }

    return PaginatedListView<MarketplaceVenue>(
      items: state.items,
      isLoadingMore: state.isLoadingMore,
      loadMoreError: state.loadMoreError,
      controller: _scrollController,
      onRefresh: reload,
      onRetry: () =>
          ref.read(marketplaceVenueListProvider.notifier).retryLoadMore(),
      itemBuilder: (_, venue) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.md),
        child: _MarketplaceVenueCard(venue: venue),
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
class _MarketplaceVenueCard extends ConsumerWidget {
  final MarketplaceVenue venue;
  const _MarketplaceVenueCard({required this.venue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userTenantId = ref.watch(authNotifierProvider)?.tenantId;
    final isOtherTenant =
        userTenantId != null &&
        venue.tenantId != null &&
        venue.tenantId != userTenantId;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.marketplaceVenue(venue.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo or placeholder. `coverImageUrl` is the BE-resolved
            // fallback chain (uploaded photo → Street View → null). The
            // legacy `photos.first.url` path stays as a last resort for
            // pre-feature-deploy responses that don't carry the new field.
            if (venue.coverImageUrl != null || venue.photos.isNotEmpty)
              CachedNetworkImage(
                imageUrl: venue.coverImageUrl ?? venue.photos.first.url,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  height: 140,
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, _, _) => Container(
                  height: 140,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              )
            else
              Container(
                height: 140,
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.sports, size: 48)),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          venue.name,
                          style: theme.textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOtherTenant) ...[
                        const SizedBox(width: AppDimensions.xs),
                        const OtherTenantCaption(),
                      ],
                    ],
                  ),
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
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
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
