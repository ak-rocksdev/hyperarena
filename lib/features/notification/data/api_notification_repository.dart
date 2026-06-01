import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/notification/data/notification_repository.dart';

class ApiNotificationRepository implements NotificationRepository {
  ApiNotificationRepository(this._apiClient);
  final ApiClient _apiClient;

  @override
  Future<List<NotificationItem>> getNotifications({int limit = 50}) async {
    final response =
        await _apiClient.get('/v1/notifications/', queryParameters: {
      'per_page': limit,
    });
    final raw = response.data['data'] as List;
    return raw
        .map((json) => _parseNotification(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get('/v1/notifications/unread-count');
    return (response.data['count'] as num).toInt();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _apiClient.patch('/v1/notifications/$id/read', data: {});
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch('/v1/notifications/read-all', data: {});
  }

  NotificationItem _parseNotification(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? {};
    final dataType = data['type'] as String? ?? 'general';

    return NotificationItem(
      id: json['id'] as String,
      type: _mapType(dataType),
      title: _titleFor(dataType, data),
      body: _bodyFor(dataType, data),
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['read_at'] != null,
      actionRoute: _routeFor(dataType, data),
      relatedId: _relatedIdFor(dataType, data),
    );
  }

  NotificationType _mapType(String beDataType) {
    return switch (beDataType) {
      'purchase_confirmed' => NotificationType.paymentConfirmed,
      'organizer.new_purchase' => NotificationType.paymentConfirmed,
      'booking_confirmed' => NotificationType.bookingConfirmed,
      'session_reminder' => NotificationType.sessionReminder,
      'session_cancelled' => NotificationType.sessionCancelled,
      'session_full' => NotificationType.sessionFull,
      'payment_rejected' => NotificationType.paymentRejected,
      'payment_proof_uploaded' => NotificationType.paymentReminder,
      _ => NotificationType.general,
    };
  }

  String _titleFor(String dataType, Map<String, dynamic> data) {
    return switch (dataType) {
      'purchase_confirmed' => 'Pembayaran Berhasil',
      'organizer.new_purchase' => 'Pembelian Baru',
      'booking_confirmed' => 'Booking Dikonfirmasi',
      'session_reminder' => 'Pengingat Sesi',
      'session_cancelled' => 'Sesi Dibatalkan',
      'session_full' => 'Sesi Penuh',
      'payment_rejected' => 'Pembayaran Ditolak',
      'payment_proof_uploaded' => 'Bukti Pembayaran Diunggah',
      _ => 'Notifikasi',
    };
  }

  String _bodyFor(String dataType, Map<String, dynamic> data) {
    return switch (dataType) {
      'purchase_confirmed' => () {
          final student = data['student_name'] as String? ?? '';
          final credits = data['credits_added'] as num?;
          if (credits != null && credits > 0) {
            return '$credits kredit ditambahkan untuk $student. Sesi terkonfirmasi.';
          }
          return 'Pembayaran $student sudah terkonfirmasi.';
        }(),
      'organizer.new_purchase' => () {
          final student = data['student_name'] as String? ?? 'Member';
          final session = data['session_title'] as String? ?? 'sesi';
          final method = data['payment_method'] as String? ?? '';
          return '$student membayar untuk $session'
              '${method.isNotEmpty ? " ($method)" : ""}';
        }(),
      'session_reminder' => () {
          final title = data['session_title'] as String? ?? 'sesi';
          return 'Sesi $title akan segera dimulai';
        }(),
      _ => (data['message'] as String?) ?? '',
    };
  }

  String? _routeFor(String dataType, Map<String, dynamic> data) {
    return switch (dataType) {
      'purchase_confirmed' => () {
          final id = data['purchase_id'];
          return id != null ? '/purchases/$id' : null;
        }(),
      'organizer.new_purchase' => () {
          final sessionId = data['session_id'];
          return sessionId != null && '$sessionId'.isNotEmpty
              ? '/organizer/sessions/$sessionId/participants'
              : '/organizer/dashboard';
        }(),
      _ => null,
    };
  }

  String? _relatedIdFor(String dataType, Map<String, dynamic> data) {
    return switch (dataType) {
      'purchase_confirmed' => data['purchase_id']?.toString(),
      'organizer.new_purchase' => data['purchase_id']?.toString(),
      _ => null,
    };
  }
}
