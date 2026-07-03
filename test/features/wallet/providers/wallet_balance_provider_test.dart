import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class _FakeRepo implements ApiWalletRepository {
  @override
  Future<CoachPayoutBalance> getBalance() async => const CoachPayoutBalance(
        outstandingCents: 300000,
        outstandingPeriods: ['2026-04'],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('walletBalanceProvider returns repo balance', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(_FakeRepo()),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(walletBalanceProvider.future);
    expect(result.outstandingCents, 300000);
    expect(result.outstandingPeriods, ['2026-04']);
  });
}
