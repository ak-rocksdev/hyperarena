import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

final createSessionDraftProvider =
    NotifierProvider<CreateSessionDraftNotifier, CreateSessionDraft>(
      CreateSessionDraftNotifier.new,
    );

// ── Create-session lookups ──
final createSessionCoachesProvider =
    FutureProvider.autoDispose<List<CoachOption>>((ref) {
  return ref.watch(organizerRepositoryProvider).getCoaches();
});

final createSessionVenuesProvider =
    FutureProvider.autoDispose<List<VenueOption>>((ref) {
  return ref.watch(organizerRepositoryProvider).getVenues();
});

final createSessionRecentProvider =
    FutureProvider.autoDispose<List<RecentSessionOption>>((ref) {
  return ref.watch(organizerRepositoryProvider).getRecentSessions();
});

class CreateSessionDraftNotifier extends Notifier<CreateSessionDraft> {
  CreateSessionDraft? _baseline;

  @override
  CreateSessionDraft build() => const CreateSessionDraft();

  /// Seed the draft from an existing session's edit-payload and snapshot a
  /// baseline for dirty-tracking.
  void hydrate(CreateSessionDraft draft) {
    _baseline = draft;
    state = draft;
  }

  /// True once the hydrated draft differs from its baseline (edit mode).
  bool get isDirty => _baseline != null && state != _baseline;

  // ── Step 1 ──
  void setType(SessionType type) {
    // Capacity is meaningless for private sessions.
    state = state.copyWith(
      type: type,
      capacity: type == SessionType.private ? null : state.capacity,
    );
  }

  void setTitle(String title) => state = state.copyWith(title: title);

  void setCoaches(List<int> ids) => state = state.copyWith(coachIds: ids);

  void toggleCoach(int id) {
    final ids = [...state.coachIds];
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = state.copyWith(coachIds: ids);
  }

  // ── Step 2 ──
  void setDate(DateTime date) => state = state.copyWith(date: date);
  void setStartTime(String time) => state = state.copyWith(startTime: time);
  void setDuration(int minutes) =>
      state = state.copyWith(durationMinutes: minutes);

  /// [maxSpots] null = unlimited.
  void setCapacity(int? maxSpots) => state = state.copyWith(capacity: maxSpots);

  void setVenue({required String id, required String name}) =>
      state = state.copyWith(venueId: id, venueName: name);
  void clearVenue() =>
      state = state.copyWith(venueId: null, venueName: null);

  /// [minorUnits] null = free.
  void setPrice(int? minorUnits) => state = state.copyWith(price: minorUnits);
  void setNotes(String notes) => state = state.copyWith(notes: notes);

  // ── Accelerator ──
  /// Replace the draft with a duplicate payload (title & date already cleared
  /// by the repo, per the admin duplicate behaviour).
  void applyDuplicate(CreateSessionDraft payload) => state = payload;

  // ── Submit ──
  Future<OpenSession> submit() async {
    final repo = ref.read(organizerRepositoryProvider);
    final result = state.sessionId == null
        ? await repo.createSession(state)
        : await repo.updateSession(state.sessionId!.toString(), state);
    _invalidateOrganizerQueries();
    if (state.sessionId != null) {
      ref.invalidate(
        organizerSessionDetailProvider(state.sessionId!.toString()),
      );
    }
    return result;
  }

  void reset() {
    _baseline = null;
    state = const CreateSessionDraft();
  }

  void _invalidateOrganizerQueries() {
    ref.invalidate(organizerDashboardProvider);
    ref.invalidate(organizerSessionsProvider);
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);
    ref.invalidate(organizerAgendaProvider);
    ref.invalidate(organizerActionInboxProvider);
    ref.invalidate(organizerEarningsProvider);
  }
}
