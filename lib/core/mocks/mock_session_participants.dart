import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

abstract final class MockSessionParticipants {
  static List<SessionParticipant> get participants {
    final now = DateTime.now();
    return [
      SessionParticipant(
        id: 'sp-001',
        sessionId: 'session-001',
        playerId: 'user-001',
        playerName: 'Budi Santoso',
        bookingId: 'booking-002',
        status: SessionParticipantStatus.pendingPayment,
        paymentMethod: PaymentMethodType.qris,
        paidAmount: 75000,
        joinedAt: now.subtract(const Duration(hours: 20)),
      ),
      SessionParticipant(
        id: 'sp-002',
        sessionId: 'session-001',
        playerId: 'user-002',
        playerName: 'Rina Wijaya',
        status: SessionParticipantStatus.confirmed,
        paymentMethod: PaymentMethodType.bankTransfer,
        paidAmount: 75000,
        paidAt: now.subtract(const Duration(hours: 22)),
        confirmedAt: now.subtract(const Duration(hours: 21)),
        joinedAt: now.subtract(const Duration(hours: 23)),
      ),
      SessionParticipant(
        id: 'sp-003',
        sessionId: 'session-002',
        playerId: 'user-003',
        playerName: 'Agus Pratama',
        status: SessionParticipantStatus.disputed,
        paymentMethod: PaymentMethodType.bankTransfer,
        paidAmount: 50000,
        disputeReason: 'Sudah transfer via BCA tapi status masih "belum bayar". '
            'Mohon dicek, bukti transfer sudah saya upload.',
        evidenceUrl: 'https://picsum.photos/seed/dispute1/600/1000',
        joinedAt: now.subtract(const Duration(hours: 10)),
      ),
      SessionParticipant(
        id: 'sp-007',
        sessionId: 'session-today-2',
        playerId: 'user-007',
        playerName: 'Rendi Saputra',
        status: SessionParticipantStatus.disputed,
        paymentMethod: PaymentMethodType.qris,
        paidAmount: 40000,
        paidAt: now.subtract(const Duration(hours: 4)),
        disputeReason: 'Sesi ditulis "Semua level" tapi waktu datang ternyata '
            'level advanced semua. Saya pemula jadi tidak bisa ikut main.',
        joinedAt: now.subtract(const Duration(hours: 8)),
      ),
      SessionParticipant(
        id: 'sp-008',
        sessionId: 'session-today-1',
        playerId: 'user-008',
        playerName: 'Lina Kartika',
        status: SessionParticipantStatus.disputed,
        paymentMethod: PaymentMethodType.bankTransfer,
        paidAmount: 60000,
        paidAt: now.subtract(const Duration(hours: 6)),
        disputeReason: 'Lapangan yang disediakan berbeda dari yang dijanjikan. '
            'Ditulis GOR Senayan tapi ternyata diarahkan ke lapangan outdoor.',
        evidenceUrl: 'https://picsum.photos/seed/dispute3/600/1000',
        joinedAt: now.subtract(const Duration(hours: 12)),
      ),
      SessionParticipant(
        id: 'sp-004',
        sessionId: 'session-003',
        playerId: 'user-004',
        playerName: 'Dimas Pratama',
        status: SessionParticipantStatus.refunded,
        paymentMethod: PaymentMethodType.qris,
        paidAmount: 35000,
        refundReason: 'Cedera mendadak',
        joinedAt: now.subtract(const Duration(days: 1)),
      ),
      SessionParticipant(
        id: 'sp-005',
        sessionId: 'session-004',
        playerId: 'user-005',
        playerName: 'Kevin Wijaya',
        status: SessionParticipantStatus.noShow,
        paymentMethod: PaymentMethodType.qris,
        paidAmount: 100000,
        joinedAt: now.subtract(const Duration(days: 2)),
      ),
      SessionParticipant(
        id: 'sp-006',
        sessionId: 'session-005',
        playerId: 'user-006',
        playerName: 'Rina Wulandari',
        status: SessionParticipantStatus.confirmed,
        paymentMethod: PaymentMethodType.bankTransfer,
        paidAmount: 100000,
        paidAt: now.subtract(const Duration(hours: 6)),
        confirmedAt: now.subtract(const Duration(hours: 5)),
        joinedAt: now.subtract(const Duration(hours: 7)),
      ),
    ];
  }
}
