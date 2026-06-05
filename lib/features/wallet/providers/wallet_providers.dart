import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_summary.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

/// Wallet feature providers — bundled because they're tightly related and
/// the cross-references (CTA invalidating summary + payouts + history) would
/// fragment ugly across separate files.

final walletRepositoryProvider = Provider<ApiWalletRepository>(
  (ref) => ApiWalletRepository(ref.watch(apiClientProvider)),
);

/// "YYYY-MM" — defaults to the current month. Mutated by the period selector
/// at the top of the wallet screen.
String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

final walletPeriodProvider = StateProvider<String>((ref) => _currentPeriod());

final walletSummaryProvider =
    FutureProvider.family<CoachPayoutSummary, String>((ref, period) async {
  return ref.watch(walletRepositoryProvider).getSummary(period);
});

final walletPayoutsProvider =
    FutureProvider.family<List<CoachPayout>, String>((ref, period) async {
  return ref.watch(walletRepositoryProvider).getPayouts(period);
});

final withdrawalHistoryProvider =
    FutureProvider<List<PayoutRequest>>((ref) async {
  return ref.watch(walletRepositoryProvider).getWithdrawalHistory();
});

final withdrawalDetailProvider =
    FutureProvider.family<PayoutRequest, int>((ref, id) async {
  return ref.watch(walletRepositoryProvider).getWithdrawalDetail(id);
});

/// CTA state — captures loading/error so the "Cairkan" button can show its
/// own progress without freezing the whole screen.
class PayoutRequestActionState {
  const PayoutRequestActionState({
    this.isLoading = false,
    this.error,
    this.lastSuccess,
  });

  final bool isLoading;
  final String? error;
  final PayoutRequest? lastSuccess;
}

class PayoutRequestActionNotifier extends Notifier<PayoutRequestActionState> {
  @override
  PayoutRequestActionState build() => const PayoutRequestActionState();

  Future<bool> requestWithdrawal(String period) async {
    state = const PayoutRequestActionState(isLoading: true);
    try {
      final req = await ref
          .read(walletRepositoryProvider)
          .requestWithdrawal(period);
      ref.invalidate(walletSummaryProvider(period));
      ref.invalidate(walletPayoutsProvider(period));
      ref.invalidate(withdrawalHistoryProvider);
      state = PayoutRequestActionState(lastSuccess: req);
      return true;
    } catch (e) {
      state = PayoutRequestActionState(error: e.toString());
      return false;
    }
  }

  void clear() {
    state = const PayoutRequestActionState();
  }
}

final payoutRequestActionProvider =
    NotifierProvider<PayoutRequestActionNotifier, PayoutRequestActionState>(
  PayoutRequestActionNotifier.new,
);
