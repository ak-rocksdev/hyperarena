import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/features/gamification/data/models/badge.dart';

// ── Badge list ──────────────────────────────────────────────────

// TODO(gamification-api): replace MockData.badges with real
// /v1/player/badges (or equivalent gamification) endpoint when BE lands.
final badgeListProvider = FutureProvider<List<Badge>>((ref) async {
  return MockData.badges;
});

// ── Player stats (computed from mock bookings) ──────────────────

class PlayerStats {
  final int totalBookings;
  final int sportsCount;
  final int hoursPlayed;

  const PlayerStats({
    required this.totalBookings,
    required this.sportsCount,
    required this.hoursPlayed,
  });
}

// TODO(gamification-api): replace MockData.bookings / MockData.currentProfile
// with real /v1/player/stats endpoint when BE lands.
final playerStatsProvider = Provider<PlayerStats>((ref) {
  final bookings = MockData.bookings;
  final profile = MockData.currentProfile;

  return PlayerStats(
    totalBookings: bookings.length,
    sportsCount: profile.sports.length,
    hoursPlayed: bookings.length * 2, // each booking ~2hrs
  );
});
