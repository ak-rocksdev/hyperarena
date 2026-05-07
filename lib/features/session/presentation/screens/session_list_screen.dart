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
                message: 'Belum ada sesi.\n'
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

    final pill = _resolveStatusPill(session);

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
                  ?pill,
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

  /// `startAt` carries tenant wall-clock components (offset stripped by
  /// `tenantWallClockFromJson`). Comparing to device-local `DateTime.now()`
  /// is exact for same-tz users and off by the tz delta for cross-tz —
  /// acceptable for a status pill, not for booking-time validation.
  bool _isOngoing(MarketplaceSession s) {
    final now = DateTime.now();
    final end = s.startAt.add(Duration(minutes: s.durationMinutes));
    return !now.isBefore(s.startAt) && now.isBefore(end);
  }

  bool _isEnded(MarketplaceSession s) {
    final end = s.startAt.add(Duration(minutes: s.durationMinutes));
    return !DateTime.now().isBefore(end);
  }

  bool _isFull(MarketplaceSession s) => s.bookedCount >= s.capacity;

  /// Single pill priority: ongoing > selesai > terdaftar > penuh > none.
  /// Past sessions surface 'Selesai' regardless of enrollment so the
  /// pill matches reading tense — the date next to it already tells the
  /// user it's history.
  Widget? _resolveStatusPill(MarketplaceSession s) {
    if (_isOngoing(s)) {
      return _StatusPill(
        label: 'Sedang berlangsung',
        icon: Icons.play_circle_outline,
        color: AppColors.warning,
      );
    }
    if (_isEnded(s)) {
      return _StatusPill(
        label: 'Sesi Selesai',
        icon: Icons.check_circle_outline,
        color: AppColors.neutral500,
      );
    }
    if (s.isEnrolled) {
      return _StatusPill(
        label: 'Terdaftar',
        icon: Icons.check_circle,
        color: AppColors.success,
      );
    }
    if (_isFull(s)) {
      return _StatusPill(
        label: 'Penuh',
        icon: Icons.block,
        color: AppColors.error,
      );
    }
    return null;
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
