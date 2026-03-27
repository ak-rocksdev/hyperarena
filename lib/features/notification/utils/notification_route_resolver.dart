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
      _ => null,
    };
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
}
