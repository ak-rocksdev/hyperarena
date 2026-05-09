import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/shared/providers/money_visibility_provider.dart';

// Hoisted: matches the leading non-digit currency prefix on a formatted
// money string (e.g. "Rp ", "RM ", "$ "). Reused by `maskFormatted` so the
// pattern isn't re-parsed on each rebuild.
final _kCurrencyPrefix = RegExp(r'^[^\d-]+');

/// Renders an already-formatted money string, masking the digits when
/// `moneyVisibilityProvider` is off. The mask preserves the currency prefix
/// (e.g. `Rp`) so the layout doesn't shift when toggled — only the digits
/// are replaced with bullets.
///
/// Example:
///   MoneyText('Rp 4.900.000', style: AppTypography.headingLarge)
///   → visible:  "Rp 4.900.000"
///   → masked:   "Rp ••••••"
class MoneyText extends ConsumerWidget {
  const MoneyText(
    this.formatted, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.maskWidth = 6,
  });

  /// The fully-formatted currency string (e.g. output of
  /// `Formatters.formatCurrency` or `formatCurrencyCompact`).
  final String formatted;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  /// Number of bullets to render when masked. Default 6 ≈ "Rp ••••••" which
  /// reads as masked without becoming overly wide on narrow tiles.
  final int maskWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(moneyVisibilityProvider);
    final display = visible ? formatted : maskFormatted(formatted, maskWidth);
    return Text(
      display,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  /// Replaces the digit run in a formatted currency string with `count`
  /// bullets, preserving any leading currency prefix (`Rp `, `RM `, `$ `).
  /// Public so other widgets can reuse the masked form when they don't
  /// want a full `MoneyText` (e.g. inline within a chip label).
  static String maskFormatted(String formatted, [int count = 6]) {
    final mask = '\u2022' * count;
    final prefix = _kCurrencyPrefix.firstMatch(formatted)?.group(0)?.trim();
    return (prefix == null || prefix.isEmpty) ? mask : '$prefix $mask';
  }

  /// Helper for embedding a maskable money value inside an existing
  /// `Text.rich` / `TextSpan` tree. Returns a `TextSpan` whose text is
  /// either the formatted value or its masked form, depending on the
  /// current `moneyVisibilityProvider` state.
  ///
  /// Usage:
  ///   Text.rich(TextSpan(children: [
  ///     const TextSpan(text: '10 pemain · '),
  ///     MoneyText.span(ref, 'Rp 1.5jt', style: const TextStyle(fontWeight: FontWeight.w700)),
  ///   ]))
  static TextSpan span(
    WidgetRef ref,
    String formatted, {
    TextStyle? style,
    int maskWidth = 6,
  }) {
    final visible = ref.watch(moneyVisibilityProvider);
    return TextSpan(
      text: visible ? formatted : maskFormatted(formatted, maskWidth),
      style: style,
    );
  }
}

/// AppBar-friendly icon button that toggles `moneyVisibilityProvider`.
/// Drop into any screen that exposes monetary values; the icon switches
/// between `visibility_outlined` (currently visible — tap to hide) and
/// `visibility_off_outlined` (currently masked — tap to reveal).
class MoneyVisibilityToggle extends ConsumerWidget {
  const MoneyVisibilityToggle({super.key, this.tooltip});

  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(moneyVisibilityProvider);
    return IconButton(
      icon: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      tooltip:
          tooltip ?? (visible ? 'Sembunyikan nominal' : 'Tampilkan nominal'),
      onPressed: () => ref.read(moneyVisibilityProvider.notifier).toggle(),
    );
  }
}
