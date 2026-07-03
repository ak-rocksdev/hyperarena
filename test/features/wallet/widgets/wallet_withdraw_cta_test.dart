import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/wallet/data/api_wallet_repository.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';
import 'package:hyperarena/features/wallet/presentation/widgets/wallet_withdraw_cta.dart';
import 'package:hyperarena/features/wallet/providers/wallet_providers.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeRepo implements ApiWalletRepository {
  _FakeRepo(this._balance);
  final CoachPayoutBalance _balance;
  @override
  Future<CoachPayoutBalance> getBalance() async => _balance;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _pump(WidgetTester tester, CoachPayoutBalance balance) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        walletRepositoryProvider.overrideWithValue(_FakeRepo(balance)),
        tenantCurrencyProvider.overrideWithValue('IDR'),
      ],
      child: const MaterialApp(
        home: Scaffold(body: WalletWithdrawCta()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  testWidgets('shows Cairkan button when outstanding > 0', (tester) async {
    await _pump(
      tester,
      const CoachPayoutBalance(
        outstandingCents: 300000,
        outstandingPeriods: ['2026-04'],
      ),
    );
    expect(find.textContaining('Cairkan'), findsOneWidget);
  });

  testWidgets('hides Cairkan button and shows disclosure when only diproses',
      (tester) async {
    await _pump(tester, const CoachPayoutBalance(requestedCents: 300000));
    expect(find.textContaining('Cairkan'), findsNothing);
    expect(find.textContaining('diproses'), findsOneWidget);
  });

  testWidgets('shows nothing when zero activity', (tester) async {
    await _pump(tester, const CoachPayoutBalance());
    expect(find.textContaining('Cairkan'), findsNothing);
    expect(find.textContaining('diproses'), findsNothing);
  });
}
