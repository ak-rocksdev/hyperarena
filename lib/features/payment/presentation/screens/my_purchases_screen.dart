import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/purchase_card_summary.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:intl/intl.dart';

class MyPurchasesScreen extends ConsumerStatefulWidget {
  const MyPurchasesScreen({super.key});

  @override
  ConsumerState<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends ConsumerState<MyPurchasesScreen> {
  String? _statusFilter; // null = all

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(myPurchasesProvider(_statusFilter));

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: purchasesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Gagal memuat: $e')),
              data: (items) => items.isEmpty
                  ? const _EmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(myPurchasesProvider(_statusFilter));
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) => _PurchaseCard(item: items[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    const filters = [
      (null, 'Semua'),
      ('pending_payment', 'Belum Bayar'),
      ('confirmed', 'Berhasil'),
      ('expired', 'Kedaluwarsa'),
      ('cancelled', 'Dibatalkan'),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (value, label) = filters[i];
          final selected = _statusFilter == value;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            selectedColor: AppColors.primary50,
            onSelected: (selected) => setState(() => _statusFilter = value),
          );
        },
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({required this.item});

  final PurchaseCardSummary item;

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = switch (item.status) {
      'pending_payment' => ('Menunggu Pembayaran', Colors.amber.shade700),
      'confirmed' => ('Berhasil', Colors.green.shade700),
      'cancelled' => ('Dibatalkan', Colors.grey.shade600),
      'expired' => ('Kedaluwarsa', Colors.red.shade600),
      'rejected' => ('Ditolak', Colors.red.shade800),
      _ => (item.status, Colors.grey),
    };

    return InkWell(
      onTap: () => context.push('/purchases/${item.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.reference,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.session?.displayTitle ?? item.productLabel ?? 'Pesanan',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (item.session?.startAt != null) ...[
              const SizedBox(height: 2),
              Text(
                _safeDateFormat(
                  'EEE, d MMM y • HH:mm',
                  item.session!.startAt!,
                ),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatters.formatCurrency(item.amountTotal, item.currency),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                if (item.tenant != null)
                  Text(
                    item.tenant!.name,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _safeDateFormat(String pattern, DateTime dt) {
    try {
      return DateFormat(pattern, 'id').format(dt.toLocal());
    } catch (_) {
      return DateFormat(pattern).format(dt.toLocal());
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada pesanan.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
