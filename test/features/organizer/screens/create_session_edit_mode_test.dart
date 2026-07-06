import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/organizer/presentation/screens/create_session_screen.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

const _editDraft = CreateSessionDraft(
  sessionId: 42,
  coachIds: [1],
  type: SessionType.group,
  title: 'Pagi',
  date: null,
  startTime: '08:00',
  durationMinutes: 60,
  capacity: 10,
  price: 50000,
  notes: 'Catatan latihan',
);

class _FakeRepo implements OrganizerRepository {
  @override
  Future<CreateSessionDraft> getEditPayload(String sessionId) async {
    // `date` can't be `const` (DateTime.now() isn't a compile-time constant),
    // so it's added here rather than in the top-level const draft.
    return _editDraft.copyWith(date: DateTime(2026, 7, 10));
  }

  @override
  Future<OpenSession> getSessionDetail(String sessionId) async {
    return MockData.sessions.first;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() => initializeDateFormatting('id'));

  Widget host() => ProviderScope(
        overrides: [
          organizerRepositoryProvider.overrideWithValue(_FakeRepo()),
          tenantCurrencyProvider.overrideWithValue('IDR'),
        ],
        child: const MaterialApp(home: CreateSessionScreen(sessionId: '42')),
      );

  testWidgets('edit mode prefills and gates Save on dirty', (tester) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('Edit sesi'), findsOneWidget);
    // Prefilled title appears both in the title field and the ticket preview.
    expect(find.text('Pagi'), findsWidgets);

    final saveBtn = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan perubahan'),
    );
    expect(saveBtn.onPressed, isNull); // not dirty yet

    await tester.enterText(find.byType(TextField).first, 'Judul baru');
    await tester.pump();

    final saveBtn2 = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan perubahan'),
    );
    expect(saveBtn2.onPressed, isNotNull);
  });
}
