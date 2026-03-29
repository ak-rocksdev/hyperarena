import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/profile/data/models/player_profile.dart';

abstract final class MockUsers {
  static const currentUser = User(
    id: 'user-001',
    name: 'Budi Santoso',
    email: 'budi@email.com',
    phone: '+6281234567890',
    role: UserRole.player,
    isVerified: true,
    availableRoles: ['member'],
  );

  static const currentProfile = PlayerProfile(
    userId: 'user-001',
    bio: 'Pemain tenis dan badminton hobi di Jakarta',
    city: 'Jakarta',
    sports: [Sport.tennis, Sport.badminton],
    selfAssessedLevels: {
      'tennis': 'intermediate',
      'badminton': 'amateur',
    },
    totalXp: 350,
    levelTier: LevelTier.rookie,
    profileCompletionPct: 75,
    bookingStreak: 4,
    totalHoursPlayed: 12,
  );

  static const coachUser = User(
    id: 'coach-001',
    name: 'Andi Pratama',
    email: 'coach@email.com',
    phone: '+6281999888777',
    role: UserRole.coach,
    isVerified: true,
    availableRoles: ['coach', 'member'],
  );

  static const organizerUser = User(
    id: 'organizer-001',
    name: 'Sari Rahmawati',
    email: 'organizer@email.com',
    phone: '+6281555666777',
    role: UserRole.organizer,
    isVerified: true,
    availableRoles: ['admin', 'member'],
  );

  static const ownerUser = User(
    id: 'owner-001',
    name: 'Hendra Wijaya',
    email: 'owner@email.com',
    phone: '+6281333444555',
    role: UserRole.courtOwner,
    isVerified: true,
    availableRoles: ['court-owner', 'member'],
  );

  static const user2 = User(
    id: 'user-002',
    name: 'Rina Wijaya',
    email: 'rina@email.com',
    phone: '+6289876543210',
    role: UserRole.player,
    isVerified: true,
  );

  static const user3 = User(
    id: 'user-003',
    name: 'Agus Pratama',
    email: 'agus@email.com',
    phone: '+6281122334455',
    role: UserRole.player,
    isVerified: false,
  );

  static const mockPassword = 'password123';
}
