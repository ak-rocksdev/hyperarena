import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/booking/presentation/widgets/payment_deadline_banner.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> _pump(WidgetTester tester, DateTime expiresAt) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: PaymentDeadlineBanner(expiresAt: expiresAt)),
    ),
  );
  await tester.pump(); // first tick
}

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  testWidgets('shows a countdown while the deadline is in the future',
      (tester) async {
    await _pump(tester, DateTime.now().add(const Duration(minutes: 30)));

    expect(find.text('Selesaikan pembayaran'), findsOneWidget);
    expect(find.textContaining('Bayar sebelum'), findsOneWidget);
    expect(find.text('Batas waktu pembayaran berakhir'), findsNothing);
  });

  testWidgets('shows the expired state once the deadline has passed',
      (tester) async {
    await _pump(tester, DateTime.now().subtract(const Duration(minutes: 1)));

    expect(find.text('Batas waktu pembayaran berakhir'), findsOneWidget);
    expect(find.textContaining('dibatalkan otomatis'), findsOneWidget);
    expect(find.text('Selesaikan pembayaran'), findsNothing);
  });
}
