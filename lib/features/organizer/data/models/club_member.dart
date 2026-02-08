import 'package:hyperarena/core/theme/app_enums.dart';

class ClubMember {
  const ClubMember({
    required this.id,
    required this.name,
    required this.joinedAt,
    this.sportPreferences = const [],
    this.avatarUrl,
    this.levelTier = LevelTier.rookie,
    this.lastActiveAt,
    this.sessionsPlayed = 0,
    this.role = ClubMemberRole.member,
    this.attendanceStreak = 0,
  });

  final String id;
  final String name;
  final DateTime joinedAt;
  final List<Sport> sportPreferences;
  final String? avatarUrl;
  final LevelTier levelTier;
  final DateTime? lastActiveAt;
  final int sessionsPlayed;
  final ClubMemberRole role;
  final int attendanceStreak;
}
