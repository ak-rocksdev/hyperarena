import 'package:flutter/services.dart';
import 'package:hyperarena/core/utils/formatters.dart';

/// Masks a price field with the tenant currency's grouping separator as the
/// user types — "185000" → "185.000" (IDR / id_ID), "185,000" (USD / en_US).
///
/// The amount is treated as whole major units: the create-session price field
/// takes no sub-unit input (the flow multiplies to minor units on submit), so
/// only integer grouping is handled — no decimal point is accepted. The caret
/// is kept beside the same digit it was next to, so mid-string edits and
/// backspacing don't jump it to the end.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  ThousandsSeparatorInputFormatter(this.currency);

  final String currency;

  static final _nonDigit = RegExp(r'[^0-9]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(_nonDigit, '');
    if (digits.isEmpty) return const TextEditingValue();

    final formatted = Formatters.groupDigits(digits, currency);

    // Preserve caret position by digit count: how many digits preceded the
    // caret in the raw input, place it after that many digits once grouped.
    final digitsBeforeCaret = newValue.text
        .substring(0, newValue.selection.end)
        .replaceAll(_nonDigit, '')
        .length;

    var offset = formatted.length;
    var seen = 0;
    for (var i = 0; i < formatted.length; i++) {
      if (seen == digitsBeforeCaret) {
        offset = i;
        break;
      }
      if (!_nonDigit.hasMatch(formatted[i])) seen++;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
