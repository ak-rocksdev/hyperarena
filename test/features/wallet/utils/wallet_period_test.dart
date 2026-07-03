import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/utils/wallet_period.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  test('shortLabel formats YYYY-MM to "MMM yyyy" id', () {
    expect(WalletPeriod.shortLabel('2026-04'), 'Apr 2026');
  });
}
