import 'package:hyperarena/core/theme/app_enums.dart';

/// Shared gamification constants and helpers.
abstract final class GamificationHelpers {
  /// XP thresholds per tier (XP needed to complete this tier).
  static const tierThresholds = {
    LevelTier.rookie: 500,
    LevelTier.amateur: 1500,
    LevelTier.intermediate: 3500,
    LevelTier.advanced: 7000,
    LevelTier.pro: 15000,
  };

  /// Localized tier label.
  static String tierLabel(LevelTier tier) => switch (tier) {
        LevelTier.rookie => 'Rookie',
        LevelTier.amateur => 'Amateur',
        LevelTier.intermediate => 'Intermediate',
        LevelTier.advanced => 'Advanced',
        LevelTier.pro => 'Pro',
      };

  /// XP progress within current tier (0.0–1.0).
  static double xpProgress(int totalXp, LevelTier tier) {
    final threshold = tierThresholds[tier] ?? 500;
    return (totalXp / threshold).clamp(0.0, 1.0);
  }

  /// XP threshold for the given tier.
  static int threshold(LevelTier tier) => tierThresholds[tier] ?? 500;
}
