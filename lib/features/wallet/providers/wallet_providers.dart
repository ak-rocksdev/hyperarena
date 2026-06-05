import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/providers/notification_providers.dart';
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
