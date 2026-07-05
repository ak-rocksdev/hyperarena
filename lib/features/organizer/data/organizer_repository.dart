import 'dart:io';

import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/data/models/session_financial.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

abstract class OrganizerRepository {
  Future<OrganizerDashboardStats> getDashboard();
  Future<List<OpenSession>> getMySessions({bool upcomingOnly = false});
  Future<List<OpenSession>> getAgenda({
    required DateTime from,
    required DateTime to,
  });
  Future<OpenSession> getSessionDetail(String sessionId);

  Future<OpenSession> createSession(CreateSessionDraft draft);

  // ── Create-session lookups & helpers ──
  /// Coaches assignable to a session (tenant scope).
  Future<List<CoachOption>> getCoaches();

  /// Active venues selectable for a session.
  Future<List<VenueOption>> getVenues();

  /// Recent sessions offered by the "duplicate" accelerator.
  Future<List<RecentSessionOption>> getRecentSessions();

  /// Pre-fill payload for duplicating [sessionId] (title & date cleared).
  Future<CreateSessionDraft> getDuplicatePayload(String sessionId);

  /// Whether the tenant has configured payout/bank details — a precondition
  /// for creating any session.
  Future<bool> isPayoutConfigured();

  /// Upload a cover photo to an already-created session.
  Future<void> uploadSessionCoverPhoto(String sessionId, File photo);

  Future<OpenSession> updateSession(String sessionId, CreateSessionDraft draft);
  Future<OpenSession> duplicateSession(
    String sessionId, {
    required DateTime newDate,
  });
  Future<OpenSession> createFromTemplate(String templateId, DateTime date);
  Future<OpenSession> rescheduleSession(
    String sessionId, {
    required DateTime newDate,
    required String newStartTime,
    required String newEndTime,
  });
  Future<OpenSession> cancelSession(String sessionId, {required String reason});
  Future<OpenSession> completeSession(String sessionId);

  Future<List<SessionParticipant>> getParticipants(String sessionId);
  Future<SessionParticipant> confirmParticipant(String participantId);
  Future<SessionParticipant> rejectParticipant(
    String participantId, {
    required String reason,
  });
  Future<SessionParticipant> markNoShow(String participantId);
  Future<SessionParticipant> requestRefund(
    String participantId, {
    required String reason,
  });
  Future<SessionParticipant> resolveDispute(
    String participantId, {
    required String resolution,
  });

  /// Admin-only. [bookingId] is `SessionStudent.id` (FE field `bookingId`).
  /// [status] is one of `present`, `late`, `absent`, `not_recorded`.
  Future<void> setAttendance(String bookingId, String status);

  Future<List<OrganizerActionItem>> getActionInbox({
    OrganizerActionType? type,
    OrganizerActionSeverity? severity,
  });
  Future<void> sendParticipantMessage(
    String sessionId, {
    required String templateCode,
    String? customMessage,
    bool pendingOnly = false,
  });

  Future<OrganizerEarningsSummary> getEarningsSummary();
  Future<OrganizerSessionSettlement> getSessionSettlement(String sessionId);
  Future<SessionFinancial> getSessionFinancial(String sessionId);

  Future<ClubProfile> getClubProfile();
  Future<List<ClubMember>> getClubMembers();
  Future<Map<String, String>> getSessionTemplates();
}
