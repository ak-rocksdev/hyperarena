import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/routing/app_routes.dart';

void main() {
  test('qris routes to /payment/qris, va to /payment/va, manual to /payment/manual', () {
    expect(paymentTargetPath(provider: 'automatic', method: 'qris', id: 7), '/payment/qris/7');
    expect(paymentTargetPath(provider: 'automatic', method: 'va_bca', id: 7), '/payment/va/7');
    expect(paymentTargetPath(provider: 'manual', method: 'manual', id: 7), '/payment/manual/7');
  });
}
