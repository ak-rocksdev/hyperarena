/// Spacing, border radius, and component size tokens.
/// Reference: DESIGN_SYSTEM.md Section 3
abstract final class AppDimensions {
  // ── Spacing Scale (base: 4px) ───────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
  static const double massive = 64;

  // ── Screen Padding ──────────────────────────────────────────
  static const double screenHorizontal = 20;
  static const double screenTop = 16;
  static const double screenBottom = 24;

  // ── Border Radius ───────────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 999;

  // ── Component Sizes ─────────────────────────────────────────
  static const double buttonHeightLg = 56;
  static const double buttonHeightMd = 48;
  static const double buttonHeightSm = 36;
  static const double buttonHeightXs = 28;
  static const double inputHeight = 52;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 72;
  static const double chipHeight = 32;
  static const double chipHeightSm = 24;

  // ── Avatar Sizes ────────────────────────────────────────────
  static const double avatarXs = 24;
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 96;

  // ── Icon Sizes ──────────────────────────────────────────────
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // ── Misc ────────────────────────────────────────────────────
  static const double badgeSize = 20;
  static const double badgeDot = 8;
  static const double dividerThickness = 1;
  static const double strokeWidth = 1.5;
  static const double strokeWidthThick = 2;
  static const double cardMinHeight = 80;
  static const double maxContentWidth = 600;

  // ── Aspect Ratios ───────────────────────────────────────────
  static const double imageAspectVenue = 16 / 9;
  static const double imageAspectAvatar = 1;
}
