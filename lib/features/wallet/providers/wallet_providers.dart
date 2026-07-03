import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
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

// autoDispose so navigating month-by-month doesn't accumulate one provider
// instance per period for the rest of the session. Each entry is disposed
// when no widget is watching it.
final walletSummaryProvider =
    FutureProvider.autoDispose.family<CoachPayoutSummary, String>(
  (ref, period) async {
    return ref.watch(walletRepositoryProvider).getSummary(period);
  },
);

final walletPayoutsProvider =
    FutureProvider.autoDispose.family<List<CoachPayout>, String>(
  (ref, period) async {
    return ref.watch(walletRepositoryProvider).getPayouts(period);
  },
);

/// Cumulative all-months balance — global (NOT a family), month-independent.
/// Drives the hero, status chips, and withdraw CTA.
final walletBalanceProvider =
    FutureProvider.autoDispose<CoachPayoutBalance>((ref) async {
  return ref.watch(walletRepositoryProvider).getBalance();
});

final withdrawalHistoryProvider =
    FutureProvider.autoDispose<List<PayoutRequest>>((ref) async {
  return ref.watch(walletRepositoryProvider).getWithdrawalHistory();
});

final withdrawalDetailProvider =
    FutureProvider.autoDispose.family<PayoutRequest, int>((ref, id) async {
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

// ──────────────────────────────────────────────────────────────────────────
// Batch withdrawal — "Cairkan semua sekaligus"
//
// The cumulative model withdraws every outstanding period in one tap. The BE
// request model is per-period, so we POST once per period. We NEVER abort on a
// single failure (e.g. a period that raced into an active request): record the
// per-period outcome and continue, then report the aggregate.

class BatchPeriodResult {
  const BatchPeriodResult({required this.period, required this.ok, this.reason});
  final String period;
  final bool ok;
  final String? reason; // null when ok
}

class PayoutBatchState {
  const PayoutBatchState({this.isRunning = false, this.results = const []});
  final bool isRunning;
  final List<BatchPeriodResult> results;

  int get okCount => results.where((r) => r.ok).length;
  int get total => results.length;
  bool get allOk => results.isNotEmpty && results.every((r) => r.ok);
  bool get anyFailed => results.any((r) => !r.ok);
}

class PayoutBatchNotifier extends Notifier<PayoutBatchState> {
  @override
  PayoutBatchState build() => const PayoutBatchState();

  /// POSTs one payout-request per period, sequentially. Returns the final state.
  /// `currentPeriod` is the month currently shown in Riwayat Sesi — its
  /// per-period providers are invalidated too so its rows reflect the new
  /// "Diproses" status.
  Future<PayoutBatchState> run(
    List<String> periods, {
    required String currentPeriod,
  }) async {
    if (periods.isEmpty) return state;

    state = const PayoutBatchState(isRunning: true);
    final repo = ref.read(walletRepositoryProvider);
    final results = <BatchPeriodResult>[];

    for (final period in periods) {
      try {
        await repo.requestWithdrawal(period);
        results.add(BatchPeriodResult(period: period, ok: true));
      } catch (e) {
        results.add(
          BatchPeriodResult(period: period, ok: false, reason: e.toString()),
        );
      }
    }

    // Server is source of truth — re-fetch everything that could have changed.
    ref.invalidate(walletBalanceProvider);
    ref.invalidate(withdrawalHistoryProvider);
    ref.invalidate(walletSummaryProvider(currentPeriod));
    ref.invalidate(walletPayoutsProvider(currentPeriod));

    state = PayoutBatchState(isRunning: false, results: results);
    return state;
  }

  void clear() => state = const PayoutBatchState();
}

final payoutBatchRequestProvider =
    NotifierProvider<PayoutBatchNotifier, PayoutBatchState>(
  PayoutBatchNotifier.new,
);

// ──────────────────────────────────────────────────────────────────────────
// Unseen wallet activity indicator
//
// Wallet-flavoured awareness pattern: the bottom-nav Profile icon and the
// Wallet ListTile in Profile both show a pulsing dot when there's wallet
// news the coach hasn't acknowledged yet. "News" = an unread payout-typed
// notification newer than the last time the coach opened the wallet
// screen. Opening Wallet clears the indicator.
//
// Three pieces:
//   - walletLastSeenAtProvider  → DateTime? backed by SharedPreferences
//   - markWalletSeenProvider    → callable stamping `now` (called from
//                                 CoachWalletScreen initState)
//   - hasUnseenWalletActivityProvider → bool, derived from the two above
//                                       + notificationListProvider

const _walletLastSeenKey = 'wallet_last_seen_at';

class WalletLastSeenNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() {
    final raw = ref.read(sharedPreferencesProvider).getString(_walletLastSeenKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> markSeen() async {
    final now = DateTime.now();
    await ref
        .read(sharedPreferencesProvider)
        .setString(_walletLastSeenKey, now.toIso8601String());
    state = now;
  }
}

final walletLastSeenAtProvider =
    NotifierProvider<WalletLastSeenNotifier, DateTime?>(
  WalletLastSeenNotifier.new,
);

// Notification types that should trigger the wallet pulse indicator.
const _walletNotificationTypes = {
  NotificationType.payoutEarned,
  NotificationType.payoutRequestApproved,
  NotificationType.payoutDisbursed,
};

/// True when at least one wallet-typed notification arrived after the coach
/// last opened the Wallet screen (or anytime, if the coach never opened it).
final hasUnseenWalletActivityProvider = Provider<bool>((ref) {
  final lastSeen = ref.watch(walletLastSeenAtProvider);
  final listAsync = ref.watch(notificationListProvider);
  return listAsync.maybeWhen(
    data: (list) => list.any(
      (n) =>
          _walletNotificationTypes.contains(n.type) &&
          (lastSeen == null || n.createdAt.isAfter(lastSeen)),
    ),
    orElse: () => false,
  );
});
