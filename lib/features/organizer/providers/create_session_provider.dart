import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

final createSessionDraftProvider =
    NotifierProvider<CreateSessionDraftNotifier, CreateSessionDraft>(
      CreateSessionDraftNotifier.new,
    );

class CreateSessionDraftNotifier extends Notifier<CreateSessionDraft> {
  @override
  CreateSessionDraft build() => const CreateSessionDraft();

  void setTemplate(String? templateId) {
    state = state.copyWith(templateId: templateId);
  }

  void setTitle(String title) => state = state.copyWith(title: title);
  void setDescription(String description) =>
      state = state.copyWith(description: description);
  void setSport(Sport sport) => state = state.copyWith(sport: sport);
  void setLevelRange(LevelTier? min, LevelTier? max) =>
      state = state.copyWith(minLevel: min, maxLevel: max);
  void setVenue({required String id, required String name}) =>
      state = state.copyWith(venueId: id, venueName: name);
  void setDate(DateTime date) => state = state.copyWith(date: date);
  void setTimeRange(String startTime, String endTime) =>
      state = state.copyWith(startTime: startTime, endTime: endTime);
  void setPrice(int price) => state = state.copyWith(pricePerPerson: price);
  void setParticipants({required int min, required int max}) =>
      state = state.copyWith(minParticipants: min, maxParticipants: max);
  void setJoinDeadline(DateTime dateTime) =>
      state = state.copyWith(joinDeadline: dateTime);
  void setPricingModel(SessionPricingModel model) =>
      state = state.copyWith(pricingModel: model);
  void setVisibility(SessionVisibility visibility) =>
      state = state.copyWith(visibility: visibility);
  void setCostBreakdown({
    int? courtCost,
    int? coachCost,
    int? organizerFeePerPerson,
  }) {
    state = state.copyWith(
      courtCost: courtCost,
      coachCost: coachCost,
      organizerFeePerPerson: organizerFeePerPerson,
    );
  }

  Future<OpenSession> submit() async {
    final repo = ref.read(organizerRepositoryProvider);
    final created = await repo.createSession(state);
    _invalidateOrganizerQueries();
    return created;
  }

  Future<OpenSession> update(String sessionId) async {
    final repo = ref.read(organizerRepositoryProvider);
    final updated = await repo.updateSession(sessionId, state);
    _invalidateOrganizerQueries(sessionId: sessionId);
    return updated;
  }

  Future<OpenSession> duplicateFromSession(
    String sessionId, {
    required DateTime newDate,
  }) async {
    final repo = ref.read(organizerRepositoryProvider);
    final duplicated = await repo.duplicateSession(sessionId, newDate: newDate);
    _invalidateOrganizerQueries();
    return duplicated;
  }

  Future<OpenSession> createFromTemplate(
    String templateId, {
    required DateTime date,
  }) async {
    final repo = ref.read(organizerRepositoryProvider);
    final created = await repo.createFromTemplate(templateId, date);
    _invalidateOrganizerQueries();
    return created;
  }

  void reset() {
    state = const CreateSessionDraft();
  }

  void _invalidateOrganizerQueries({String? sessionId}) {
    ref.invalidate(organizerDashboardProvider);
    ref.invalidate(organizerSessionsProvider);
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);
    ref.invalidate(organizerAgendaProvider);
    ref.invalidate(organizerActionInboxProvider);
    ref.invalidate(organizerEarningsProvider);
    if (sessionId != null) {
      ref.invalidate(organizerSessionDetailProvider(sessionId));
      ref.invalidate(organizerParticipantsProvider(sessionId));
    }
  }
}
