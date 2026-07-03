import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/wallet/data/models/coach_payout_balance.dart';

void main() {
  test('fromJson maps all buckets + derived getters', () {
    final b = CoachPayoutBalance.fromJson({
      'outstanding_cents': 450000,
      'requested_cents': 100000,
      'approved_cents': 50000,
      'paid_cents': 200000,
      'outstanding_session_count': 2,
      'outstanding_periods': ['2026-04', '2026-05'],
    });

    expect(b.outstandingCents, 450000);
    expect(b.diprosesCents, 150000); // requested + approved
    expect(b.paidCents, 200000);
    expect(b.outstandingPeriods, ['2026-04', '2026-05']);
    expect(b.canWithdraw, isTrue);
    expect(b.hasAnyActivity, isTrue);
  });

  test('defaults tolerate a sparse payload', () {
    final b = CoachPayoutBalance.fromJson({'outstanding_cents': 0});
    expect(b.outstandingCents, 0);
    expect(b.outstandingPeriods, isEmpty);
    expect(b.canWithdraw, isFalse);
    expect(b.hasAnyActivity, isFalse);
  });
}
