import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/api_organizer_repository.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements SecureStorageService {}

void main() {
  late ApiOrganizerRepository repo;
  late DioAdapter dioAdapter;

  const sessionsPath = '/v1/marketplace/organizer/sessions';

  final draft = CreateSessionDraft(
    coachIds: const [1, 2],
    type: SessionType.group,
    title: 'Latihan Pagi',
    date: DateTime(2026, 7, 10),
    startTime: '07:30',
    durationMinutes: 90,
    capacity: 8,
    venueId: '7',
    venueName: 'Lapangan A',
    price: 50000,
  );

  /// Marketplace-serializer session shape (same as `organizer/sessions`).
  Map<String, dynamic> openSessionJson(String id) => {
        'id': id,
        'title': 'Latihan Pagi',
        'display_title': 'Latihan Pagi',
        'sport': 'tennis',
        'host_id': 'tenant-1',
        'host_name': 'Klub Kelana',
        'venue_name': 'Lapangan A',
        'venue_id': '7',
        'date': '2026-07-10',
        'start_time': '07:30',
        'end_time': '09:00',
      };

  setUp(() {
    final storage = _MockSecureStorage();
    when(() => storage.getToken()).thenReturn('test-token');
    final apiClient = ApiClient(secureStorage: storage);
    dioAdapter = DioAdapter(dio: apiClient.dio);
    repo = ApiOrganizerRepository(apiClient);
  });

  group('createSession', () {
    test('POSTs toCreatePayload and resolves the session via re-fetch',
        () async {
      // Payload matcher: a mismatched body would not match this route and
      // the request would fail — this asserts the exact contract.
      dioAdapter.onPost(
        sessionsPath,
        (server) => server.reply(201, {
          // Admin serialization: int id, not the marketplace shape.
          'session': {'id': 123, 'start_at': '2026-07-10 07:30:00'},
        }),
        data: draft.toCreatePayload(),
      );
      dioAdapter.onGet(
        sessionsPath,
        (server) => server.reply(200, {
          'data': [openSessionJson('123')],
        }),
      );

      final created = await repo.createSession(draft);

      expect(created.id, '123');
      expect(created.venueId, '7');
    });

    test('surfaces 422 errors.tenant as ValidationException', () async {
      dioAdapter.onPost(
        sessionsPath,
        (server) => server.reply(422, {
          'message': 'Rekening pencairan belum diatur.',
          'errors': {
            'tenant': ['Rekening pencairan belum diatur.'],
          },
        }),
        data: draft.toCreatePayload(),
      );

      expect(
        () => repo.createSession(draft),
        throwsA(isA<ValidationException>()
            .having((e) => e.errors, 'errors', contains('tenant'))),
      );
    });
  });

  group('lookups', () {
    test('getCoaches maps admin coach objects', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/coaches',
        (server) => server.reply(200, {
          'data': [
            {
              'id': 1,
              'user': {'name': 'Coach Joko'},
              // Real admin serializer nests the rate as a CoachRate object.
              'current_rate': {
                'id': 17,
                'coach_id': 1,
                'rate_per_session': 150000,
                'currency': 'IDR',
              },
            },
            {'id': 2, 'user': null, 'name': 'Coach Sari', 'current_rate': null},
          ],
        }),
      );

      final coaches = await repo.getCoaches();

      expect(coaches, hasLength(2));
      expect(coaches.first.id, 1);
      expect(coaches.first.name, 'Coach Joko');
      expect(coaches.first.ratePerSession, 150000);
      expect(coaches.last.name, 'Coach Sari');
      expect(coaches.last.ratePerSession, isNull);
    });

    test('getVenues maps ids to String', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/venues',
        (server) => server.reply(200, {
          'data': [
            {'id': 7, 'name': 'Lapangan A', 'city': 'Jakarta'},
          ],
        }),
      );

      final venues = await repo.getVenues();

      expect(venues.single.id, '7');
      expect(venues.single.name, 'Lapangan A');
      expect(venues.single.city, 'Jakarta');
    });

    test('getRecentSessions maps the recent shape', () async {
      dioAdapter.onGet(
        '$sessionsPath/recent',
        (server) => server.reply(200, {
          'data': [
            {
              'id': 5,
              'start_at': '2026-07-01 19:00:00',
              'type': 'group',
              'primary_coach_name': 'Coach Joko',
              'venue_name': 'Lapangan A',
              'created_at': '2026-06-20 10:00:00',
            },
          ],
        }),
      );

      final recent = await repo.getRecentSessions();

      expect(recent.single.id, '5');
      expect(recent.single.type, SessionType.group);
      expect(recent.single.startAt, DateTime(2026, 7, 1, 19));
      expect(recent.single.coachName, 'Coach Joko');
    });

    test('getDuplicatePayload maps to a draft with blank title & date',
        () async {
      dioAdapter.onGet(
        '$sessionsPath/5/duplicate-payload',
        (server) => server.reply(200, {
          'data': {
            'coach_ids': [1, 2],
            'type': 'private',
            'duration_minutes': 90,
            'capacity': null,
            'venue_id': 7,
            // Real BE shape: venue is a nested object, not a flat name.
            'venue': {
              'id': 7,
              'name': 'Lapangan A',
              'location': {'id': 3, 'address': 'Jl. Merdeka'},
            },
            'price': 50000,
            'notes': 'Bawa raket sendiri',
          },
        }),
      );

      final payload = await repo.getDuplicatePayload('5');

      expect(payload.title, isNull);
      expect(payload.date, isNull);
      expect(payload.coachIds, [1, 2]);
      expect(payload.type, SessionType.private);
      expect(payload.durationMinutes, 90);
      expect(payload.venueId, '7');
      expect(payload.venueName, 'Lapangan A');
      expect(payload.price, 50000);
    });
  });

  group('createVenue', () {
    test('POSTs the name and returns the persisted option', () async {
      dioAdapter.onPost(
        '/v1/marketplace/organizer/venues',
        (server) => server.reply(201, {
          'venue': {'id': 9, 'name': 'Lapangan Baru'},
        }),
        data: {'name': 'Lapangan Baru'},
      );

      final venue = await repo.createVenue(name: 'Lapangan Baru');

      expect(venue.id, '9');
      expect(venue.name, 'Lapangan Baru');
    });

    test('POSTs the resolved place fields when present', () async {
      dioAdapter.onPost(
        '/v1/marketplace/organizer/venues',
        (server) => server.reply(201, {
          'venue': {'id': 12, 'name': 'GOR Kemang'},
        }),
        data: {
          'name': 'GOR Kemang',
          'google_place_id': 'place_123',
          'address': 'Jl. Kemang Raya, Jakarta',
          'lat': -6.26,
          'lng': 106.81,
        },
      );

      final venue = await repo.createVenue(
        name: 'GOR Kemang',
        googlePlaceId: 'place_123',
        address: 'Jl. Kemang Raya, Jakarta',
        lat: -6.26,
        lng: 106.81,
      );

      expect(venue.id, '12');
    });
  });

  group('places proxy', () {
    test('autocomplete maps predictions', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/places/autocomplete',
        (server) => server.reply(200, {
          'data': [
            {
              'place_id': 'p1',
              'main_text': 'GOR Kemang',
              'secondary_text': 'Jakarta Selatan',
            },
          ],
        }),
        queryParameters: {'q': 'kemang', 'session_token': 'tok'},
      );

      final results = await repo.placesAutocomplete('kemang', 'tok');

      expect(results, hasLength(1));
      expect(results.first.placeId, 'p1');
      expect(results.first.mainText, 'GOR Kemang');
      expect(results.first.secondaryText, 'Jakarta Selatan');
    });

    test('details maps coordinates', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/places/details',
        (server) => server.reply(200, {
          'data': {
            'google_place_id': 'p1',
            'name': 'GOR Kemang',
            'address': 'Jl. Kemang Raya',
            'lat': -6.26,
            'lng': 106.81,
          },
        }),
        queryParameters: {'place_id': 'p1', 'session_token': 'tok'},
      );

      final details = await repo.placeDetails('p1', 'tok');

      expect(details, isNotNull);
      expect(details!.lat, -6.26);
      expect(details.lng, 106.81);
      expect(details.name, 'GOR Kemang');
    });

    test('details returns null on 404', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/places/details',
        (server) => server.reply(404, {'message': 'Place not found.'}),
        queryParameters: {'place_id': 'gone', 'session_token': 'tok'},
      );

      expect(await repo.placeDetails('gone', 'tok'), isNull);
    });
  });

  group('isPayoutConfigured', () {
    test('reads payout_configured from the dashboard', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/dashboard',
        (server) => server.reply(200, {'payout_configured': false}),
      );

      expect(await repo.isPayoutConfigured(), isFalse);
    });

    test('defaults to true when the field is absent (older BE)', () async {
      dioAdapter.onGet(
        '/v1/marketplace/organizer/dashboard',
        (server) => server.reply(200, <String, dynamic>{}),
      );

      expect(await repo.isPayoutConfigured(), isTrue);
    });
  });

  group('uploadSessionCoverPhoto', () {
    test('POSTs multipart to the photo endpoint', () async {
      final tmp = File(
          '${Directory.systemTemp.createTempSync('cover').path}/photo.jpg')
        ..writeAsBytesSync([0xFF, 0xD8, 0xFF]);
      dioAdapter.onPost(
        '$sessionsPath/123/photo',
        (server) => server.reply(201, {'ok': true}),
        data: Matchers.any,
      );

      await repo.uploadSessionCoverPhoto('123', tmp);
    });
  });
}
