import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> copyToClipboard(BuildContext context, String value, {String? message}) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Disalin: $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
