import 'package:intl/intl.dart';

/// Helpers for the wallet feature's `YYYY-MM` period strings. Single source
/// of truth — previously this conversion duplicated across the period
/// selector, withdraw CTA confirmation sheet, and detail screen.
abstract final class WalletPeriod {
  /// Parses a `YYYY-MM` string. Returns `null` if the input is malformed,
  /// the month is out of range, or either segment isn't a positive integer.
  /// Callers should fall back to the current month when null.
  static DateTime? tryParse(String period) {
    final parts = period.split('-');
    if (parts.length != 2) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null) return null;
    if (year < 1970 || month < 1 || month > 12) return null;
    return DateTime(year, month);
  }

  /// Tolerant parse — falls back to "now" if the input is malformed. Use in
  /// places where rendering a sensible default beats throwing.
  static DateTime parseOrNow(String period) =>
      tryParse(period) ?? DateTime.now();

  /// Formats a DateTime back to `YYYY-MM` — symmetric inverse of [tryParse].
  static String format(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}';

  /// "Juni 2026" — long Indonesian period label. Used by the period selector,
  /// the confirmation sheet's disclosure, and the detail header.
  /// Locale `id` data ships via `GlobalMaterialLocalizations.delegate`.
  static String longLabel(String period) =>
      DateFormat.yMMMM('id').format(parseOrNow(period));
}
