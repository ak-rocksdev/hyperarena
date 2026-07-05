/// Type-safe domain enums shared between theme and data layers.
/// Reference: DESIGN_SYSTEM.md Section 8, Architecture Section 5.2
enum Sport {
  tennis,
  padel,
  badminton,
  futsal,
  basketball,
  volleyball,
  tableTennis,
}

enum BookingStatus {
  pendingPayment,
  waitingConfirmation,
  confirmed,
  rejected,
  cancelled,
  completed,
  expired,
}

enum BookingType { court, coaching, openSession }

enum LevelTier { rookie, amateur, intermediate, advanced, pro }

/// Session kind. Wire values (`trial`/`group`/`private`) match the backend
/// `StoreSessionRequest` `type` rule. `private` sessions carry no capacity.
enum SessionType { trial, group, private }

enum UserRole { player, coach, organizer, courtOwner }

enum PaymentMethodType { qris, bankTransfer }

enum ClubMemberRole { admin, captain, member }

/// Attendance row status from `POST /v1/coach/sessions/{id}/attendance/bulk`.
/// Wire values match the backend strings — use [AttendanceStatusX.fromWire]
/// to parse a server response.
enum AttendanceStatus {
  present,
  late,
  absent;

  String get wire => name;
}

extension AttendanceStatusX on AttendanceStatus? {
  /// Maps a backend wire string to [AttendanceStatus]. Returns `null` for any
  /// unrecognised value (treat as "not yet recorded" for review-banner gating).
  static AttendanceStatus? fromWire(String? value) => switch (value) {
        'present' => AttendanceStatus.present,
        'late' => AttendanceStatus.late,
        'absent' => AttendanceStatus.absent,
        _ => null,
      };
}
