import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:intl/intl.dart';

/// Formatting utilities for currency, dates, times, and durations.
abstract final class Formatters {
  // ── Currency ───────────────────────────────────────────────────────
  //
  // Mirrors:
  //   BE:  app/Helpers/CurrencyHelper.php
  //   Web: resources/js/utils/currency.js
  //
  // Storage convention: amounts are stored in the smallest unit. Zero-
  // decimal currencies (IDR, JPY, KRW, …) store as whole units; the rest
  // (MYR, USD, SGD, …) store as ×100 (cents/sen). When a new zero-decimal
  // currency is introduced, add it to BOTH this set AND the BE helper
  // AND web mirror, in the same commit.

  static const _zeroDecimalCurrencies = {
    'IDR', 'JPY', 'KRW', 'VND', 'CLP', 'PYG', 'RWF', 'UGX',
  };

  static const _currencyLocales = <String, String>{
    'IDR': 'id_ID',
    'MYR': 'ms_MY',
    'USD': 'en_US',
    'SGD': 'en_SG',
  };

  static const _currencySymbols = <String, String>{
    'IDR': 'Rp ',
    'MYR': 'RM ',
    'USD': r'$ ',
    'SGD': r'$ ',
  };

  // Bounded by the supported-currency set above (~4 entries) — intentionally
  // never evicted. `intl`'s `NumberFormat` constructor parses locale tables,
  // so reuse pays off on payment lists.
  static final Map<String, _CurrencySpec> _currencySpecs = {};

  static _CurrencySpec _specFor(String upper) {
    return _currencySpecs.putIfAbsent(upper, () {
      final locale = _currencyLocales[upper] ?? 'en_US';
      final symbol = _currencySymbols[upper] ?? '$upper ';
      final isZeroDecimal = _zeroDecimalCurrencies.contains(upper);
      return _CurrencySpec(
        symbol: symbol,
        multiplier: isZeroDecimal ? 1 : 100,
        currency: NumberFormat.currency(
          locale: locale,
          symbol: symbol,
          decimalDigits: isZeroDecimal ? 0 : 2,
        ),
        decimal: NumberFormat('0.#', locale),
      );
    });
  }

  /// Locale-aware currency formatter.
  ///
  /// `formatCurrency(150000, 'IDR')` → "Rp 150.000"
  /// `formatCurrency(5000, 'MYR')`   → "RM 50.00" (5000 sen → 50 ringgit)
  ///
  /// [amount] is in the smallest unit (rupiah for IDR, sen for MYR — same
  /// convention BE uses for storage).
  static String formatCurrency(int amount, String currency) {
    final spec = _specFor(currency.toUpperCase());
    final display = spec.multiplier == 1 ? amount : amount / spec.multiplier;
    return spec.currency.format(display);
  }

  /// Compact currency: 750000 IDR → "Rp 750rb", 4200000 IDR → "Rp 4,2jt".
  /// For non-Indonesian currencies falls back to the K/M suffix convention
  /// since "rb"/"jt" are Indonesian-specific. Decimal separator follows the
  /// currency locale (id → "4,2", en → "4.2").
  static String formatCurrencyCompact(int amount, String currency) {
    final upper = currency.toUpperCase();
    final spec = _specFor(upper);
    final display = spec.multiplier == 1 ? amount : amount / spec.multiplier;
    final useIndonesian = upper == 'IDR';
    final unitMillion = useIndonesian ? 'jt' : 'M';
    final unitThousand = useIndonesian ? 'rb' : 'K';

    String render(num value, String unit) {
      final asDouble = value.toDouble();
      final whole = asDouble == asDouble.truncateToDouble();
      return whole
          ? '${asDouble.toInt()}$unit'
          : '${spec.decimal.format(asDouble)}$unit';
    }

    if (display >= 1000000) return '${spec.symbol}${render(display / 1000000, unitMillion)}';
    if (display >= 1000) return '${spec.symbol}${render(display / 1000, unitThousand)}';
    return '${spec.symbol}${render(display, '')}';
  }

  static final _whitespace = RegExp(r'\s+');
  static final _dateLong = DateFormat('EEEE, d MMMM yyyy', 'id');
  static final _timeHm = DateFormat('HH:mm', 'id');
  static final _dateTimeCompact = DateFormat('EEE, d MMM yyyy \u2022 HH:mm', 'id');

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

  /// Joins a first/last name pair, tolerating nulls + empty parts. Returns
  /// [fallback] when the joined value is empty.
  static String fullName(String? first, String? last,
      {String fallback = 'Siswa'}) {
    final joined = '${first ?? ''} ${last ?? ''}'.trim();
    return joined.isEmpty ? fallback : joined;
  }

  /// Indonesian relative date: "Hari ini" / "Kemarin" / "3 hari lalu" /
  /// "2 minggu lalu" / "5 bulan lalu" / "Mar 2024" for older dates.
  /// Future dates fall back to absolute formatting.
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(that).inDays;
    if (diffDays < 0) return formatDateShort(date);
    if (diffDays == 0) return 'Hari ini';
    if (diffDays == 1) return 'Kemarin';
    if (diffDays < 7) return '$diffDays hari lalu';
    if (diffDays < 30) {
      final weeks = (diffDays / 7).floor();
      return '$weeks minggu lalu';
    }
    if (diffDays < 365) {
      final months = (diffDays / 30).floor();
      return '$months bulan lalu';
    }
    return formatDateShort(date);
  }

  /// Whole-year age from DOB. Null in → null out (caller renders fallback
  /// like "Umur Not Set" — we don't bake the fallback string in here).
  static int? ageInYears(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age < 0 ? null : age;
  }

  /// Returns `null` when the input is empty, else the input itself. Useful
  /// for clearing nullable backend fields when a user wipes a form input —
  /// `'bio': nullIfEmpty(_bio.text.trim())` sends `null` (clears column)
  /// instead of an empty string.
  static String? nullIfEmpty(String value) => value.isEmpty ? null : value;

  /// Renders the per-person price label respecting `pricing.payment_mode`.
  /// Falls back to `fallbackAmount` + `tenantCurrency` when `pricing` is
  /// null (older clients / mock fixtures that don't populate the block).
  ///
  /// Output:
  ///   - 'unconfigured' → `"Harga sesi belum diatur"`
  ///   - 'credit'       → `"1 Kredit / orang (≈ Rp 200.000)"`
  ///   - 'nominal'      → `"Rp 200.000 / orang"`
  static String sessionPriceLabel({
    int? effectivePrice,
    String? paymentMode,
    int? creditRequired,
    String? currency,
    required int fallbackAmount,
    required String tenantCurrency,
  }) {
    if (paymentMode == null || effectivePrice == null) {
      return '${formatCurrency(fallbackAmount, tenantCurrency)} / orang';
    }
    if (paymentMode == 'unconfigured') {
      return 'Harga sesi belum diatur';
    }
    final priceStr = formatCurrency(effectivePrice, currency ?? tenantCurrency);
    if (paymentMode == 'credit') {
      // Credit count up front so the organizer's eye lands on the unit;
      // nominal equivalent in parens for context.
      final credits = creditRequired ?? 1;
      final unit = credits == 1 ? '1 Kredit' : '$credits Kredit';
      return '$unit / orang (≈ $priceStr)';
    }
    return '$priceStr / orang';
  }
}

class _CurrencySpec {
  final String symbol;
  final int multiplier;
  final NumberFormat currency;
  final NumberFormat decimal;

  const _CurrencySpec({
    required this.symbol,
    required this.multiplier,
    required this.currency,
    required this.decimal,
  });
}
