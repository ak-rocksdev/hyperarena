import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/organizer/data/mock_organizer_repository.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';

final organizerRepositoryProvider = Provider<OrganizerRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return MockOrganizerRepository(config);
});

final organizerDateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  return DateTimeRange(
    start: DateTime(now.year, now.month, now.day),
    end: DateTime(now.year, now.month, now.day).add(const Duration(days: 7)),
  );
});

final organizerDashboardProvider = FutureProvider<OrganizerDashboardStats>((
  ref,
) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getDashboard();
});

final organizerSessionsProvider = FutureProvider<List<OpenSession>>((ref) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getMySessions();
});

final organizerUpcomingSessionsProvider = FutureProvider<List<OpenSession>>((
  ref,
) async {
  final repo = ref.watch(organizerRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final sessions = await repo.getMySessions();
  return sessions.where((s) => !s.date.isBefore(today)).toList();
});

final organizerPastSessionsProvider = FutureProvider<List<OpenSession>>((
  ref,
) async {
  final repo = ref.watch(organizerRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final sessions = await repo.getMySessions();
  return sessions.where((s) => s.date.isBefore(today)).toList();
});

final organizerAgendaProvider = FutureProvider<List<OpenSession>>((ref) async {
  final repo = ref.watch(organizerRepositoryProvider);
  final range = ref.watch(organizerDateRangeProvider);
  return repo.getAgenda(from: range.start, to: range.end);
});

final organizerActionTypeFilterProvider = StateProvider<OrganizerActionType?>(
  (ref) => null,
);
final organizerActionSeverityFilterProvider =
    StateProvider<OrganizerActionSeverity?>((ref) => null);

final organizerActionInboxProvider = FutureProvider<List<OrganizerActionItem>>((
  ref,
) {
  final repo = ref.watch(organizerRepositoryProvider);
  final type = ref.watch(organizerActionTypeFilterProvider);
  final severity = ref.watch(organizerActionSeverityFilterProvider);
  return repo.getActionInbox(type: type, severity: severity);
});

final organizerSessionDetailProvider =
    FutureProvider.family<OpenSession, String>((ref, sessionId) {
      final repo = ref.watch(organizerRepositoryProvider);
      return repo.getSessionDetail(sessionId);
    });

final organizerParticipantsProvider =
    FutureProvider.family<List<SessionParticipant>, String>((ref, sessionId) {
      final repo = ref.watch(organizerRepositoryProvider);
      return repo.getParticipants(sessionId);
    });

final organizerEarningsProvider = FutureProvider<OrganizerEarningsSummary>((
  ref,
) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getEarningsSummary();
});

final clubProfileProvider = FutureProvider<ClubProfile>((ref) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getClubProfile();
});

final clubMembersProvider = FutureProvider<List<ClubMember>>((ref) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getClubMembers();
});

final organizerTemplatesProvider = FutureProvider<Map<String, String>>((ref) {
  final repo = ref.watch(organizerRepositoryProvider);
  return repo.getSessionTemplates();
});
