import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/features/payment/data/models/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildLeading(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  /// Leading brand mark. Bank / QRIS logos are the official artwork reused from
  /// the web checkout (`assets/brand/payment_methods/`) and render directly —
  /// no tile — so the wordmark stays as large as possible. Manual transfer has
  /// no brand, so it keeps a bordered bank-building tile.
  Widget _buildLeading() {
    const double w = 72, h = 48;

    if (method.provider == 'manual') {
      return Container(
        width: w,
        height: h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Icon(
          Icons.account_balance,
          size: 26,
          color: AppColors.primary,
        ),
      );
    }

    final asset = _logoAssetFor(method.key);
    return SizedBox(
      width: w,
      height: h,
      child: asset != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset(
                asset,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Text(
                method.key.replaceFirst('va_', '').toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
    );
  }

  String? _logoAssetFor(String key) {
    const base = 'assets/brand/payment_methods';
    switch (key) {
      case 'va_bca':
        return '$base/bca.png';
      case 'va_mandiri':
        return '$base/mandiri.png';
      case 'va_bri':
        return '$base/bri.png';
      case 'va_bni':
        return '$base/bni.png';
      case 'qris':
        return '$base/qris.png';
      default:
        return null;
    }
  }
}
