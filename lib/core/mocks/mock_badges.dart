import 'package:hyperarena/features/gamification/data/models/badge.dart';

abstract final class MockBadges {
  static List<Badge> get badges {
    final now = DateTime.now();
    return [
      Badge(
        id: 'badge-001',
        name: 'Pemula Sejati',
        description: 'Selesaikan booking pertamamu',
        iconName: 'emoji_events',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 30)),
        xpReward: 50,
      ),
      Badge(
        id: 'badge-002',
        name: 'Reguler',
        description: 'Selesaikan 5 booking',
        iconName: 'repeat',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 14)),
        xpReward: 100,
      ),
      Badge(
        id: 'badge-003',
        name: 'Atletis',
        description: 'Mainkan 3 jenis olahraga berbeda',
        iconName: 'fitness_center',
        isUnlocked: true,
        unlockedAt: now.subtract(const Duration(days: 7)),
        xpReward: 75,
      ),
      const Badge(
        id: 'badge-004',
        name: 'Early Bird',
        description: 'Booking slot pagi sebelum jam 8',
        iconName: 'wb_sunny',
        xpReward: 50,
      ),
      const Badge(
        id: 'badge-005',
        name: 'Night Owl',
        description: 'Booking slot malam setelah jam 20',
        iconName: 'nightlight',
        xpReward: 50,
      ),
      const Badge(
        id: 'badge-006',
        name: 'Social Player',
        description: 'Gabung 3 sesi terbuka',
        iconName: 'groups',
        xpReward: 100,
      ),
      const Badge(
        id: 'badge-007',
        name: 'Venue Explorer',
        description: 'Bermain di 5 venue berbeda',
        iconName: 'explore',
        xpReward: 150,
      ),
      const Badge(
        id: 'badge-008',
        name: 'Streak Master',
        description: 'Bermain 7 hari berturut-turut',
        iconName: 'local_fire_department',
        xpReward: 200,
      ),
    ];
  }
}
