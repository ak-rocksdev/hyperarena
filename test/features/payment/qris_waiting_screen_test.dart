import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hyperarena/features/payment/data/models/payment_intent.dart';
import 'package:hyperarena/features/payment/presentation/screens/qris_waiting_screen.dart';

void main() {
  testWidgets('renders a QR from qrString + shows the amount', (tester) async {
    const intent = PaymentIntent(
      purchaseId: 1, status: 'pending_payment', provider: 'automatic',
      paymentMethod: 'qris', amountBase: 80000, feeAmount: 5000,
      amountTotal: 85000, qrString: '000201-QRIS',
    );

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: QrisWaitingScreen(purchaseId: 1, amount: 85000, intent: intent),
      ),
    ));
    await tester.pump();

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.textContaining('Scan'), findsWidgets);
  });
}
