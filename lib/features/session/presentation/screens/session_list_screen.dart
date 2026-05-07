import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/list_loading_indicator.dart';
import 'package:hyperarena/shared/widgets/other_tenant_caption.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:go_router/go_router.dart';

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
  void didUpdateWidget(covariant SessionListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      ref
          .read(marketplaceSessionListProvider.notifier)
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
      ref.read(marketplaceSessionListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildApi();
  }

  // ── API mode ─────────────────────────────────────────────

  Widget _buildApi() {
    final state = ref.watch(marketplaceSessionListProvider);

    if (state.isLoading) {
      return _buildShimmer(height: 200);
    }

    Future<void> reload() =>
        ref.read(marketplaceSessionListProvider.notifier).loadInitial();

    // Wrap every branch in RefreshIndicator so pull-to-refresh works on
    // empty + error states (parity with tab Lapangan + Coach). The
    // EmptyState already exposes a "Muat ulang" button — we keep both
    // affordances per user's preference.
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
                message: 'Gagal memuat sesi',
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
              child: EmptyState(
                icon: Icons.event_outlined,
                message: 'Belum ada sesi mendatang.\n'
                    'Sesi yang sudah dijadwalkan oleh admin akan muncul di sini.',
                actionLabel: 'Muat ulang',
                onAction: reload,
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
class _MarketplaceSessionCard extends ConsumerWidget {
  final MarketplaceSession session;
  const _MarketplaceSessionCard({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userTenantSlug = ref.watch(authNotifierProvider)?.tenantSlug;
    final sessionTenantSlug = session.tenant?.slug;
    final isOtherTenant = userTenantSlug != null &&
        sessionTenantSlug != null &&
        sessionTenantSlug != userTenantSlug;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.marketplaceSession(session.id),
          extra: session,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 16:9 hero — falls back to tenant logo when no session photo.
            // Pass session.tenant?.brandColor so cross-tenant cards render
            // the right brand color in fallback mode.
            SessionHero(
              photoUrls: session.photoUrls,
              photoPath: session.photoPath,
              size: SessionHeroSize.md,
              brandColor: session.tenant?.brandColor,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
                children: [
                  Expanded(
                    child: Text(session.safeTitle,
                        style: theme.textTheme.titleMedium),
                  ),
                  // Status pill — "Sedang berlangsung" when start ≤ now < end,
                  // else "Terdaftar" if user enrolled. Computed client-side
                  // because the BE filter relaxes to include ongoing sessions
                  // (Issue 2026-05-07 — was strict start_at > now()).
                  if (_isOngoing(session))
                    _StatusPill(
                      label: 'Sedang berlangsung',
                      icon: Icons.play_circle_outline,
                      color: AppColors.warning,
                    )
                  else if (session.isEnrolled)
                    _StatusPill(
                      label: 'Terdaftar',
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                ],
              ),
              if (session.tenant != null) ...[
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'oleh ${session.tenant!.name}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isOtherTenant) ...[
                      const SizedBox(width: AppDimensions.xs),
                      const OtherTenantCaption(),
                    ],
                  ],
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
                    Formatters.formatDateTimeCompact(session.startAt),
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
          ],
        ),
      ),
    );
  }

  /// True when the session has started but not yet ended. Compares against
  /// `DateTime.now()` (device-local) — the wall-clock-naive `startAt` from
  /// `tenantWallClockFromJson` carries the tenant's wall-clock components,
  /// so for users in the same tz as the tenant this is exact, and for
  /// cross-tz users the badge will be approximately right (off by tz delta).
  bool _isOngoing(MarketplaceSession session) {
    final start = session.startAt;
    final end = start.add(Duration(minutes: session.durationMinutes));
    final now = DateTime.now();
    return !now.isBefore(start) && now.isBefore(end);
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusPill({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
