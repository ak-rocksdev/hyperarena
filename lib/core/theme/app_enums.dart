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

enum UserRole { player, coach, organizer, courtOwner }

enum PaymentMethodType { qris, bankTransfer }

enum ClubMemberRole { admin, captain, member }
