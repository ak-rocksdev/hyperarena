import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_hero.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_period_selector.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_session_row.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_status_chips.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_withdraw_cta.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachWalletScreen extends ConsumerStatefulWidget {
  const CoachWalletScreen({super.key});

  @override
  ConsumerState<CoachWalletScreen> createState() => _CoachWalletScreenState();
}

class _CoachWalletScreenState extends ConsumerState<CoachWalletScreen> {
  @override
  void initState() {
    super.initState();
    // Stamp "wallet last seen" on open so the bottom-nav Profile dot + the
    // Wallet ListTile dot clear. Done in a microtask so it runs after the
    // first frame and after any pending provider rebuilds.
    Future.microtask(() {
      if (!mounted) return;
      ref.read(walletLastSeenAtProvider.notifier).markSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(walletPeriodProvider);
    final payoutsAsync = ref.watch(walletPayoutsProvider(period));

    return Scaffold(
      backgroundColor: AppSurfaces.background,
      appBar: AppBar(
        title: const Text('Wallet'),
        scrolledUnderElevation: 0,
        backgroundColor: AppSurfaces.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Riwayat pencairan',
            onPressed: () => context.push(AppRoutes.coachWithdrawalHistory),
          ),
          const SizedBox(width: AppDimensions.xs),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        // Await the new futures so the spinner stays visible until data
        // actually arrives — pure `invalidate` returns synchronously and
        // dismisses the indicator before the refetch is on the wire.
        onRefresh: () async {
          ref.invalidate(walletBalanceProvider);
          ref.invalidate(walletSummaryProvider(period));
          ref.invalidate(walletPayoutsProvider(period));
          await Future.wait([
            ref.read(walletBalanceProvider.future),
            ref.read(walletPayoutsProvider(period).future),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.sm)),
            const SliverToBoxAdapter(child: WalletHero()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.lg),
            ),
            const SliverToBoxAdapter(child: WalletStatusChips()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.lg),
            ),
            const SliverToBoxAdapter(child: WalletWithdrawCta()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.xxl),
            ),
            SliverToBoxAdapter(child: _sectionHeader()),
            const SliverToBoxAdapter(child: WalletPeriodSelector()),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.sm)),
            payoutsAsync.when(
              data: (list) => list.isEmpty
                  ? _sliverEmpty()
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenHorizontal,
                      ),
                      sliver: SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (_, i) =>
                            WalletSessionRow(payout: list[i]),
                      ),
                    ),
              loading: () => _sliverSkeleton(),
              error: (e, _) => _sliverError(
                onRetry: () =>
                    ref.invalidate(walletPayoutsProvider(period)),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.xxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Row(
        children: [
          Text(
            'Riwayat Sesi',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            'Per bulan',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliverEmpty() => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontal,
            vertical: AppDimensions.xl,
          ),
          child: EmptyState(
            icon: Icons.account_balance_wallet_outlined,
            message:
                'Belum ada penghasilan di periode ini.\nSesi yang sudah selesai dengan absensi terisi akan muncul di sini.',
          ),
        ),
      );

  Widget _sliverSkeleton() {
    Widget block() => Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppSurfaces.shimmerBase,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
        );
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      sliver: SliverList.list(children: [block(), block(), block()]),
    );
  }

  Widget _sliverError({required VoidCallback onRetry}) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 32,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimensions.sm),
                const Text('Gagal memuat sesi'),
                const SizedBox(height: AppDimensions.sm),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
}
