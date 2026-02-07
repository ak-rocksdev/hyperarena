import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

final participantManagementProvider = Provider<ParticipantManagementController>(
  (ref) {
    return ParticipantManagementController(ref);
  },
);

class ParticipantManagementController {
  ParticipantManagementController(this.ref);

  final Ref ref;

  Future<void> confirm({
    required String participantId,
    required String sessionId,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .confirmParticipant(participantId);
    _invalidate(sessionId);
  }

  Future<void> reject({
    required String participantId,
    required String sessionId,
    required String reason,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .rejectParticipant(participantId, reason: reason);
    _invalidate(sessionId);
  }

  Future<void> noShow({
    required String participantId,
    required String sessionId,
  }) async {
    await ref.read(organizerRepositoryProvider).markNoShow(participantId);
    _invalidate(sessionId);
  }

  Future<void> refund({
    required String participantId,
    required String sessionId,
    required String reason,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .requestRefund(participantId, reason: reason);
    _invalidate(sessionId);
  }

  Future<void> resolveDispute({
    required String participantId,
    required String sessionId,
    required String resolution,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .resolveDispute(participantId, resolution: resolution);
    _invalidate(sessionId);
  }

  Future<void> sendMessage({
    required String sessionId,
    required String templateCode,
    String? customMessage,
    bool pendingOnly = false,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .sendParticipantMessage(
          sessionId,
          templateCode: templateCode,
          customMessage: customMessage,
          pendingOnly: pendingOnly,
        );
    _invalidate(sessionId);
  }

  Future<void> cancelSession({
    required String sessionId,
    required String reason,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .cancelSession(sessionId, reason: reason);
    _invalidate(sessionId);
  }

  Future<void> completeSession({required String sessionId}) async {
    await ref.read(organizerRepositoryProvider).completeSession(sessionId);
    _invalidate(sessionId);
  }

  Future<void> rescheduleSession({
    required String sessionId,
    required DateTime newDate,
    required String newStartTime,
    required String newEndTime,
  }) async {
    await ref
        .read(organizerRepositoryProvider)
        .rescheduleSession(
          sessionId,
          newDate: newDate,
          newStartTime: newStartTime,
          newEndTime: newEndTime,
        );
    _invalidate(sessionId);
  }

  void _invalidate(String sessionId) {
    ref.invalidate(organizerDashboardProvider);
    ref.invalidate(organizerSessionsProvider);
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);
    ref.invalidate(organizerAgendaProvider);
    ref.invalidate(organizerActionInboxProvider);
    ref.invalidate(organizerParticipantsProvider(sessionId));
    ref.invalidate(organizerSessionDetailProvider(sessionId));
    ref.invalidate(organizerEarningsProvider);
  }
}
