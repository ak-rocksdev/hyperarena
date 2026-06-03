import 'package:flutter/material.dart';

/// Brand, neutral, semantic, text, and border color tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.1–1.6
abstract final class AppColors {
  // ── Primary: HyperArena Brand Teal ──────────────────────────
  // Anchored on brand teal (#1F7A74) sampled from HyperArena logo.
  // Smooth derived ramp; primary600 + primary700 are exact brand values
  // used in the dashboard gradient hero (`#1F7A74` → `#155956`).
  static const primary50 = Color(0xFFE6F2F0); // brand tint (logo halo)
  static const primary100 = Color(0xFFCCE5E2);
  static const primary200 = Color(0xFF99CCC5);
  static const primary300 = Color(0xFF66B2A8);
  static const primary400 = Color(0xFF4D9F94);
  static const primary500 = Color(0xFF338C81);
  static const primary = Color(0xFF1F7A74); // primary600 — BRAND MAIN
  static const primary700 = Color(0xFF155956); // BRAND DARK
  static const primary800 = Color(0xFF103F3D);
  static const primary900 = Color(0xFF0B2A28);

  // ── Secondary: Teal ─────────────────────────────────────────
  static const secondary50 = Color(0xFFF0FDFA);
  static const secondary100 = Color(0xFFCCFBF1);
  static const secondary200 = Color(0xFF99F6E4);
  static const secondary300 = Color(0xFF5EEAD4);
  static const secondary400 = Color(0xFF2DD4BF);
  static const secondary500 = Color(0xFF14B8A6);
  static const secondary = Color(0xFF0D9488); // secondary600 — main
  static const secondary700 = Color(0xFF0F766E);
  static const secondary800 = Color(0xFF115E59);
  static const secondary900 = Color(0xFF134E4A);

  // ── Accent: Vivid Orange ────────────────────────────────────
  static const accent50 = Color(0xFFFFF7ED);
  static const accent100 = Color(0xFFFFEDD5);
  static const accent200 = Color(0xFFFED7AA);
  static const accent300 = Color(0xFFFDBA74);
  static const accent400 = Color(0xFFFB923C);
  static const accent = Color(0xFFF97316); // accent500 — main
  static const accent600 = Color(0xFFEA580C);
  static const accent700 = Color(0xFFC2410C);
  static const accent800 = Color(0xFF9A3412);
  static const accent900 = Color(0xFF7C2D12);

  // ── Role accents ────────────────────────────────────────────
  /// Background tint for the coach role pill. Distinct enough from the
  /// `primary` brand accent to read as "role indicator" rather than CTA.
  static const coachAccent = Color(0xFF14B8A6); // teal-500

  // ── Neutral: Slate ──────────────────────────────────────────
  static const neutral50 = Color(0xFFF8FAFC);
  static const neutral100 = Color(0xFFF1F5F9);
  static const neutral200 = Color(0xFFE2E8F0);
  static const neutral300 = Color(0xFFCBD5E1);
  static const neutral400 = Color(0xFF94A3B8);
  static const neutral500 = Color(0xFF64748B);
  static const neutral600 = Color(0xFF475569);
  static const neutral700 = Color(0xFF334155);
  static const neutral800 = Color(0xFF1E293B);
  static const neutral900 = Color(0xFF0F172A);

  // ── Semantic ────────────────────────────────────────────────
  static const success = Color(0xFF22C55E);
  static const successLight = Color(0xFFDCFCE7);
  static const successDark = Color(0xFF16A34A);

  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const warningDark = Color(0xFFD97706);

  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const errorDark = Color(0xFFDC2626);

  static const info = Color(0xFF6366F1);
  static const infoLight = Color(0xFFE0E7FF);
  static const infoDark = Color(0xFF4F46E5);

  // ── Semantic: specific-use colors ──────────────────────────
  static const starRating = Color(0xFFFFC107);
  static const whatsappGreen = Color(0xFF25D366);

  // ── Text ────────────────────────────────────────────────────
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textTertiary = Color(0xFF94A3B8);
  static const textDisabled = Color(0xFFCBD5E1);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnSecondary = Color(0xFF042F2E);
  static const textOnAccent = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFFFFFFF);
  static const textLink = Color(0xFF1F7A74);

  // ── Border & Divider ────────────────────────────────────────
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);
  static const borderMedium = Color(0xFFCBD5E1);
  static const borderStrong = Color(0xFF94A3B8);
  static const borderFocused = Color(0xFF1F7A74);
  static const borderError = Color(0xFFEF4444);
  static const divider = Color(0xFFE2E8F0);
}
