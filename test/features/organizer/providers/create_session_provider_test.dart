import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

class _FakeRepo implements OrganizerRepository {
  CreateSessionDraft? submitted;

  @override
  Future<OpenSession> createSession(CreateSessionDraft draft) async {
    submitted = draft;
    return MockData.sessions.first;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  ProviderContainer makeContainer(_FakeRepo repo) {
    final c = ProviderContainer(
      overrides: [organizerRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('setType(private) clears capacity', () {
    final c = makeContainer(_FakeRepo());
    final n = c.read(createSessionDraftProvider.notifier);
    n.setCapacity(10);
    n.setType(SessionType.private);
    expect(c.read(createSessionDraftProvider).capacity, isNull);
    expect(c.read(createSessionDraftProvider).type, SessionType.private);
  });

  test('toggleCoach adds then removes', () {
    final c = makeContainer(_FakeRepo());
    final n = c.read(createSessionDraftProvider.notifier);
    n.toggleCoach(5);
    expect(c.read(createSessionDraftProvider).coachIds, [5]);
    n.toggleCoach(5);
    expect(c.read(createSessionDraftProvider).coachIds, isEmpty);
  });

  test('setCapacity(null) means unlimited', () {
    final c = makeContainer(_FakeRepo());
    final n = c.read(createSessionDraftProvider.notifier);
    n.setCapacity(8);
    n.setCapacity(null);
    expect(c.read(createSessionDraftProvider).capacity, isNull);
  });

  test('applyDuplicate replaces the draft', () {
    final c = makeContainer(_FakeRepo());
    final n = c.read(createSessionDraftProvider.notifier);
    n.applyDuplicate(const CreateSessionDraft(price: 90000, notes: 'from dup'));
    expect(c.read(createSessionDraftProvider).price, 90000);
    expect(c.read(createSessionDraftProvider).notes, 'from dup');
  });

  test('submit sends the current draft to the repo', () async {
    final repo = _FakeRepo();
    final c = makeContainer(repo);
    final n = c.read(createSessionDraftProvider.notifier);
    n.toggleCoach(2);
    n.setType(SessionType.group);
    n.setDate(DateTime(2026, 7, 9));
    n.setStartTime('08:00');
    await n.submit();
    expect(repo.submitted!.coachIds, [2]);
    expect(repo.submitted!.startAtString, '2026-07-09 08:00');
  });
}
