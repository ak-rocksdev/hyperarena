import 'dart:math';

import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

class MockOrganizerRepository implements OrganizerRepository {
  MockOrganizerRepository(this.config);

  final AppConfig config;
  static const _organizerId = 'organizer-001';

  List<OpenSession> get _mySessions =>
      MockData.sessions.where((s) => s.hostId == _organizerId).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  List<SessionParticipant> _participantsBySession(String sessionId) => MockData
      .sessionParticipants
      .where((p) => p.sessionId == sessionId)
      .toList();

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);

  OpenSession _applyDraftToSession(OpenSession base, CreateSessionDraft draft) {
    return base.copyWith(
      title: draft.title ?? base.title,
      description: draft.description ?? base.description,
      sport: draft.sport ?? base.sport,
      minLevel: draft.minLevel ?? base.minLevel,
      maxLevel: draft.maxLevel ?? base.maxLevel,
      venueId: draft.venueId ?? base.venueId,
      venueName: draft.venueName ?? base.venueName,
      date: draft.date ?? base.date,
      startTime: draft.startTime ?? base.startTime,
      endTime: draft.endTime ?? base.endTime,
      pricePerPerson: draft.pricePerPerson ?? base.pricePerPerson,
      maxPlayers: draft.maxParticipants,
      joinDeadline: draft.joinDeadline ?? base.joinDeadline,
      pricingModel: draft.pricingModel,
      visibility: draft.visibility,
      courtCost: draft.courtCost ?? base.courtCost,
      coachCost: draft.coachCost ?? base.coachCost,
      organizerFeePerPerson:
          draft.organizerFeePerPerson ?? base.organizerFeePerPerson,
    );
  }

  @override
  Future<OrganizerDashboardStats> getDashboard() async {
    await Future.delayed(config.mockDelay);
    final now = DateTime.now();
    final next7 = now.add(const Duration(days: 7));
    final sessions = _mySessions;
    final upcoming = sessions.where((s) => !s.date.isBefore(_startOfDay(now)));
    final next7Sessions = upcoming
        .where(
          (s) =>
              !s.date.isBefore(_startOfDay(now)) &&
              !s.date.isAfter(_endOfDay(next7)),
        )
        .toList();
    final allParticipants = MockData.sessionParticipants
        .where((p) => sessions.any((s) => s.id == p.sessionId))
        .toList();

    final avgParticipants = sessions.isEmpty
        ? 0.0
        : sessions
                  .map((s) => s.currentPlayers.toDouble())
                  .reduce((a, b) => a + b) /
              sessions.length;

    final pendingPayments = allParticipants
        .where((p) => p.status == SessionParticipantStatus.pendingPayment)
        .length;
    final atRisk = sessions
        .where((s) => s.health.isLowSignupRisk || s.health.isJoinDeadlineAtRisk)
        .length;

    final earnings = await getEarningsSummary();

    return OrganizerDashboardStats(
      sessionsToday: sessions.where((s) => _isSameDate(s.date, now)).length,
      sessionsNext7Days: next7Sessions.length,
      pendingPayments: pendingPayments,
      averageParticipants: avgParticipants,
      averageRating: 4.7,
      monthlyEarnings: earnings.availableBalance + earnings.pendingBalance,
      atRiskSessions: atRisk,
    );
  }

  @override
  Future<List<OpenSession>> getMySessions({bool upcomingOnly = false}) async {
    await Future.delayed(config.mockDelay);
    if (!upcomingOnly) {
      return _mySessions;
    }
    final today = _startOfDay(DateTime.now());
    return _mySessions.where((s) => !s.date.isBefore(today)).toList();
  }

  @override
  Future<List<OpenSession>> getAgenda({
    required DateTime from,
    required DateTime to,
  }) async {
    await Future.delayed(config.mockDelay);
    final rangeStart = _startOfDay(from);
    final rangeEnd = _endOfDay(to);
    return _mySessions
        .where((s) => !s.date.isBefore(rangeStart) && !s.date.isAfter(rangeEnd))
        .toList();
  }

  @override
  Future<OpenSession> getSessionDetail(String sessionId) async {
    await Future.delayed(config.mockDelay);
    return _mySessions.firstWhere((s) => s.id == sessionId);
  }

  @override
  Future<OpenSession> createSession(CreateSessionDraft draft) async {
    await Future.delayed(config.mockDelay);
    final now = DateTime.now();
    final id = 'session-${now.millisecondsSinceEpoch}';

    final session = OpenSession(
      id: id,
      title: draft.title ?? 'Session Baru',
      sport: draft.sport ?? MockData.sessions.first.sport,
      hostId: _organizerId,
      hostName: MockData.organizerUser.name,
      venueName: draft.venueName ?? 'Venue Belum Dipilih',
      venueId: draft.venueId ?? MockData.venues.first.id,
      date: draft.date ?? now.add(const Duration(days: 1)),
      startTime: draft.startTime ?? '19:00',
      endTime: draft.endTime ?? '21:00',
      currentPlayers: 1,
      maxPlayers: draft.maxParticipants,
      minLevel: draft.minLevel,
      maxLevel: draft.maxLevel,
      pricePerPerson: draft.pricePerPerson ?? 100000,
      description: draft.description,
      participantNames: [MockData.organizerUser.name],
      status: OpenSessionStatus.open,
      joinDeadline: draft.joinDeadline ?? now.add(const Duration(hours: 12)),
      pricingModel: draft.pricingModel,
      visibility: draft.visibility,
      courtCost: draft.courtCost,
      coachCost: draft.coachCost,
      organizerFeePerPerson: draft.organizerFeePerPerson,
      settlementStatus: SessionSettlementStatus.pending,
      health: const SessionHealth(),
    );
    MockData.upsertSession(session);
    return session;
  }

  @override
  Future<OpenSession> updateSession(
    String sessionId,
    CreateSessionDraft draft,
  ) async {
    await Future.delayed(config.mockDelay);
    final current = await getSessionDetail(sessionId);
    final updated = _applyDraftToSession(current, draft);
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<OpenSession> duplicateSession(
    String sessionId, {
    required DateTime newDate,
  }) async {
    await Future.delayed(config.mockDelay);
    final source = await getSessionDetail(sessionId);
    final duplicate = source.copyWith(
      id: 'session-${DateTime.now().millisecondsSinceEpoch}',
      date: newDate,
      joinDeadline: newDate.subtract(const Duration(hours: 8)),
      currentPlayers: 1,
      participantNames: [source.hostName],
      status: OpenSessionStatus.open,
      settlementStatus: SessionSettlementStatus.pending,
      health: const SessionHealth(),
    );
    MockData.upsertSession(duplicate);
    return duplicate;
  }

  @override
  Future<OpenSession> createFromTemplate(
    String templateId,
    DateTime date,
  ) async {
    await Future.delayed(config.mockDelay);
    final totalSessions = MockData.sessions.isEmpty
        ? 1
        : MockData.sessions.length;
    final seed = templateId.hashCode.abs() % totalSessions;
    final source = MockData.sessions[seed];
    return duplicateSession(source.id, newDate: date);
  }

  @override
  Future<OpenSession> rescheduleSession(
    String sessionId, {
    required DateTime newDate,
    required String newStartTime,
    required String newEndTime,
  }) async {
    await Future.delayed(config.mockDelay);
    final current = await getSessionDetail(sessionId);
    final updated = current.copyWith(
      date: newDate,
      startTime: newStartTime,
      endTime: newEndTime,
    );
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<OpenSession> cancelSession(
    String sessionId, {
    required String reason,
  }) async {
    await Future.delayed(config.mockDelay);
    final current = await getSessionDetail(sessionId);
    final updated = current.copyWith(status: OpenSessionStatus.cancelled);
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<OpenSession> completeSession(String sessionId) async {
    await Future.delayed(config.mockDelay);
    final current = await getSessionDetail(sessionId);
    final updated = current.copyWith(status: OpenSessionStatus.completed);
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<List<SessionParticipant>> getParticipants(String sessionId) async {
    await Future.delayed(config.mockDelay);
    return _participantsBySession(sessionId);
  }

  Booking? _findBookingForParticipant(SessionParticipant participant) {
    if (participant.bookingId == null) return null;
    final matches = MockData.bookings.where(
      (b) => b.id == participant.bookingId,
    );
    return matches.isEmpty ? null : matches.first;
  }

  Future<SessionParticipant> _updateParticipant(
    String participantId,
    SessionParticipantStatus status, {
    String? reason,
  }) async {
    final current = MockData.sessionParticipants.firstWhere(
      (p) => p.id == participantId,
    );
    final now = DateTime.now();
    final updated = current.copyWith(
      status: status,
      confirmedAt: status == SessionParticipantStatus.confirmed
          ? now
          : current.confirmedAt,
      rejectionReason: status == SessionParticipantStatus.rejected
          ? reason
          : current.rejectionReason,
      refundReason: status == SessionParticipantStatus.refunded
          ? reason
          : current.refundReason,
      disputeReason: status == SessionParticipantStatus.disputed
          ? reason
          : current.disputeReason,
      note: reason ?? current.note,
    );
    MockData.upsertParticipant(updated);

    final booking = _findBookingForParticipant(updated);
    if (booking != null) {
      final mappedStatus = switch (status) {
        SessionParticipantStatus.confirmed => booking.copyWith(
          status: BookingStatus.confirmed,
        ),
        SessionParticipantStatus.rejected => booking.copyWith(
          status: BookingStatus.rejected,
        ),
        SessionParticipantStatus.cancelledByPlayer => booking.copyWith(
          status: BookingStatus.cancelled,
        ),
        SessionParticipantStatus.pendingPayment => booking.copyWith(
          status: BookingStatus.pendingPayment,
        ),
        _ => booking,
      };
      MockData.upsertBooking(mappedStatus);
    }

    return updated;
  }

  @override
  Future<SessionParticipant> confirmParticipant(String participantId) async {
    await Future.delayed(config.mockDelay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.confirmed,
    );
  }

  @override
  Future<SessionParticipant> rejectParticipant(
    String participantId, {
    required String reason,
  }) async {
    await Future.delayed(config.mockDelay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.rejected,
      reason: reason,
    );
  }

  @override
  Future<SessionParticipant> markNoShow(String participantId) async {
    await Future.delayed(config.mockDelay);
    return _updateParticipant(participantId, SessionParticipantStatus.noShow);
  }

  @override
  Future<SessionParticipant> requestRefund(
    String participantId, {
    required String reason,
  }) async {
    await Future.delayed(config.mockDelay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.refunded,
      reason: reason,
    );
  }

  @override
  Future<SessionParticipant> resolveDispute(
    String participantId, {
    required String resolution,
  }) async {
    await Future.delayed(config.mockDelay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.confirmed,
      reason: resolution,
    );
  }

  @override
  Future<List<OrganizerActionItem>> getActionInbox({
    OrganizerActionType? type,
    OrganizerActionSeverity? severity,
  }) async {
    await Future.delayed(config.mockDelay);
    final items = <OrganizerActionItem>[];
    final sessions = _mySessions;
    final now = DateTime.now();

    for (final session in sessions) {
      final participants = _participantsBySession(session.id);
      final pending = participants
          .where((p) => p.status == SessionParticipantStatus.pendingPayment)
          .length;
      if (pending > 0) {
        items.add(
          OrganizerActionItem(
            id: 'ai-pending-${session.id}',
            type: OrganizerActionType.confirmPayment,
            severity: OrganizerActionSeverity.high,
            title: 'Konfirmasi $pending pembayaran',
            subtitle: '${session.title} membutuhkan verifikasi pembayaran.',
            sessionId: session.id,
            dueAt: session.joinDeadline,
          ),
        );
      }

      final disputed = participants
          .where((p) => p.status == SessionParticipantStatus.disputed)
          .length;
      if (disputed > 0) {
        items.add(
          OrganizerActionItem(
            id: 'ai-dispute-${session.id}',
            type: OrganizerActionType.dispute,
            severity: OrganizerActionSeverity.high,
            title: '$disputed sengketa pembayaran',
            subtitle: 'Butuh penyelesaian cepat untuk ${session.title}.',
            sessionId: session.id,
          ),
        );
      }

      if (session.health.isLowSignupRisk ||
          (session.joinDeadline != null &&
              session.joinDeadline!.isAfter(now) &&
              session.joinDeadline!.difference(now).inHours <= 6)) {
        items.add(
          OrganizerActionItem(
            id: 'ai-risk-${session.id}',
            type: OrganizerActionType.sessionRisk,
            severity: OrganizerActionSeverity.medium,
            title: 'Risiko kuota pada ${session.title}',
            subtitle: 'Pertimbangkan reminder atau reschedule.',
            sessionId: session.id,
            dueAt: session.joinDeadline,
          ),
        );
      }
    }

    var filtered = items;
    if (type != null) {
      filtered = filtered.where((i) => i.type == type).toList();
    }
    if (severity != null) {
      filtered = filtered.where((i) => i.severity == severity).toList();
    }
    filtered.sort((a, b) {
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
    return filtered;
  }

  @override
  Future<void> sendParticipantMessage(
    String sessionId, {
    required String templateCode,
    String? customMessage,
    bool pendingOnly = false,
  }) async {
    await Future.delayed(config.mockDelay);
  }

  @override
  Future<OrganizerEarningsSummary> getEarningsSummary() async {
    await Future.delayed(config.mockDelay);
    final settlements = _mySessions.map((session) {
      final gross = session.currentPlayers * session.pricePerPerson;
      final estimatedCost = (session.courtCost ?? 0) + (session.coachCost ?? 0);
      final organizerFee = session.organizerFeePerPerson != null
          ? session.organizerFeePerPerson! * session.currentPlayers
          : max(0, gross - estimatedCost);
      final net = max(0, gross - estimatedCost);
      return OrganizerSessionSettlement(
        sessionId: session.id,
        title: session.title,
        date: session.date,
        grossRevenue: gross,
        organizerFee: organizerFee,
        estimatedCost: estimatedCost,
        netRevenue: net,
        settlementStatus: session.settlementStatus,
      );
    }).toList()..sort((a, b) => b.date.compareTo(a.date));

    final available = settlements
        .where((s) => s.settlementStatus == SessionSettlementStatus.cleared)
        .fold<int>(0, (sum, s) => sum + s.netRevenue);
    final pending = settlements
        .where((s) => s.settlementStatus == SessionSettlementStatus.pending)
        .fold<int>(0, (sum, s) => sum + s.netRevenue);
    final paidOut = settlements
        .where((s) => s.settlementStatus == SessionSettlementStatus.paidOut)
        .fold<int>(0, (sum, s) => sum + s.netRevenue);

    return OrganizerEarningsSummary(
      availableBalance: available,
      pendingBalance: pending,
      paidOutThisMonth: paidOut,
      settlements: settlements,
    );
  }

  @override
  Future<OrganizerSessionSettlement> getSessionSettlement(
    String sessionId,
  ) async {
    await Future.delayed(config.mockDelay);
    final earnings = await getEarningsSummary();
    return earnings.settlements.firstWhere((s) => s.sessionId == sessionId);
  }

  @override
  Future<ClubProfile> getClubProfile() async {
    await Future.delayed(config.mockDelay);
    return MockData.clubProfile;
  }

  @override
  Future<List<ClubMember>> getClubMembers() async {
    await Future.delayed(config.mockDelay);
    return MockData.clubMembers;
  }

  @override
  Future<Map<String, String>> getSessionTemplates() async {
    await Future.delayed(config.mockDelay);
    return MockData.organizerSessionTemplates;
  }
}
