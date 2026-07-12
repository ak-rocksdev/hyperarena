import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/payment/data/models/purchase_card_summary.dart';
import 'package:hyperarena/features/payment/data/providers/payment_providers.dart';
import 'package:hyperarena/features/payment/presentation/purchase_status_ui.dart';

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
          const _PullToRefreshHint(),
          Expanded(
            // RefreshIndicator wraps every state (data/empty/error) and the
            // lists force AlwaysScrollableScrollPhysics so pull-to-refresh
            // works even when the content doesn't fill the screen.
            child: RefreshIndicator(
              // Swallow refresh failures — the provider's error state renders
              // them; an escaped rejection would only pollute crash logs.
              onRefresh: () => ref
                  .refresh(myPurchasesProvider(_statusFilter).future)
                  .catchError((_) => <PurchaseCardSummary>[]),
              child: purchasesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, stack) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(child: Text('Gagal memuat: $e')),
                    ),
                  ],
                ),
                data: (items) => items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 320, child: _EmptyState()),
                        ],
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) =>
                            _PurchaseCard(item: items[i]),
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
    final (statusLabel, statusColor) = purchaseStatusUi(item.status);

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
                Formatters.tryFormatId(
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

}

/// Subtle caption telling users the list can be pulled down to refresh.
class _PullToRefreshHint extends StatelessWidget {
  const _PullToRefreshHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_downward, size: 11, color: AppColors.neutral500),
          const SizedBox(width: 4),
          Text(
            'Tarik ke bawah untuk memperbarui',
            style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
          ),
        ],
      ),
    );
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
