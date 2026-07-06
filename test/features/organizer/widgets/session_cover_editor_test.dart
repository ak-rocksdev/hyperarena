import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_cover_editor.dart';

void main() {
  testWidgets('source sheet shows Hapus only when a photo exists',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showCoverSourceSheet(context, hasPhoto: true),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Ambil foto'), findsOneWidget);
    expect(find.text('Pilih dari galeri'), findsOneWidget);
    expect(find.text('Hapus sampul'), findsOneWidget);
  });

  testWidgets('source sheet hides Hapus when no photo', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showCoverSourceSheet(context, hasPhoto: false),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Hapus sampul'), findsNothing);
  });
}
