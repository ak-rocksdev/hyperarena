import 'package:intl/intl.dart';

/// Formatting utilities for Rupiah, dates, times, and durations.
abstract final class Formatters {
  static final _rupiahFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Format integer to Rupiah: 150000 → "Rp 150.000"
  static String formatRupiah(int amount) => _rupiahFormat.format(amount);

  /// Format DateTime to full date: "15 Feb 2026"
  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy', 'id').format(date);

  /// Format DateTime to short date: "15 Feb"
  static String formatDateShort(DateTime date) =>
      DateFormat('dd MMM', 'id').format(date);

  /// Format day name: "Sen", "Sel", etc.
  static String formatDayShort(DateTime date) =>
      DateFormat('E', 'id').format(date);

  /// Pass-through time string: "07:00" → "07:00"
  static String formatTime(String time) => time;

  /// Format time range: "07:00 - 09:00"
  static String formatTimeRange(String start, String end) => '$start - $end';

  /// Format duration in hours: 2 → "2 jam"
  static String formatDuration(int hours) => '$hours jam';
}
