import 'package:flutter/material.dart';

/// Surface, overlay, gradient, and dark mode tokens.
/// Reference: DESIGN_SYSTEM.md Sections 1.4, 1.11–1.13
abstract final class AppSurfaces {
  // ── Light Surfaces ──────────────────────────────────────────
  static const background = Color(0xFFF8FAFC);
  static const backgroundPure = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const surfaceHighlight = Color(0xFFE6F2F0);
  static const surfaceSecondary = Color(0xFFF0FDFA);
  static const surfaceAccent = Color(0xFFFFF7ED);

  // ── Dark Surfaces ──────────────────────────────────────────
  static const darkBackground = Color(0xFF0F172A);
  static const darkBackgroundPure = Color(0xFF020617);
  static const darkSurface = Color(0xFF1E293B);
  static const darkSurfaceVariant = Color(0xFF334155);
  static const darkSurfaceHighlight = Color(0xFF103F3D);
  static const darkSurfaceSecondary = Color(0xFF134E4A);
  static const darkSurfaceAccent = Color(0xFF431407);

  // ── Overlays ────────────────────────────────────────────────
  static final overlay = const Color(0xFF000000).withValues(alpha: 0.50);
  static final overlayLight = const Color(0xFF000000).withValues(alpha: 0.20);
  static final overlayDark = const Color(0xFF000000).withValues(alpha: 0.80);
  static final scrim = const Color(0xFF000000).withValues(alpha: 0.32);
  static final ripple = const Color(0xFF1F7A74).withValues(alpha: 0.10);

  // ── Shimmer ─────────────────────────────────────────────────
  static const shimmerBase = Color(0xFFE2E8F0);
  static const shimmerHighlight = Color(0xFFF8FAFC);
  static const darkShimmerBase = Color(0xFF334155);
  static const darkShimmerHighlight = Color(0xFF475569);

  // ── Gradients ───────────────────────────────────────────────
  // Brand hero gradient — used by organizer dashboard header band.
  // Three-stop teal: brand → brand dark → near-black teal.
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.7, 1.0],
    colors: [
      Color(0xFF1F7A74),
      Color(0xFF155956),
      Color(0xFF0F4442),
    ],
  );

  static const energyGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
  );

  static const darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  static const surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9)],
  );
}
