import 'package:dio/dio.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/core/network/dio_error_handler.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/mock_organizer_repository.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/create_session_draft.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/features/organizer/data/organizer_repository.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

class ApiOrganizerRepository implements OrganizerRepository {
  final ApiClient _apiClient;
  final MockOrganizerRepository _fallback;

  ApiOrganizerRepository(this._apiClient, AppConfig config)
      : _fallback = MockOrganizerRepository(config);

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

  @override
  Future<OpenSession> createSession(CreateSessionDraft draft) =>
      _fallback.createSession(draft);

  @override
  Future<OpenSession> updateSession(
    String sessionId,
    CreateSessionDraft draft,
  ) =>
      _fallback.updateSession(sessionId, draft);

  @override
  Future<OpenSession> duplicateSession(
    String sessionId, {
    required DateTime newDate,
  }) =>
      _fallback.duplicateSession(sessionId, newDate: newDate);

  @override
  Future<OpenSession> createFromTemplate(String templateId, DateTime date) =>
      _fallback.createFromTemplate(templateId, date);

  @override
  Future<OpenSession> rescheduleSession(
    String sessionId, {
    required DateTime newDate,
    required String newStartTime,
    required String newEndTime,
  }) =>
      _fallback.rescheduleSession(
        sessionId,
        newDate: newDate,
        newStartTime: newStartTime,
        newEndTime: newEndTime,
      );

  @override
  Future<OpenSession> cancelSession(
    String sessionId, {
    required String reason,
  }) =>
      _fallback.cancelSession(sessionId, reason: reason);

  @override
  Future<OpenSession> completeSession(String sessionId) =>
      _fallback.completeSession(sessionId);

  @override
  Future<SessionParticipant> markNoShow(String participantId) =>
      _fallback.markNoShow(participantId);

  @override
  Future<SessionParticipant> requestRefund(
    String participantId, {
    required String reason,
  }) =>
      _fallback.requestRefund(participantId, reason: reason);

  @override
  Future<SessionParticipant> resolveDispute(
    String participantId, {
    required String resolution,
  }) =>
      _fallback.resolveDispute(participantId, resolution: resolution);

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
      _fallback.sendParticipantMessage(
        sessionId,
        templateCode: templateCode,
        customMessage: customMessage,
        pendingOnly: pendingOnly,
      );

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

  static SessionSettlementStatus _mapSettlementStatus(String? status) {
    return switch (status) {
      'cleared' => SessionSettlementStatus.cleared,
      'paid_out' => SessionSettlementStatus.paidOut,
      _ => SessionSettlementStatus.pending,
    };
  }

  @override
  Future<OrganizerSessionSettlement> getSessionSettlement(String sessionId) =>
      _fallback.getSessionSettlement(sessionId);

  @override
  Future<ClubProfile> getClubProfile() => _fallback.getClubProfile();

  @override
  Future<List<ClubMember>> getClubMembers() => _fallback.getClubMembers();

  @override
  Future<Map<String, String>> getSessionTemplates() =>
      _fallback.getSessionTemplates();
}
