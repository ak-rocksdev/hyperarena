import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_domain_colors.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

/// Custom ThemeExtension for sport-specific colors.
/// Reference: DESIGN_SYSTEM.md Section 8.1
class SportThemeExtension extends ThemeExtension<SportThemeExtension> {
  const SportThemeExtension();

  Color color(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennis,
    Sport.padel => AppDomainColors.padel,
    Sport.badminton => AppDomainColors.badminton,
    Sport.futsal => AppDomainColors.futsal,
    Sport.basketball => AppDomainColors.basketball,
    Sport.volleyball => AppDomainColors.volleyball,
    Sport.tableTennis => AppDomainColors.tableTennis,
  };

  Color backgroundColor(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennisBg,
    Sport.padel => AppDomainColors.padelBg,
    Sport.badminton => AppDomainColors.badmintonBg,
    Sport.futsal => AppDomainColors.futsalBg,
    Sport.basketball => AppDomainColors.basketballBg,
    Sport.volleyball => AppDomainColors.volleyballBg,
    Sport.tableTennis => AppDomainColors.tableTennisBg,
  };

  Color textColor(Sport sport) => switch (sport) {
    Sport.tennis => AppDomainColors.tennisText,
    Sport.padel => AppDomainColors.padelText,
    Sport.badminton => AppDomainColors.badmintonText,
    Sport.futsal => AppDomainColors.futsalText,
    Sport.basketball => AppDomainColors.basketballText,
    Sport.volleyball => AppDomainColors.volleyballText,
    Sport.tableTennis => AppDomainColors.tableTennisText,
  };

  @override
  SportThemeExtension copyWith() => const SportThemeExtension();

  @override
  SportThemeExtension lerp(covariant SportThemeExtension? other, double t) =>
      const SportThemeExtension();
}

/// Custom ThemeExtension for booking status colors.
/// Reference: DESIGN_SYSTEM.md Section 8.2
class BookingStatusThemeExtension
    extends ThemeExtension<BookingStatusThemeExtension> {
  const BookingStatusThemeExtension();

  Color color(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPayment,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmation,
    BookingStatus.confirmed => AppDomainColors.statusConfirmed,
    BookingStatus.rejected => AppDomainColors.statusRejected,
    BookingStatus.cancelled => AppDomainColors.statusCancelled,
    BookingStatus.completed => AppDomainColors.statusCompleted,
    BookingStatus.expired => AppDomainColors.statusExpired,
  };

  Color backgroundColor(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPaymentBg,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmationBg,
    BookingStatus.confirmed => AppDomainColors.statusConfirmedBg,
    BookingStatus.rejected => AppDomainColors.statusRejectedBg,
    BookingStatus.cancelled => AppDomainColors.statusCancelledBg,
    BookingStatus.completed => AppDomainColors.statusCompletedBg,
    BookingStatus.expired => AppDomainColors.statusExpiredBg,
  };

  Color textColor(BookingStatus status) => switch (status) {
    BookingStatus.pendingPayment => AppDomainColors.statusPendingPaymentText,
    BookingStatus.waitingConfirmation =>
      AppDomainColors.statusWaitingConfirmationText,
    BookingStatus.confirmed => AppDomainColors.statusConfirmedText,
    BookingStatus.rejected => AppDomainColors.statusRejectedText,
    BookingStatus.cancelled => AppDomainColors.statusCancelledText,
    BookingStatus.completed => AppDomainColors.statusCompletedText,
    BookingStatus.expired => AppDomainColors.statusExpiredText,
  };

  @override
  BookingStatusThemeExtension copyWith() =>
      const BookingStatusThemeExtension();

  @override
  BookingStatusThemeExtension lerp(
    covariant BookingStatusThemeExtension? other,
    double t,
  ) => const BookingStatusThemeExtension();
}

/// Custom ThemeExtension for gamification/level tier colors.
/// Reference: DESIGN_SYSTEM.md Section 8.3
class GamificationThemeExtension
    extends ThemeExtension<GamificationThemeExtension> {
  const GamificationThemeExtension();

  Color levelColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookie,
    LevelTier.amateur => AppDomainColors.tierAmateur,
    LevelTier.intermediate => AppDomainColors.tierIntermediate,
    LevelTier.advanced => AppDomainColors.tierAdvanced,
    LevelTier.pro => AppDomainColors.tierPro,
  };

  Color levelBackgroundColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookieBg,
    LevelTier.amateur => AppDomainColors.tierAmateurBg,
    LevelTier.intermediate => AppDomainColors.tierIntermediateBg,
    LevelTier.advanced => AppDomainColors.tierAdvancedBg,
    LevelTier.pro => AppDomainColors.tierProBg,
  };

  Color levelTextColor(LevelTier tier) => switch (tier) {
    LevelTier.rookie => AppDomainColors.tierRookieText,
    LevelTier.amateur => AppDomainColors.tierAmateurText,
    LevelTier.intermediate => AppDomainColors.tierIntermediateText,
    LevelTier.advanced => AppDomainColors.tierAdvancedText,
    LevelTier.pro => AppDomainColors.tierProText,
  };

  @override
  GamificationThemeExtension copyWith() =>
      const GamificationThemeExtension();

  @override
  GamificationThemeExtension lerp(
    covariant GamificationThemeExtension? other,
    double t,
  ) => const GamificationThemeExtension();
}

/// Custom ThemeExtension for star rating colors.
/// Reference: DESIGN_SYSTEM.md Section 8.4
class RatingThemeExtension extends ThemeExtension<RatingThemeExtension> {
  final Color starColor;
  final Color halfStarColor;
  final Color emptyStarColor;

  const RatingThemeExtension({
    this.starColor = const Color(0xFFFFC107),
    this.halfStarColor = const Color(0xFFFFD54F),
    this.emptyStarColor = const Color(0xFFE2E8F0),
  });

  @override
  RatingThemeExtension copyWith({
    Color? starColor,
    Color? halfStarColor,
    Color? emptyStarColor,
  }) {
    return RatingThemeExtension(
      starColor: starColor ?? this.starColor,
      halfStarColor: halfStarColor ?? this.halfStarColor,
      emptyStarColor: emptyStarColor ?? this.emptyStarColor,
    );
  }

  @override
  RatingThemeExtension lerp(
    covariant RatingThemeExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return RatingThemeExtension(
      starColor: Color.lerp(starColor, other.starColor, t)!,
      halfStarColor: Color.lerp(halfStarColor, other.halfStarColor, t)!,
      emptyStarColor: Color.lerp(emptyStarColor, other.emptyStarColor, t)!,
    );
  }
}
