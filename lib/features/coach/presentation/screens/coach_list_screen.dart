import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/other_tenant_caption.dart';

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
  void didUpdateWidget(covariant CoachListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      ref
          .read(marketplaceCoachListProvider.notifier)
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
      ref.read(marketplaceCoachListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildApi();
  }

  // ── API mode ─────────────────────────────────────────────

  Widget _buildApi() {
    final state = ref.watch(marketplaceCoachListProvider);

    if (state.isLoading) {
      return _buildShimmer(height: 160);
    }

    Future<void> reload() =>
        ref.read(marketplaceCoachListProvider.notifier).loadInitial();

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
                message: 'Gagal memuat coach',
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
                icon: Icons.person_outlined,
                message: 'Belum ada coach tersedia',
              ),
            ),
          ],
        ),
      );
    }

    final items = state.items;
    return RefreshIndicator(
      onRefresh: reload,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
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
class _MarketplaceCoachCard extends ConsumerWidget {
  final MarketplaceCoach coach;
  const _MarketplaceCoachCard({required this.coach});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userTenantId = ref.watch(authNotifierProvider)?.tenantId;
    final isOtherTenant = userTenantId != null &&
        coach.tenantId != null &&
        coach.tenantId != userTenantId;

    return Card(
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.marketplaceCoach(coach.id),
          extra: coach,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
              radius: 28,
              backgroundImage: coach.user?.photoUrls?['md'] != null
                  ? NetworkImage(coach.user!.photoUrls!['md']!)
                  : null,
              child: coach.user?.photoUrls == null
                  ? const Icon(Icons.person, size: 28)
                  : null,
            ),
            const SizedBox(width: AppDimensions.md),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          coach.user?.name ?? 'Coach',
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
                      '${Formatters.formatCurrency(coach.ratePerSession!, coach.currency ?? 'IDR')}/sesi',
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
      ),
    );
  }
}
