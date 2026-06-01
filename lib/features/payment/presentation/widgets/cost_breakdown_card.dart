import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';

class CostBreakdownCard extends StatelessWidget {
  const CostBreakdownCard({
    super.key,
    required this.itemLabel,
    required this.basePrice,
    required this.adminFee,
    this.adminFeeNote,
  });

  final String itemLabel;
  final int basePrice;
  final int adminFee;
  final String? adminFeeNote; // optional small text under fee, e.g. "Gratis untuk transfer manual"

  int get total => basePrice + adminFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _row(label: itemLabel, value: Formatters.formatCurrency(basePrice, 'IDR')),
          const SizedBox(height: 6),
          _row(
            label: 'Biaya admin',
            value: adminFee == 0
                ? 'Gratis'
                : Formatters.formatCurrency(adminFee, 'IDR'),
            valueColor: adminFee == 0 ? Colors.green.shade700 : null,
          ),
          if (adminFeeNote != null) ...[
            const SizedBox(height: 2),
            Text(
              adminFeeNote!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Bayar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                Formatters.formatCurrency(total, 'IDR'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row({required String label, required String value, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: valueColor,
            fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
