import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';

void main() {
  test('parses qr_string from json', () {
    final intent = PaymentIntent.fromJson(const {
      'purchase_id': 1,
      'status': 'pending_payment',
      'provider': 'automatic',
      'payment_method': 'qris',
      'amount_base': 80000,
      'fee_amount': 5000,
      'amount_total': 85000,
      'qr_string': '000201-QRIS',
    });
    expect(intent.qrString, '000201-QRIS');
  });
}
