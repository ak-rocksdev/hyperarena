import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';

abstract final class MockOrganizerData {
  static final clubProfile = ClubProfile(
    name: 'Andi Sport Club',
    tagline: 'Komunitas olahraga raket & bola Jakarta Selatan',
    city: 'Jakarta Selatan',
    createdAt: DateTime(2025, 8, 15),
  );

  static final clubMembers = [
    ClubMember(
      id: 'member-001',
      name: 'Budi Santoso',
      joinedAt: DateTime(2025, 9, 3),
      sportPreferences: [Sport.tennis, Sport.padel],
    ),
    ClubMember(
      id: 'member-002',
      name: 'Rina Wijaya',
      joinedAt: DateTime(2025, 9, 10),
      sportPreferences: [Sport.badminton, Sport.tennis],
    ),
    ClubMember(
      id: 'member-003',
      name: 'Agus Pratama',
      joinedAt: DateTime(2025, 10, 1),
      sportPreferences: [Sport.futsal, Sport.badminton],
    ),
    ClubMember(
      id: 'member-004',
      name: 'Siti Nurhaliza',
      joinedAt: DateTime(2025, 10, 22),
      sportPreferences: [Sport.tennis],
    ),
    ClubMember(
      id: 'member-005',
      name: 'Kevin Wijaya',
      joinedAt: DateTime(2025, 11, 5),
      sportPreferences: [Sport.padel, Sport.futsal, Sport.tennis],
    ),
    ClubMember(
      id: 'member-006',
      name: 'Dimas Pratama',
      joinedAt: DateTime(2026, 1, 8),
      sportPreferences: [Sport.badminton],
    ),
    ClubMember(
      id: 'member-007',
      name: 'Fajar Nugroho',
      joinedAt: DateTime(2026, 1, 20),
      sportPreferences: [Sport.tennis, Sport.padel],
    ),
  ];

  static const sessionTemplates = <String, String>{
    'tpl-padel-social': 'Padel Social Mix',
    'tpl-tennis-doubles': 'Tennis Doubles Sparring',
    'tpl-futsal-night': 'Futsal Night Match',
  };
}
