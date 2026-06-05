import 'package:hyperarena/routing/app_routes.dart';

class NotificationRouteResolver {
  /// Resolves an FCM data.type + payload data to a GoRouter path.
  /// Returns null for unknown types or missing required data.
  String? resolve(String? type, Map<String, dynamic> data) {
    return switch (type) {
      'booking_confirmed' ||
      'session_reminder' ||
      'progress_updated' =>
        _sessionRoute(data),
      'session_cancelled' ||
      'payment_confirmed' ||
      'payment_rejected' =>
        _marketplaceSessionRoute(data),
      'purchase_confirmed' => AppRoutes.notifications,
      'payout_approved' => AppRoutes.organizerEarnings,
      'organizer.new_purchase' => _organizerPurchaseRoute(data),
      'coach_assigned_to_session' ||
      'session_schedule_change' ||
      'assessment_reminder' =>
        _coachSessionRoute(data),
      'payout_earned' || 'payout_disbursed' => AppRoutes.coachWallet,
      'payout_request_approved' => _walletRequestRoute(data),
      _ => null,
    };
  }

  String _walletRequestRoute(Map<String, dynamic> data) {
    final id = data['request_id'];
    if (id is num) return AppRoutes.coachWithdrawalDetail(id.toInt());
    final parsed = int.tryParse('${id ?? ''}');
    if (parsed != null) return AppRoutes.coachWithdrawalDetail(parsed);
    return AppRoutes.coachWallet;
  }

  String? _sessionRoute(Map<String, dynamic> data) {
    final sessionId = data['session_id']?.toString();
    if (sessionId == null) return null;
    return AppRoutes.session(sessionId);
  }

  String? _marketplaceSessionRoute(Map<String, dynamic> data) {
    final sessionId = data['session_id']?.toString();
    if (sessionId == null) return null;
    return AppRoutes.marketplaceSession(sessionId);
  }

  String _organizerPurchaseRoute(Map<String, dynamic> data) {
    final sessionId = data['session_id']?.toString();
    if (sessionId != null && sessionId.isNotEmpty) {
      return AppRoutes.organizerParticipants(sessionId);
    }
    return AppRoutes.organizerEarnings;
  }

  String? _coachSessionRoute(Map<String, dynamic> data) {
    final sessionId = data['session_id']?.toString();
    if (sessionId == null) return null;
    return AppRoutes.coachSessionDetail(sessionId);
  }
}
