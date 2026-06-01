import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/clipboard.dart';
import 'package:hyperarena/core/utils/formatters.dart';

class VaAccountDisplay extends StatelessWidget {
  const VaAccountDisplay({
    super.key,
    required this.bank,
    required this.accountNumber,
    required this.amount,
  });

  final String bank;
  final String accountNumber;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Virtual Account $bank',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  accountNumber,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => copyToClipboard(
                  context,
                  accountNumber,
                  message: 'Nomor VA disalin',
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'Total Bayar',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatCurrency(amount, 'IDR'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
