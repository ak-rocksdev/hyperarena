import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

abstract class VenueRepository {
  Future<List<Venue>> getVenues({Sport? sport, String? city});
  Future<Venue> getVenue(String id);
  Future<List<CourtSlot>> getCourtSlots(String courtId, DateTime date);
}
