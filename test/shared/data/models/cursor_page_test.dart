import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

void main() {
  test('fromJson parses items and cursor', () {
    final json = {
      'data': [
        {'id': 1, 'name': 'Tennis'},
        {'id': 2, 'name': 'Padel'},
      ],
      'next_cursor': 'abc123',
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.items.length, 2);
    expect(page.nextCursor, 'abc123');
    expect(page.hasMore, true);
    expect(page.perPage, 15);
  });

  test('fromJson handles null cursor (last page)', () {
    final json = {
      'data': [
        {'id': 1, 'name': 'Tennis'},
      ],
      'next_cursor': null,
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.items.length, 1);
    expect(page.nextCursor, isNull);
    expect(page.hasMore, false);
  });

  test('fromJson handles empty data', () {
    final json = {
      'data': [],
      'next_cursor': null,
      'per_page': 15,
    };

    final page = CursorPage.fromJson<Map<String, dynamic>>(json, (j) => j);

    expect(page.items, isEmpty);
    expect(page.hasMore, false);
  });
}
