import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:hyperarena/features/wallet/utils/wallet_period.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Cumulative withdraw CTA. Three visual states:
///   1. **Primary button** — `balance.canWithdraw` → "Cairkan Rp X". Tap →
///      confirmation sheet → batch POST (one payout-request per outstanding
///      period).
///   2. **In-flight disclosure** — nothing outstanding but `diprosesCents > 0`
///      → "Permintaan sedang diproses → Lihat riwayat" (deep-links to the
///      history list; the cumulative model can have several active requests, so
///      there is no single request to open).
///   3. **Hidden** — nothing outstanding and nothing in flight.
class WalletWithdrawCta extends ConsumerWidget {
  const WalletWithdrawCta({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: balanceAsync.when(
        data: (balance) => _build(context, ref, balance, currency),
        loading: () => const _CtaSkeleton(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _build(
    BuildContext context,
    WidgetRef ref,
    CoachPayoutBalance balance,
    String currency,
  ) {
    if (!balance.canWithdraw) {
      // Nothing to withdraw. If money is in flight, show the disclosure.
      if (balance.diprosesCents > 0) {
        return const _InFlightDisclosure();
      }
      return const SizedBox.shrink();
    }

    final amount = Formatters.formatCurrency(balance.outstandingCents, currency);
    final periods = balance.outstandingPeriods;
    final batch = ref.watch(payoutBatchRequestProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.xs,
            bottom: AppDimensions.xs,
          ),
          child: Text(
            'Siap dicairkan',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppShadows.button,
            ),
            child: ElevatedButton(
              onPressed: batch.isRunning
                  ? null
                  : () => _openConfirmation(context, ref, periods, amount),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.base,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                elevation: 0,
              ),
              child: batch.isRunning
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cairkan $amount',
                          style: AppTypography.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (periods.length > 1)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.xs,
              top: AppDimensions.xs,
            ),
            child: Text(
              'Mencakup ${periods.length} bulan',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openConfirmation(
    BuildContext context,
    WidgetRef ref,
    List<String> periods,
    String formattedAmount,
  ) async {
    AppHaptics.tap();
    final currentPeriod = ref.read(walletPeriodProvider);
    await _WithdrawConfirmationSheet.show(
      context: context,
      periods: periods,
      currentPeriod: currentPeriod,
      formattedAmount: formattedAmount,
    );
  }
}

/// Deep-links to the withdrawal history list. Multiple in-flight requests can
/// exist in the cumulative model, so there is no single request to open.
class _InFlightDisclosure extends StatelessWidget {
  const _InFlightDisclosure();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push(AppRoutes.coachWithdrawalHistory),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.infoLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 16,
                  color: AppColors.infoDark,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Permintaan sedang diproses',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.infoDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lihat riwayat pencairan',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.infoDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.infoDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaSkeleton extends StatelessWidget {
  const _CtaSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppSurfaces.shimmerBase,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
    );
  }
}

class _WithdrawConfirmationSheet extends ConsumerStatefulWidget {
  const _WithdrawConfirmationSheet({
    required this.periods,
    required this.currentPeriod,
    required this.formattedAmount,
  });

  /// Every outstanding period — one payout-request is POSTed per entry.
  final List<String> periods;

  /// The month shown in Riwayat Sesi — its per-period providers are refreshed
  /// after the batch so its rows reflect the new "Diproses" status.
  final String currentPeriod;
  final String formattedAmount;

  static Future<void> show({
    required BuildContext context,
    required List<String> periods,
    required String currentPeriod,
    required String formattedAmount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
          top: false,
          child: _WithdrawConfirmationSheet(
            periods: periods,
            currentPeriod: currentPeriod,
            formattedAmount: formattedAmount,
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<_WithdrawConfirmationSheet> createState() =>
      _WithdrawConfirmationSheetState();
}

class _WithdrawConfirmationSheetState
    extends ConsumerState<_WithdrawConfirmationSheet> {
  @override
  void dispose() {
    // Reset the batch notifier on close so a previous run's results don't
    // linger across instances of the sheet.
    Future.microtask(
      () => ref.read(payoutBatchRequestProvider.notifier).clear(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coversLabel = widget.periods.length == 1
        ? 'Periode ${WalletPeriod.longLabel(widget.periods.first)}'
        : 'Mencakup ${widget.periods.length} bulan: '
            '${widget.periods.map(WalletPeriod.shortLabel).join(', ')}';
    // SLA day is constant for the session — read once, don't rebuild on auth changes.
    final slaDays = ref.read(authNotifierProvider)?.tenantPayoutSlaDays ?? 14;
    final batch = ref.watch(payoutBatchRequestProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXxl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.xl,
        AppDimensions.md,
        AppDimensions.xl,
        AppDimensions.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          // Title with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppSurfaces.surfaceHighlight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cairkan Penghasilan',
                      style: AppTypography.headingSmall,
                    ),
                    Text(
                      coversLabel,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xl),
          // Amount preview card
          Container(
            padding: const EdgeInsets.all(AppDimensions.lg),
            decoration: BoxDecoration(
              color: AppSurfaces.surfaceHighlight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jumlah pencairan',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.primary700,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.formattedAmount,
                        style: AppTypography.numberMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_outward_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
          // SLA disclosure
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.infoLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: AppColors.infoDark,
                  size: 16,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Diproses oleh admin dalam $slaDays hari kerja. Status bisa dilihat di Riwayat Pencairan.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.infoDark,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: batch.isRunning
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.borderMedium),
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: batch.isRunning ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: batch.isRunning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Konfirmasi Pencairan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    AppHaptics.tap();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final result = await ref
        .read(payoutBatchRequestProvider.notifier)
        .run(widget.periods, currentPeriod: widget.currentPeriod);
    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.allOk
              ? 'Permintaan pencairan dikirim (${result.okCount} bulan). Cek statusnya di Riwayat Pencairan.'
              : '${result.okCount} dari ${result.total} bulan berhasil diajukan. Sisanya menunggu permintaan aktif selesai.',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
