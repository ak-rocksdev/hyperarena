import 'package:flutter/services.dart';

/// Single source of truth for haptic feedback intensities used across the
/// app. Wraps `HapticFeedback` so we can swap the underlying mechanism
/// later (e.g. a vibration package with richer patterns) without
/// touching every call site.
///
/// Pick by intent, not by intensity:
/// - [tap]: user committed to an action (Login, Bayar, Daftar, Simpan).
///   Uses `vibrate()` because Samsung's haptic engine renders the
///   `*Impact()` constants at near-zero intensity even with system
///   haptics enabled.
/// - [selection]: light "received" feedback for picks (filter chips,
///   tab switches if the result blocks for a network call).
/// - [success]: action completed cleanly.
/// - [error]: action failed. Heavier so users notice the mismatch
///   between expected success and the toast/snackbar that follows.
abstract final class AppHaptics {
  static void tap() => HapticFeedback.vibrate();
  static void selection() => HapticFeedback.selectionClick();
  static void success() => HapticFeedback.lightImpact();
  static void error() => HapticFeedback.heavyImpact();
}
