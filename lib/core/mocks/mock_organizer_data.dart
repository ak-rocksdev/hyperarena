import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';

abstract final class MockOrganizerData {
  static final clubProfile = ClubProfile(
    name: 'Andi Sport Club',
    tagline: 'Komunitas olahraga raket & bola Jakarta Selatan',
    city: 'Jakarta Selatan',
    coverPhotoUrl: 'https://picsum.photos/seed/clubcover/800/400',
    createdAt: DateTime(2025, 8, 15),
  );

  static final _now = DateTime.now();

  static final clubMembers = [
    ClubMember(
      id: 'member-001',
      name: 'Budi Santoso',
      joinedAt: DateTime(2025, 9, 3),
      sportPreferences: [Sport.tennis, Sport.padel],
      avatarUrl: 'https://picsum.photos/seed/budi/100/100',
      levelTier: LevelTier.advanced,
      lastActiveAt: _now,
      sessionsPlayed: 42,
      role: ClubMemberRole.admin,
      attendanceStreak: 8,
    ),
    ClubMember(
      id: 'member-002',
      name: 'Rina Wijaya',
      joinedAt: DateTime(2025, 9, 10),
      sportPreferences: [Sport.badminton, Sport.tennis],
      avatarUrl: 'https://picsum.photos/seed/rina/100/100',
      levelTier: LevelTier.intermediate,
      lastActiveAt: _now.subtract(const Duration(days: 1)),
      sessionsPlayed: 28,
      role: ClubMemberRole.captain,
      attendanceStreak: 5,
    ),
    ClubMember(
      id: 'member-003',
      name: 'Agus Pratama',
      joinedAt: DateTime(2025, 10, 1),
      sportPreferences: [Sport.futsal, Sport.badminton],
      avatarUrl: 'https://picsum.photos/seed/agus/100/100',
      levelTier: LevelTier.amateur,
      lastActiveAt: _now.subtract(const Duration(days: 3)),
      sessionsPlayed: 15,
      attendanceStreak: 3,
    ),
    ClubMember(
      id: 'member-004',
      name: 'Siti Nurhaliza',
      joinedAt: DateTime(2025, 10, 22),
      sportPreferences: [Sport.tennis],
      avatarUrl: 'https://picsum.photos/seed/siti/100/100',
      levelTier: LevelTier.rookie,
      lastActiveAt: _now.subtract(const Duration(days: 7)),
      sessionsPlayed: 6,
      attendanceStreak: 1,
    ),
    ClubMember(
      id: 'member-005',
      name: 'Kevin Wijaya',
      joinedAt: DateTime(2025, 11, 5),
      sportPreferences: [Sport.padel, Sport.futsal, Sport.tennis],
      avatarUrl: 'https://picsum.photos/seed/kevin/100/100',
      levelTier: LevelTier.pro,
      lastActiveAt: _now,
      sessionsPlayed: 55,
      attendanceStreak: 12,
    ),
    ClubMember(
      id: 'member-006',
      name: 'Dimas Pratama',
      joinedAt: _now.subtract(const Duration(days: 14)),
      sportPreferences: [Sport.badminton],
      avatarUrl: 'https://picsum.photos/seed/dimas/100/100',
      levelTier: LevelTier.rookie,
      lastActiveAt: _now.subtract(const Duration(days: 14)),
      sessionsPlayed: 2,
      attendanceStreak: 0,
    ),
    ClubMember(
      id: 'member-007',
      name: 'Fajar Nugroho',
      joinedAt: _now.subtract(const Duration(days: 7)),
      sportPreferences: [Sport.tennis, Sport.padel],
      avatarUrl: 'https://picsum.photos/seed/fajar/100/100',
      levelTier: LevelTier.rookie,
      lastActiveAt: _now.subtract(const Duration(days: 21)),
      sessionsPlayed: 1,
      attendanceStreak: 0,
    ),
  ];

  static const sessionTemplates = <String, String>{
    'tpl-padel-social': 'Padel Social Mix',
    'tpl-tennis-doubles': 'Tennis Doubles Sparring',
    'tpl-futsal-night': 'Futsal Night Match',
  };
}
