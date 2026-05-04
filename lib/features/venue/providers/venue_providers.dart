import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/venue/data/mock_venue_repository.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
import 'package:hyperarena/features/venue/data/venue_repository.dart';
// ── DI ──────────────────────────────────────────────────────────

final venueRepositoryProvider = Provider<VenueRepository>((ref) {
  return MockVenueRepository();
});

// ── Filter state ────────────────────────────────────────────────

class VenueFilterState {
  final Sport? sport;
  final String? city;

  const VenueFilterState({this.sport, this.city});

  VenueFilterState copyWith({Sport? sport, String? city, bool clearSport = false}) {
    return VenueFilterState(
      sport: clearSport ? null : (sport ?? this.sport),
      city: city ?? this.city,
    );
  }
}

final venueFilterProvider =
    NotifierProvider<VenueFilterNotifier, VenueFilterState>(
        VenueFilterNotifier.new);

class VenueFilterNotifier extends Notifier<VenueFilterState> {
  @override
  VenueFilterState build() => const VenueFilterState();

  void setSport(Sport? sport) {
    if (state.sport == sport) {
      state = state.copyWith(clearSport: true);
    } else {
      state = VenueFilterState(sport: sport, city: state.city);
    }
  }

  void reset() => state = const VenueFilterState();
}

// ── Venue list ──────────────────────────────────────────────────

final venueListProvider = FutureProvider<List<Venue>>((ref) {
  final repo = ref.watch(venueRepositoryProvider);
  final filter = ref.watch(venueFilterProvider);
  return repo.getVenues(sport: filter.sport, city: filter.city);
});

// ── Venue detail ────────────────────────────────────────────────

final venueDetailProvider =
    FutureProvider.family<Venue, String>((ref, id) {
  final repo = ref.watch(venueRepositoryProvider);
  return repo.getVenue(id);
});

// ── Court slots ─────────────────────────────────────────────────

typedef CourtSlotParams = ({String courtId, DateTime date});

final courtSlotsProvider =
    FutureProvider.family<List<CourtSlot>, CourtSlotParams>((ref, params) {
  final repo = ref.watch(venueRepositoryProvider);
  return repo.getCourtSlots(params.courtId, params.date);
});
