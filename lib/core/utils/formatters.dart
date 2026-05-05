import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:intl/intl.dart';

/// Formatting utilities for Rupiah, dates, times, and durations.
abstract final class Formatters {
  static final _rupiahFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _whitespace = RegExp(r'\s+');
  static final _dateLong = DateFormat('EEEE, d MMMM yyyy', 'id');
  static final _timeHm = DateFormat('HH:mm', 'id');
  static final _dateTimeCompact = DateFormat('EEE, d MMM yyyy \u2022 HH:mm', 'id');

  /// Format integer to Rupiah: 150000 → "Rp 150.000"
  static String formatRupiah(int amount) => _rupiahFormat.format(amount);

  /// Compact Rupiah: 750000 → "Rp 750rb", 4200000 → "Rp 4,2jt"
  static String formatRupiahCompact(int amount) {
    if (amount >= 1000000) {
      final jt = amount / 1000000;
      final formatted =
          jt == jt.truncateToDouble() ? '${jt.toInt()}' : jt.toStringAsFixed(1);
      return 'Rp ${formatted}jt';
    }
    if (amount >= 1000) {
      final rb = amount / 1000;
      final formatted =
          rb == rb.truncateToDouble() ? '${rb.toInt()}' : rb.toStringAsFixed(0);
      return 'Rp ${formatted}rb';
    }
    return 'Rp $amount';
  }

  /// Format DateTime to full date: "15 Feb 2026"
  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy', 'id').format(date);

  /// Format DateTime to short date: "15 Feb"
  static String formatDateShort(DateTime date) =>
      DateFormat('dd MMM', 'id').format(date);

  /// Format day name: "Sen", "Sel", etc.
  static String formatDayShort(DateTime date) =>
      DateFormat('E', 'id').format(date);

  /// Format DateTime to long date: "Senin, 15 Februari 2026"
  static String formatDateLong(DateTime date) => _dateLong.format(date);

  /// Format DateTime to HH:mm: "07:00"
  static String formatTimeHm(DateTime date) => _timeHm.format(date);

  /// Format DateTime compact: "Sen, 15 Feb 2026 • 07:00"
  static String formatDateTimeCompact(DateTime date) =>
      _dateTimeCompact.format(date);

  /// Pass-through time string: "07:00" → "07:00"
  static String formatTime(String time) => time;

  /// Format time range: "07:00 - 09:00"
  static String formatTimeRange(String start, String end) => '$start - $end';

  /// Format duration in hours: 2 → "2 jam"
  static String formatDuration(int hours) => '$hours jam';

  /// Human-readable label for session visibility.
  static String visibilityLabel(SessionVisibility v) => switch (v) {
    SessionVisibility.free => 'Gratis / Terbuka',
    SessionVisibility.invitationOnly => 'Undangan Publik',
    SessionVisibility.membersOnly => 'Khusus Member',
  };

  /// Extract initials from a name: "John Doe" → "JD", "Alice" → "A"
  static String initials(String name) {
    final parts = name.trim().split(_whitespace);
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// First word of a name: "Sari Wijayanti" → "Sari". Returns [fallback]
  /// when [name] is null or blank.
  static String firstName(String? name, {required String fallback}) {
    if (name == null || name.trim().isEmpty) return fallback;
    return name.trim().split(_whitespace).first;
  }
}
