import 'package:flutter/material.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:intl/intl.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.sessionLabel,
    this.sessionStartAt,
    this.venueName,
    required this.userName,
    required this.amount,
    required this.paymentMethodLabel,
    required this.paidAt,
    required this.status,
  });

  final String sessionLabel;
  final DateTime? sessionStartAt;
  final String? venueName;
  final String userName;
  final int amount;
  final String paymentMethodLabel;
  final DateTime paidAt;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sessionLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (sessionStartAt != null) ...[
            const SizedBox(height: 6),
            _IconLine(
              icon: Icons.calendar_today_outlined,
              text: _formatStartAt(sessionStartAt!),
            ),
          ],
          if (venueName != null) ...[
            const SizedBox(height: 4),
            _IconLine(icon: Icons.location_on_outlined, text: venueName!),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _Row(label: 'Atas Nama', value: userName),
          const SizedBox(height: 4),
          _Row(
            label: 'Status',
            value: _statusLabel,
            valueColor: _statusColor,
            valueBold: true,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _Row(
            label: 'Total Bayar',
            value: Formatters.formatCurrency(amount, 'IDR'),
            valueBold: true,
          ),
          const SizedBox(height: 4),
          _Row(label: 'Metode', value: paymentMethodLabel),
          const SizedBox(height: 4),
          _Row(
            label: 'Tanggal',
            value: _formatPaidAt(paidAt),
          ),
        ],
      ),
    );
  }

  String _formatStartAt(DateTime dt) {
    try {
      return DateFormat("EEE, d MMM y '•' HH:mm", 'id').format(dt.toLocal());
    } catch (_) {
      return DateFormat("EEE, d MMM y '•' HH:mm").format(dt.toLocal());
    }
  }

  String _formatPaidAt(DateTime dt) {
    try {
      return DateFormat('d MMM y, HH:mm', 'id').format(dt.toLocal());
    } catch (_) {
      return DateFormat('d MMM y, HH:mm').format(dt.toLocal());
    }
  }

  String get _statusLabel => switch (status) {
    'confirmed' => '✓ Terkonfirmasi',
    'awaiting_review' => '⏳ Menunggu verifikasi',
    'expired' => '✕ Kedaluwarsa',
    _ => status,
  };

  Color get _statusColor => switch (status) {
    'confirmed' => Colors.green.shade700,
    'awaiting_review' => Colors.amber.shade800,
    'expired' => Colors.red,
    _ => Colors.grey,
  };
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
