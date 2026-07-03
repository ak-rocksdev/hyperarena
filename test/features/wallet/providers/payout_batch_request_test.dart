import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/payout_request.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';

class _FakeRepo implements ApiWalletRepository {
  _FakeRepo(this._behavior);
  final Future<PayoutRequest> Function(String period) _behavior;

  @override
  Future<PayoutRequest> requestWithdrawal(String period) => _behavior(period);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

PayoutRequest _dummy(String period) => PayoutRequest(
      id: 1,
      period: period,
      totalAmountCents: 0,
      status: 'pending',
      requestedAt: DateTime(2026),
    );

void main() {
  test('run: all periods succeed', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async => _dummy(p)),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run(['2026-04', '2026-05'], currentPeriod: '2026-07');

    expect(state.allOk, isTrue);
    expect(state.okCount, 2);
    expect(state.isRunning, isFalse);
  });

  test('run: one period fails, batch continues and reports it', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async {
          if (p == '2026-05') throw Exception('active request exists');
          return _dummy(p);
        }),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run(['2026-04', '2026-05', '2026-06'], currentPeriod: '2026-07');

    expect(state.okCount, 2);
    expect(state.anyFailed, isTrue);
    expect(state.total, 3);
    final failed = state.results.firstWhere((r) => !r.ok);
    expect(failed.period, '2026-05');
    expect(failed.reason, contains('active request'));
  });

  test('run: empty periods is a no-op', () async {
    final container = ProviderContainer(overrides: [
      walletRepositoryProvider.overrideWithValue(
        _FakeRepo((p) async => _dummy(p)),
      ),
    ]);
    addTearDown(container.dispose);

    final state = await container
        .read(payoutBatchRequestProvider.notifier)
        .run([], currentPeriod: '2026-07');

    expect(state.total, 0);
    expect(state.isRunning, isFalse);
  });
}
