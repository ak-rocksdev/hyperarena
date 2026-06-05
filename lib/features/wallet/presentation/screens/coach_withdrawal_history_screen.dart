import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/withdrawal_request_row.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class CoachWithdrawalHistoryScreen extends ConsumerWidget {
  const CoachWithdrawalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(withdrawalHistoryProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      backgroundColor: AppSurfaces.background,
      appBar: AppBar(
        title: const Text('Riwayat Pencairan'),
        backgroundColor: AppSurfaces.background,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(withdrawalHistoryProvider);
          await ref.read(withdrawalHistoryProvider.future);
        },
        child: historyAsync.when(
          data: (list) => list.isEmpty
              ? const _Empty()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                    vertical: AppDimensions.base,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) => WithdrawalRequestRow(
                    request: list[i],
                    currency: currency,
                  ),
                ),
          loading: () => _skeleton(),
          error: (e, _) => _ErrorView(
            onRetry: () => ref.invalidate(withdrawalHistoryProvider),
          ),
        ),
      ),
    );
  }

  Widget _skeleton() {
    Widget block() => Container(
          height: 92,
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppSurfaces.shimmerBase,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
        );
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.base,
      ),
      children: [block(), block(), block(), block()],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 80),
        EmptyState(
          icon: Icons.history_outlined,
          message:
              'Belum ada permintaan pencairan.\nPermintaan akan muncul di sini setelah kamu menekan tombol Cairkan.',
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 80),
        Center(
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.error,
              ),
              const SizedBox(height: AppDimensions.sm),
              const Text('Gagal memuat riwayat'),
              const SizedBox(height: AppDimensions.sm),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
