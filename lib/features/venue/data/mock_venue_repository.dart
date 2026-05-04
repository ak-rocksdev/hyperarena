import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
import 'package:hyperarena/features/venue/data/venue_repository.dart';

class MockVenueRepository implements VenueRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  MockVenueRepository();

  @override
  Future<List<Venue>> getVenues({Sport? sport, String? city}) async {
    await Future.delayed(_delay);
    var venues = MockData.venues;
    if (sport != null) {
      venues = venues
          .where((v) => v.courts.any((c) => c.sportType == sport))
          .toList();
    }
    if (city != null) {
      venues = venues.where((v) => v.city == city).toList();
    }
    return venues;
  }

  @override
  Future<Venue> getVenue(String id) async {
    await Future.delayed(_delay);
    return MockData.venues.firstWhere((v) => v.id == id);
  }

  @override
  Future<List<CourtSlot>> getCourtSlots(String courtId, DateTime date) async {
    await Future.delayed(_delay);
    return MockData.generateSlots(courtId, date);
  }
}
