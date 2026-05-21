import 'package:flutter/material.dart';

/// Shadow/elevation tokens.
/// Reference: DESIGN_SYSTEM.md Section 4
abstract final class AppShadows {
  static const _base = Color(0xFF0F172A);

  static final none = <BoxShadow>[];

  static final xs = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 2,
      color: _base.withValues(alpha: 0.05),
    ),
  ];

  static final sm = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 3,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final md = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final lg = [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final xl = [
    BoxShadow(
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
      color: _base.withValues(alpha: 0.10),
    ),
  ];

  static final bottomNav = [
    BoxShadow(
      offset: const Offset(0, -4),
      blurRadius: 12,
      color: _base.withValues(alpha: 0.08),
    ),
  ];

  static final button = [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 4,
      color: const Color(0xFF1F7A74).withValues(alpha: 0.25),
    ),
  ];

  static final colored = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 12,
      color: const Color(0xFF1F7A74).withValues(alpha: 0.20),
    ),
  ];

  static final focusRing = [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0,
      spreadRadius: 3,
      color: const Color(0xFF1F7A74).withValues(alpha: 0.25),
    ),
  ];
}
