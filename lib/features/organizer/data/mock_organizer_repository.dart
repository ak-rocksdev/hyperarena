import 'dart:io';
import 'dart:math';

import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/data/models/session_financial.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

class MockOrganizerRepository implements OrganizerRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  MockOrganizerRepository();

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

  /// End time as "HH:mm" from a start time + duration (mock display only —
  /// the real model is start_at + duration_minutes).
  String _endTimeFrom(String? startTime, int durationMinutes) {
    if (startTime == null) return '00:00';
    final parts = startTime.split(':');
    final start = (int.tryParse(parts.first) ?? 0) * 60 +
        (parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0);
    final end = (start + durationMinutes) % (24 * 60);
    return '${(end ~/ 60).toString().padLeft(2, '0')}:'
        '${(end % 60).toString().padLeft(2, '0')}';
  }

  OpenSession _applyDraftToSession(OpenSession base, CreateSessionDraft draft) {
    return base.copyWith(
      title: draft.title ?? base.title,
      description: draft.notes ?? base.description,
      venueId: draft.venueId ?? base.venueId,
      venueName: draft.venueName ?? base.venueName,
      date: draft.date ?? base.date,
      startTime: draft.startTime ?? base.startTime,
      endTime: _endTimeFrom(draft.startTime ?? base.startTime, draft.durationMinutes),
      pricePerPerson: draft.price ?? base.pricePerPerson,
      maxPlayers: draft.capacity ?? base.maxPlayers,
    );
  }

  @override
  Future<OrganizerDashboardStats> getDashboard() async {
    await Future.delayed(_delay);
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

    final pendingParticipants = allParticipants
        .where((p) => p.status == SessionParticipantStatus.pendingPayment)
        .toList();
    final pendingPayments = pendingParticipants.length;
    final atRisk = sessions
        .where((s) => s.health.isLowSignupRisk || s.health.isJoinDeadlineAtRisk)
        .length;

    final earnings = await getEarningsSummary();

    // Compute total unpaid amount across all pending payments
    final totalUnpaidAmount = pendingParticipants.fold<int>(0, (sum, p) {
      final session = sessions.where((s) => s.id == p.sessionId);
      if (session.isEmpty) return sum;
      return sum + session.first.pricePerPerson;
    });

    // Today's revenue calculations
    final todaySessions = sessions.where((s) => _isSameDate(s.date, now));
    final revenueExpectedToday = todaySessions.fold<int>(
      0,
      (sum, s) => sum + (s.currentPlayers * s.pricePerPerson),
    );
    final revenueCollectedToday = revenueExpectedToday -
        todaySessions.fold<int>(
          0,
          (sum, s) => sum + (s.health.pendingPayments * s.pricePerPerson),
        );

    return OrganizerDashboardStats(
      sessionsToday: todaySessions.length,
      sessionsNext7Days: next7Sessions.length,
      pendingPayments: pendingPayments,
      averageParticipants: avgParticipants,
      averageRating: 4.7,
      monthlyEarnings: earnings.availableBalance + earnings.pendingBalance,
      atRiskSessions: atRisk,
      totalUnpaidAmount: totalUnpaidAmount,
      revenueCollectedToday: revenueCollectedToday,
      revenueExpectedToday: revenueExpectedToday,
    );
  }

  @override
  Future<List<OpenSession>> getMySessions({bool upcomingOnly = false}) async {
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
    final rangeStart = _startOfDay(from);
    final rangeEnd = _endOfDay(to);
    return _mySessions
        .where((s) => !s.date.isBefore(rangeStart) && !s.date.isAfter(rangeEnd))
        .toList();
  }

  @override
  Future<OpenSession> getSessionDetail(String sessionId) async {
    await Future.delayed(_delay);
    return _mySessions.firstWhere((s) => s.id == sessionId);
  }

  @override
  Future<OpenSession> createSession(CreateSessionDraft draft) async {
    await Future.delayed(_delay);
    final now = DateTime.now();
    final id = 'session-${now.millisecondsSinceEpoch}';

    final session = OpenSession(
      id: id,
      title: draft.title?.trim().isNotEmpty == true
          ? draft.title!.trim()
          : 'Sesi Baru',
      sport: MockData.sessions.first.sport,
      hostId: _organizerId,
      hostName: MockData.organizerUser.name,
      venueName: draft.venueName ?? 'Venue Belum Dipilih',
      venueId: draft.venueId ?? MockData.venues.first.id,
      date: draft.date ?? now.add(const Duration(days: 1)),
      startTime: draft.startTime ?? '19:00',
      endTime: _endTimeFrom(draft.startTime ?? '19:00', draft.durationMinutes),
      currentPlayers: 1,
      maxPlayers: draft.capacity ?? 99,
      pricePerPerson: draft.price ?? 0,
      description: draft.notes,
      participantNames: [MockData.organizerUser.name],
      status: OpenSessionStatus.open,
      settlementStatus: SessionSettlementStatus.pending,
      health: const SessionHealth(),
    );
    MockData.upsertSession(session);
    return session;
  }

  @override
  Future<List<CoachOption>> getCoaches() async {
    await Future.delayed(_delay);
    return const [
      CoachOption(id: 1, name: 'Coach Joko', ratePerSession: 150000, currency: 'IDR'),
      CoachOption(id: 2, name: 'Coach Aditya', ratePerSession: 200000, currency: 'IDR'),
      CoachOption(id: 3, name: 'Coach Bima', ratePerSession: 175000, currency: 'IDR'),
      CoachOption(id: 4, name: 'Coach Sari', ratePerSession: 160000, currency: 'IDR'),
    ];
  }

  /// Venues created in-session via [createVenue] (mock persistence).
  final List<VenueOption> _createdVenues = [];

  @override
  Future<List<VenueOption>> getVenues() async {
    await Future.delayed(_delay);
    return [
      ...MockData.venues.map((v) => VenueOption(id: v.id, name: v.name)),
      ..._createdVenues,
    ];
  }

  @override
  Future<List<PlacePrediction>> placesAutocomplete(
      String query, String sessionToken) async {
    await Future.delayed(_delay);
    // Offline/demo repo has no Google Places — surface a single echo row so
    // the create-venue flow is still exercisable without a network.
    if (query.trim().isEmpty) return [];
    return [
      PlacePrediction(
        placeId: 'mock:$query',
        mainText: query,
        secondaryText: 'Contoh lokasi (mock)',
      ),
    ];
  }

  @override
  Future<PlaceDetails?> placeDetails(String placeId, String sessionToken) async {
    await Future.delayed(_delay);
    final name = placeId.startsWith('mock:') ? placeId.substring(5) : 'Venue';
    return PlaceDetails(
      googlePlaceId: placeId,
      name: name,
      address: 'Jakarta, Indonesia',
      lat: -6.2088,
      lng: 106.8456,
    );
  }

  @override
  Future<VenueOption> createVenue({
    required String name,
    String? googlePlaceId,
    String? address,
    double? lat,
    double? lng,
  }) async {
    await Future.delayed(_delay);
    // Numeric id so `toCreatePayload`'s int.tryParse keeps working.
    final venue = VenueOption(id: '${900 + _createdVenues.length}', name: name);
    _createdVenues.add(venue);
    return venue;
  }

  @override
  Future<List<RecentSessionOption>> getRecentSessions() async {
    await Future.delayed(_delay);
    final sessions = [..._mySessions]..sort((a, b) => b.date.compareTo(a.date));
    return sessions.take(10).map((s) {
      final parts = s.startTime.split(':');
      final startAt = DateTime(
        s.date.year,
        s.date.month,
        s.date.day,
        int.tryParse(parts.first) ?? 0,
        parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
      );
      return RecentSessionOption(
        id: s.id,
        startAt: startAt,
        type: SessionType.group,
        coachName: s.hostName,
        venueName: s.venueName,
        createdAt: s.date,
      );
    }).toList();
  }

  @override
  Future<CreateSessionDraft> getDuplicatePayload(String sessionId) async {
    await Future.delayed(_delay);
    final s = await getSessionDetail(sessionId);
    // Title & date are intentionally left blank (admin duplicate behaviour).
    return CreateSessionDraft(
      type: SessionType.group,
      capacity: s.maxPlayers >= 99 ? null : s.maxPlayers,
      venueId: s.venueId,
      venueName: s.venueName,
      price: s.pricePerPerson,
      notes: s.description,
    );
  }

  @override
  Future<bool> isPayoutConfigured() async {
    await Future.delayed(_delay);
    return true; // flip to false to exercise the payment guard in the demo
  }

  @override
  Future<void> uploadSessionCoverPhoto(String sessionId, File photo) async {
    await Future.delayed(_delay);
    // no-op in mock
  }

  @override
  Future<OpenSession> updateSession(
    String sessionId,
    CreateSessionDraft draft,
  ) async {
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
    final current = await getSessionDetail(sessionId);
    final updated = current.copyWith(status: OpenSessionStatus.cancelled);
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<OpenSession> completeSession(String sessionId) async {
    await Future.delayed(_delay);
    final current = await getSessionDetail(sessionId);
    final updated = current.copyWith(status: OpenSessionStatus.completed);
    MockData.upsertSession(updated);
    return updated;
  }

  @override
  Future<List<SessionParticipant>> getParticipants(String sessionId) async {
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.rejected,
      reason: reason,
    );
  }

  @override
  Future<SessionParticipant> markNoShow(String participantId) async {
    await Future.delayed(_delay);
    return _updateParticipant(participantId, SessionParticipantStatus.noShow);
  }

  @override
  Future<SessionParticipant> requestRefund(
    String participantId, {
    required String reason,
  }) async {
    await Future.delayed(_delay);
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
    await Future.delayed(_delay);
    return _updateParticipant(
      participantId,
      SessionParticipantStatus.confirmed,
      reason: resolution,
    );
  }

  @override
  Future<void> setAttendance(String bookingId, String status) async {
    await Future.delayed(_delay);
  }

  @override
  Future<List<OrganizerActionItem>> getActionInbox({
    OrganizerActionType? type,
    OrganizerActionSeverity? severity,
  }) async {
    await Future.delayed(_delay);
    final items = <OrganizerActionItem>[];
    final sessions = _mySessions;
    final now = DateTime.now();

    for (final session in sessions) {
      final participants = _participantsBySession(session.id);
      final pending = participants
          .where((p) => p.status == SessionParticipantStatus.pendingPayment)
          .length;
      final pendingAmount = pending * session.pricePerPerson;
      final sessionTimeToStart = session.date.isAfter(now)
          ? session.date.difference(now)
          : null;

      if (pending > 0) {
        items.add(
          OrganizerActionItem(
            id: 'ai-pending-${session.id}',
            type: OrganizerActionType.confirmPayment,
            severity: OrganizerActionSeverity.high,
            title: 'Konfirmasi $pending pembayaran',
            subtitle: '${session.safeTitle} membutuhkan verifikasi pembayaran.',
            sessionId: session.id,
            dueAt: session.joinDeadline,
            amountImpact: pendingAmount,
            timeToStart: sessionTimeToStart,
          ),
        );
      }

      final disputedParticipants = participants
          .where((p) => p.status == SessionParticipantStatus.disputed)
          .toList();
      for (final dp in disputedParticipants) {
        items.add(
          OrganizerActionItem(
            id: 'ai-dispute-${session.id}-${dp.id}',
            type: OrganizerActionType.dispute,
            severity: OrganizerActionSeverity.high,
            title: 'Komplain: ${dp.playerName}',
            subtitle: dp.disputeReason ?? '${session.safeTitle} — komplain pemain.',
            sessionId: session.id,
            participantId: dp.id,
            amountImpact: session.pricePerPerson,
          ),
        );
      }

      if (session.health.isLowSignupRisk ||
          (session.joinDeadline != null &&
              session.joinDeadline!.isAfter(now) &&
              session.joinDeadline!.difference(now).inHours <= 6)) {
        final slotsLeft = session.maxPlayers - session.currentPlayers;
        items.add(
          OrganizerActionItem(
            id: 'ai-risk-${session.id}',
            type: OrganizerActionType.sessionRisk,
            severity: OrganizerActionSeverity.medium,
            title: 'Kuota rendah: $slotsLeft slot lagi',
            subtitle: session.safeTitle,
            sessionId: session.id,
            dueAt: session.joinDeadline,
            timeToStart: sessionTimeToStart,
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
    await Future.delayed(_delay);
  }

  @override
  Future<SessionFinancial> getSessionFinancial(String sessionId) async {
    await Future.delayed(_delay);
    final session = _mySessions.firstWhere(
      (s) => s.id == sessionId,
      orElse: () => _mySessions.first,
    );
    final gross = session.currentPlayers * session.pricePerPerson;
    final coachCost = session.coachCost ?? 0;
    final courtCost = session.courtCost ?? 0;
    final cost = coachCost + courtCost;
    final net = gross - cost;
    final margin = gross > 0 ? ((net / gross) * 100).round() : null;
    return SessionFinancial(
      revenue: FinancialSide(
        total: gross,
        systemTracked: SystemTrackedBlock(
          total: gross,
          streams: [
            FinancialStream(key: 'student_payments', amount: gross),
          ],
        ),
      ),
      cost: FinancialSide(
        total: cost,
        systemTracked: SystemTrackedBlock(
          total: coachCost,
          streams: [
            if (coachCost > 0)
              FinancialStream(key: 'coach_payouts', amount: coachCost),
          ],
        ),
      ),
      net: FinancialNet(amount: net, marginPercent: margin),
    );
  }

  @override
  Future<OrganizerEarningsSummary> getEarningsSummary() async {
    await Future.delayed(_delay);
    final settlements = _mySessions.map((session) {
      final gross = session.currentPlayers * session.pricePerPerson;
      final estimatedCost = (session.courtCost ?? 0) + (session.coachCost ?? 0);
      final organizerFee = session.organizerFeePerPerson != null
          ? session.organizerFeePerPerson! * session.currentPlayers
          : max(0, gross - estimatedCost);
      final net = max(0, gross - estimatedCost);
      return OrganizerSessionSettlement(
        sessionId: session.id,
        title: session.safeTitle,
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

    // Simulate breakdown: split pending into player vs venue portions
    final pendingPlayerBalance = (pending * 0.7).round();
    final pendingVenueBalance = pending - pendingPlayerBalance;
    // Simulate dispute hold from disputed participants
    final disputeHoldBalance = _mySessions.fold<int>(0, (sum, session) {
      final disputed = MockData.sessionParticipants
          .where(
            (p) =>
                p.sessionId == session.id &&
                p.status == SessionParticipantStatus.disputed,
          )
          .length;
      return sum + (disputed * session.pricePerPerson);
    });

    return OrganizerEarningsSummary(
      availableBalance: available,
      pendingBalance: pending,
      paidOutThisMonth: paidOut,
      settlements: settlements,
      pendingPlayerBalance: pendingPlayerBalance,
      pendingVenueBalance: pendingVenueBalance,
      disputeHoldBalance: disputeHoldBalance,
    );
  }

  @override
  Future<OrganizerSessionSettlement> getSessionSettlement(
    String sessionId,
  ) async {
    await Future.delayed(_delay);
    final earnings = await getEarningsSummary();
    return earnings.settlements.firstWhere((s) => s.sessionId == sessionId);
  }

  @override
  Future<ClubProfile> getClubProfile() async {
    await Future.delayed(_delay);
    return MockData.clubProfile;
  }

  @override
  Future<List<ClubMember>> getClubMembers() async {
    await Future.delayed(_delay);
    return MockData.clubMembers;
  }

  @override
  Future<Map<String, String>> getSessionTemplates() async {
    await Future.delayed(_delay);
    return MockData.organizerSessionTemplates;
  }
}
