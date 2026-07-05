import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/capacity_selector.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/duration_pills.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_type_cards.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('SessionTypeCards reports the tapped type', (tester) async {
    SessionType? picked;
    await tester.pumpWidget(_host(SessionTypeCards(
      value: SessionType.group,
      onChanged: (t) => picked = t,
    )));
    await tester.tap(find.text('Privat'));
    expect(picked, SessionType.private);
  });

  testWidgets('CapacitySelector: unlimited hides the stepper, Batasi reveals it',
      (tester) async {
    int? value;
    await tester.pumpWidget(_host(CapacitySelector(
      value: null,
      onChanged: (v) => value = v,
    )));
    expect(find.text('Maks peserta'), findsNothing);
    await tester.tap(find.text('Batasi'));
    expect(value, 10); // defaultLimit
  });

  testWidgets('DurationPills: tapping a preset emits its minutes',
      (tester) async {
    int? minutes;
    await tester.pumpWidget(_host(DurationPills(
      value: 60,
      onChanged: (m) => minutes = m,
    )));
    await tester.tap(find.text('2 jam'));
    expect(minutes, 120);
  });

  testWidgets('DurationPills: Custom reveals the minutes field', (tester) async {
    await tester.pumpWidget(_host(DurationPills(value: 60, onChanged: (_) {})));
    expect(find.text('menit (15–480)'), findsNothing);
    await tester.tap(find.text('Custom'));
    await tester.pump();
    expect(find.text('menit (15–480)'), findsOneWidget);
  });
}
