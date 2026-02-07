import 'package:flutter/material.dart';

/// Duration and curve tokens for animations.
/// Reference: DESIGN_SYSTEM.md Section 5
abstract final class AppAnimations {
  // ── Durations ───────────────────────────────────────────────
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 400);
  static const xSlow = Duration(milliseconds: 600);

  // ── Curves ──────────────────────────────────────────────────
  static const standard = Curves.easeInOut;
  static const decelerate = Curves.easeOut;
  static const accelerate = Curves.easeIn;
  static const sharp = Curves.easeInOutCubic;
  static const bounce = Curves.bounceOut;
  static const elastic = Curves.elasticOut;
}
