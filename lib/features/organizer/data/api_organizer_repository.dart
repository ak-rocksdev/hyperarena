import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
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

class ApiOrganizerRepository implements OrganizerRepository {
  final ApiClient _apiClient;

  ApiOrganizerRepository(this._apiClient);

  // Short-lived caches to deduplicate concurrent requests from multiple
  // Riverpod providers that fire simultaneously on the dashboard screen.
  Map<String, dynamic>? _dashboardCache;
  DateTime? _dashboardCacheTime;

  List<OpenSession>? _sessionsCache;
  DateTime? _sessionsCacheTime;

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final now = DateTime.now();
    if (_dashboardCache != null &&
        _dashboardCacheTime != null &&
        now.difference(_dashboardCacheTime!).inSeconds < 5) {
      return _dashboardCache!;
    }
    final response =
        await _apiClient.get('/v1/marketplace/organizer/dashboard');
    _dashboardCache = response.data as Map<String, dynamic>;
    _dashboardCacheTime = now;
    return _dashboardCache!;
  }

  // ── Real API methods ─────────────────────────────────────────────────

  Future<List<OpenSession>> _fetchSessions() async {
    final now = DateTime.now();
    if (_sessionsCache != null &&
        _sessionsCacheTime != null &&
        now.difference(_sessionsCacheTime!).inSeconds < 5) {
      return _sessionsCache!;
    }
    final response =
        await _apiClient.get('/v1/marketplace/organizer/sessions');
    final data = response.data;
    final List<dynamic> jsonList;
    if (data is List) {
      jsonList = data;
    } else if (data is Map<String, dynamic>) {
      jsonList = (data['data'] ?? data['sessions'] ?? []) as List<dynamic>;
    } else {
      jsonList = [];
    }
    _sessionsCache = jsonList
        .map((e) => OpenSession.fromJson(e as Map<String, dynamic>))
        .toList();
    _sessionsCacheTime = now;
    return _sessionsCache!;
  }

  @override
  Future<List<OpenSession>> getMySessions({bool upcomingOnly = false}) async {
    try {
      final sessions = await _fetchSessions();
      if (!upcomingOnly) return sessions;
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      return sessions.where((s) => !s.date.isBefore(startOfDay)).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<OpenSession> getSessionDetail(String sessionId) async {
    // TODO: Replace with dedicated /organizer/sessions/{id} endpoint
    try {
      final sessions = await getMySessions();
      final match = sessions.where((s) => s.id == sessionId);
      if (match.isEmpty) {
        throw DioException(
          requestOptions: RequestOptions(path: '/organizer/sessions/$sessionId'),
          message: 'Session not found',
          type: DioExceptionType.badResponse,
        );
      }
      return match.first;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<SessionParticipant>> getParticipants(String sessionId) async {
    try {
      final response = await _apiClient
          .get('/v1/marketplace/organizer/sessions/$sessionId/participants');
      final data = response.data as Map<String, dynamic>;
      final jsonList = (data['participants'] ?? []) as List<dynamic>;
      return jsonList.map((e) {
        final json = e as Map<String, dynamic>;
        return SessionParticipant(
          id: (json['purchase_id'] ?? json['booking_id'] ?? 0).toString(),
          sessionId: sessionId,
          playerId: (json['booking_id'] ?? 0).toString(),
          playerName: json['student_name'] as String? ?? '',
          bookingId: (json['booking_id'] ?? 0).toString(),
          status: _mapPaymentStatus(json['payment_status'] as String?),
          paymentMethod:
              _mapPaymentMethod(json['payment_method'] as String?),
          paidAmount: (json['amount_paid'] as num?)?.toInt() ?? 0,
          paidAt: json['booked_at'] != null
              ? DateTime.tryParse(json['booked_at'] as String)
              : null,
          evidenceUrl: json['payment_proof_url'] as String?,
          joinedAt: json['booked_at'] != null
              ? DateTime.tryParse(json['booked_at'] as String) ??
                  DateTime.now()
              : DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<SessionParticipant> confirmParticipant(String participantId) async {
    try {
      await _apiClient
          .patch('/v1/marketplace/organizer/purchases/$participantId/confirm');
      return SessionParticipant(
        id: participantId,
        sessionId: '',
        playerId: '',
        playerName: '',
        status: SessionParticipantStatus.confirmed,
        confirmedAt: DateTime.now(),
        joinedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<SessionParticipant> rejectParticipant(
    String participantId, {
    required String reason,
  }) async {
    try {
      await _apiClient.patch(
        '/v1/marketplace/organizer/purchases/$participantId/reject',
        data: {'reason': reason},
      );
      return SessionParticipant(
        id: participantId,
        sessionId: '',
        playerId: '',
        playerName: '',
        status: SessionParticipantStatus.rejected,
        rejectionReason: reason,
        joinedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  // ── Status / method mapping helpers ──────────────────────────────────

  static SessionParticipantStatus _mapPaymentStatus(String? status) {
    return switch (status) {
      'pending_payment' || 'pending_confirmation' =>
        SessionParticipantStatus.pendingPayment,
      'confirmed_transfer' || 'confirmed_credit' =>
        SessionParticipantStatus.confirmed,
      'rejected' => SessionParticipantStatus.rejected,
      _ => SessionParticipantStatus.pendingPayment,
    };
  }

  static PaymentMethodType _mapPaymentMethod(String? method) {
    return switch (method) {
      'bank_transfer' => PaymentMethodType.bankTransfer,
      'credit' => PaymentMethodType.qris,
      _ => PaymentMethodType.qris,
    };
  }

  // ── Dashboard & Earnings (real API) ─────────────────────────────────

  @override
  Future<OrganizerDashboardStats> getDashboard() async {
    try {
      final data = await _fetchDashboardData();
      return OrganizerDashboardStats.fromJson(data);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<OpenSession>> getAgenda({
    required DateTime from,
    required DateTime to,
  }) async {
    final sessions = await getMySessions();
    return sessions.where((s) {
      final day = DateTime(s.date.year, s.date.month, s.date.day);
      final fromDay = DateTime(from.year, from.month, from.day);
      final toDay = DateTime(to.year, to.month, to.day);
      return !day.isBefore(fromDay) && day.isBefore(toDay);
    }).toList();
  }

  // ── Create-session flow (organizer-scoped endpoints) ────────────────

  List<dynamic> _unwrapList(dynamic data, String key) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      return (data['data'] ?? data[key] ?? []) as List<dynamic>;
    }
    return [];
  }

  @override
  Future<OpenSession> createSession(CreateSessionDraft draft) async {
    try {
      final response = await _apiClient.post(
        '/v1/marketplace/organizer/sessions',
        data: draft.toCreatePayload(),
      );
      final data = response.data;
      final sessionJson = data is Map<String, dynamic>
          ? (data['session'] ?? data['data'] ?? data)
          : null;
      final id = sessionJson is Map<String, dynamic>
          ? sessionJson['id']?.toString()
          : null;
      // The store response is the admin serialization, not the marketplace
      // OpenSession shape — re-fetch the organizer sessions (same serializer
      // as getMySessions) and return the created row.
      if (id != null) {
        _sessionsCache = null;
        _sessionsCacheTime = null;
        final sessions = await _fetchSessions();
        for (final session in sessions) {
          if (session.id == id) return session;
        }
      }
      return OpenSession.fromJson(sessionJson as Map<String, dynamic>);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<CoachOption>> getCoaches() async {
    try {
      final response =
          await _apiClient.get('/v1/marketplace/organizer/coaches');
      return _unwrapList(response.data, 'coaches')
          .whereType<Map<String, dynamic>>()
          .map((json) {
        final user = json['user'];
        return CoachOption(
          id: (json['id'] as num).toInt(),
          name: (user is Map<String, dynamic>
                  ? user['name'] as String?
                  : null) ??
              json['name'] as String? ??
              'Coach',
          ratePerSession: (json['current_rate'] as num?)?.toInt(),
        );
      }).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<VenueOption>> getVenues() async {
    try {
      final response =
          await _apiClient.get('/v1/marketplace/organizer/venues');
      return _unwrapList(response.data, 'venues')
          .whereType<Map<String, dynamic>>()
          .map((json) => VenueOption(
                id: json['id'].toString(),
                name: json['name'] as String? ?? '',
                city: json['city'] as String?,
              ))
          .toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<VenueOption> createVenue(String name) async {
    try {
      final response = await _apiClient.post(
        '/v1/marketplace/organizer/venues',
        data: {'name': name},
      );
      final data = response.data;
      final json = data is Map<String, dynamic>
          ? (data['venue'] ?? data['data'] ?? data) as Map<String, dynamic>
          : const <String, dynamic>{};
      return VenueOption(
        id: json['id'].toString(),
        name: json['name'] as String? ?? name,
        city: json['city'] as String?,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<RecentSessionOption>> getRecentSessions() async {
    try {
      final response =
          await _apiClient.get('/v1/marketplace/organizer/sessions/recent');
      return _unwrapList(response.data, 'sessions')
          .whereType<Map<String, dynamic>>()
          .map((json) {
        final startAt = DateTime.parse(json['start_at'] as String);
        return RecentSessionOption(
          id: json['id'].toString(),
          startAt: startAt,
          type: SessionType.values.asNameMap()[json['type'] as String?] ??
              SessionType.group,
          coachName: json['primary_coach_name'] as String?,
          venueName: json['venue_name'] as String?,
          createdAt:
              DateTime.tryParse(json['created_at'] as String? ?? '') ?? startAt,
        );
      }).toList();
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<CreateSessionDraft> getDuplicatePayload(String sessionId) async {
    try {
      final response = await _apiClient.get(
        '/v1/marketplace/organizer/sessions/$sessionId/duplicate-payload',
      );
      final data = response.data;
      final json = data is Map<String, dynamic>
          ? (data['data'] ?? data) as Map<String, dynamic>
          : const <String, dynamic>{};
      // Title & date stay blank (admin duplicate behaviour). `venue_id`
      // arrives as an int — CreateSessionDraft holds it as a String.
      return CreateSessionDraft(
        coachIds: ((json['coach_ids'] as List?) ?? const [])
            .map((e) => (e as num).toInt())
            .toList(),
        type: SessionType.values.asNameMap()[json['type'] as String?] ??
            SessionType.group,
        startTime: json['start_time'] as String?,
        durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 60,
        capacity: (json['capacity'] as num?)?.toInt(),
        venueId: json['venue_id']?.toString(),
        venueName: json['venue_name'] as String?,
        price: (json['price'] as num?)?.toInt(),
        notes: json['notes'] as String?,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<bool> isPayoutConfigured() async {
    try {
      final data = await _fetchDashboardData();
      // Absent on older BE deploys — never false-block the flow; the server
      // still rejects create (422 errors.tenant) when bank details are unset.
      return data['payout_configured'] as bool? ?? true;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<void> uploadSessionCoverPhoto(String sessionId, File photo) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });
      await _apiClient.post(
        '/v1/marketplace/organizer/sessions/$sessionId/photo',
        data: formData,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<OpenSession> updateSession(
    String sessionId,
    CreateSessionDraft draft,
  ) =>
      throw UnimplementedError('updateSession: backend endpoint not yet available');

  @override
  Future<OpenSession> duplicateSession(
    String sessionId, {
    required DateTime newDate,
  }) =>
      throw UnimplementedError('duplicateSession: backend endpoint not yet available');

  @override
  Future<OpenSession> createFromTemplate(String templateId, DateTime date) =>
      throw UnimplementedError('createFromTemplate: backend endpoint not yet available');

  @override
  Future<OpenSession> rescheduleSession(
    String sessionId, {
    required DateTime newDate,
    required String newStartTime,
    required String newEndTime,
  }) =>
      throw UnimplementedError('rescheduleSession: backend endpoint not yet available');

  @override
  Future<OpenSession> cancelSession(
    String sessionId, {
    required String reason,
  }) =>
      throw UnimplementedError('cancelSession: backend endpoint not yet available');

  @override
  Future<OpenSession> completeSession(String sessionId) =>
      throw UnimplementedError('completeSession: backend endpoint not yet available');

  @override
  Future<SessionParticipant> markNoShow(String participantId) =>
      throw UnimplementedError('markNoShow: backend endpoint not yet available');

  @override
  Future<SessionParticipant> requestRefund(
    String participantId, {
    required String reason,
  }) =>
      throw UnimplementedError('requestRefund: backend endpoint not yet available');

  @override
  Future<SessionParticipant> resolveDispute(
    String participantId, {
    required String resolution,
  }) =>
      throw UnimplementedError('resolveDispute: backend endpoint not yet available');

  @override
  Future<void> setAttendance(String bookingId, String status) async {
    try {
      await _apiClient.patch(
        '/v1/admin/session-students/$bookingId/attendance',
        data: {'status': status},
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<List<OrganizerActionItem>> getActionInbox({
    OrganizerActionType? type,
    OrganizerActionSeverity? severity,
  }) async {
    try {
      final data = await _fetchDashboardData();
      final jsonList = (data['action_items'] ?? []) as List<dynamic>;
      var items = jsonList
          .map((e) =>
              OrganizerActionItem.fromJson(e as Map<String, dynamic>))
          .toList();
      if (type != null) {
        items = items.where((i) => i.type == type).toList();
      }
      if (severity != null) {
        items = items.where((i) => i.severity == severity).toList();
      }
      return items;
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  @override
  Future<void> sendParticipantMessage(
    String sessionId, {
    required String templateCode,
    String? customMessage,
    bool pendingOnly = false,
  }) =>
      throw UnimplementedError('sendParticipantMessage: backend endpoint not yet available');

  @override
  Future<OrganizerEarningsSummary> getEarningsSummary() async {
    try {
      final response =
          await _apiClient.get('/v1/marketplace/organizer/earnings');
      final data = response.data as Map<String, dynamic>;
      // Parse settlements manually since backend uses string dates
      final settlementsJson =
          (data['settlements'] ?? []) as List<dynamic>;
      final settlements = settlementsJson.map((e) {
        final s = e as Map<String, dynamic>;
        return OrganizerSessionSettlement(
          sessionId: s['session_id'] as String? ?? '',
          title: s['title'] as String? ?? '',
          date: DateTime.tryParse(s['date'] as String? ?? '') ??
              DateTime.now(),
          grossRevenue: (s['gross_revenue'] as num?)?.toInt() ?? 0,
          organizerFee: (s['organizer_fee'] as num?)?.toInt() ?? 0,
          estimatedCost: (s['estimated_cost'] as num?)?.toInt() ?? 0,
          netRevenue: (s['net_revenue'] as num?)?.toInt() ?? 0,
          settlementStatus: _mapSettlementStatus(
            s['settlement_status'] as String?,
          ),
        );
      }).toList();

      return OrganizerEarningsSummary(
        availableBalance: (data['available_balance'] as num?)?.toInt() ?? 0,
        pendingBalance: (data['pending_balance'] as num?)?.toInt() ?? 0,
        paidOutThisMonth:
            (data['paid_out_this_month'] as num?)?.toInt() ?? 0,
        settlements: settlements,
        pendingPlayerBalance:
            (data['pending_player_balance'] as num?)?.toInt() ?? 0,
        pendingVenueBalance:
            (data['pending_venue_balance'] as num?)?.toInt() ?? 0,
        disputeHoldBalance:
            (data['dispute_hold_balance'] as num?)?.toInt() ?? 0,
      );
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  /// Per-session financial snapshot (revenue / cost / net + custom entries).
  /// Endpoint requires `view-finances` permission server-side.
  @override
  Future<SessionFinancial> getSessionFinancial(String sessionId) async {
    try {
      final response = await _apiClient
          .get('/v1/marketplace/organizer/sessions/$sessionId/financial');
      final data = (response.data as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      return SessionFinancial.fromJson(data);
    } on DioException catch (e) {
      rethrowDio(e);
    }
  }

  static SessionSettlementStatus _mapSettlementStatus(String? status) {
    return switch (status) {
      'cleared' => SessionSettlementStatus.cleared,
      'paid_out' => SessionSettlementStatus.paidOut,
      _ => SessionSettlementStatus.pending,
    };
  }

  @override
  Future<OrganizerSessionSettlement> getSessionSettlement(String sessionId) =>
      throw UnimplementedError('getSessionSettlement: backend endpoint not yet available');

  @override
  Future<ClubProfile> getClubProfile() =>
      throw UnimplementedError('getClubProfile: backend endpoint not yet available');

  @override
  Future<List<ClubMember>> getClubMembers() =>
      throw UnimplementedError('getClubMembers: backend endpoint not yet available');

  @override
  Future<Map<String, String>> getSessionTemplates() =>
      throw UnimplementedError('getSessionTemplates: backend endpoint not yet available');
}
