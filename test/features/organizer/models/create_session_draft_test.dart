import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';

void main() {
  final base = CreateSessionDraft(
    coachIds: const [3, 7],
    type: SessionType.group,
    title: '  Latihan Kamis  ',
    date: DateTime(2026, 7, 9),
    startTime: '08:00',
    durationMinutes: 90,
    capacity: 12,
    venueId: '42',
    price: 150000,
    notes: '  bawa raket  ',
  );

  test('toCreatePayload maps every field to the StoreSessionRequest shape', () {
    final p = base.toCreatePayload();
    expect(p['coach_ids'], [3, 7]);
    expect(p['type'], 'group');
    expect(p['title'], 'Latihan Kamis'); // trimmed
    expect(p['start_at'], '2026-07-09 08:00');
    expect(p['duration_minutes'], 90);
    expect(p['capacity'], 12);
    expect(p['venue_id'], 42); // String -> int
    expect(p['price'], 150000);
    expect(p['notes'], 'bawa raket');
  });

  test('private session forces capacity to null', () {
    final p = base.copyWith(type: SessionType.private, capacity: 5).toCreatePayload();
    expect(p['type'], 'private');
    expect(p['capacity'], isNull);
  });

  test('unlimited capacity stays null', () {
    final p = base.copyWith(capacity: null).toCreatePayload();
    expect(p['capacity'], isNull);
  });

  test('empty/blank title and notes become null', () {
    final p = base.copyWith(title: '   ', notes: '').toCreatePayload();
    expect(p['title'], isNull);
    expect(p['notes'], isNull);
  });

  test('venue_id is null when no venue picked', () {
    final p = base.copyWith(venueId: null).toCreatePayload();
    expect(p['venue_id'], isNull);
  });

  test('start_at is null until both date and time are set', () {
    expect(base.copyWith(date: null).startAtString, isNull);
    expect(base.copyWith(startTime: null).startAtString, isNull);
    expect(base.startAtString, '2026-07-09 08:00');
  });

  test('validity getters', () {
    expect(const CreateSessionDraft().step1Valid, isFalse);
    expect(base.step1Valid, isTrue);
    expect(base.canSubmit, isTrue);
    expect(base.copyWith(date: null).canSubmit, isFalse);
    expect(base.copyWith(durationMinutes: 10).canSubmit, isFalse);
  });
}
