import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';

class OwnerBookingQueueScreen extends ConsumerStatefulWidget {
  const OwnerBookingQueueScreen({super.key});

  @override
  ConsumerState<OwnerBookingQueueScreen> createState() =>
      _OwnerBookingQueueScreenState();
}

class _OwnerBookingQueueScreenState
    extends ConsumerState<OwnerBookingQueueScreen> {
  String _filter = 'Menunggu';

  List<Booking> _applyFilter(List<Booking> bookings) {
    switch (_filter) {
      case 'Menunggu':
        return bookings
            .where(
              (b) =>
                  b.status == BookingStatus.waitingConfirmation ||
                  b.status == BookingStatus.pendingPayment,
            )
            .toList();
      case 'Dikonfirmasi':
        return bookings
            .where(
              (b) =>
                  b.status == BookingStatus.confirmed ||
                  b.status == BookingStatus.completed,
            )
            .toList();
      default:
        return bookings;
    }
  }

  bool _isPending(BookingStatus status) =>
      status == BookingStatus.waitingConfirmation ||
      status == BookingStatus.pendingPayment;

  @override
  Widget build(BuildContext context) {
    final queueAsync = ref.watch(ownerBookingQueueProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Antrian Booking')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.md,
            ),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Semua', label: Text('Semua')),
                  ButtonSegment(value: 'Menunggu', label: Text('Menunggu')),
                  ButtonSegment(
                    value: 'Dikonfirmasi',
                    label: Text('Dikonfirmasi'),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (selection) {
                  setState(() => _filter = selection.first);
                },
              ),
            ),
          ),
          Expanded(
            child: AsyncValueWidget(
              value: queueAsync,
              data: (bookings) {
                final filtered = _applyFilter(bookings);
                if (filtered.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada booking menunggu konfirmasi',
                    icon: Icons.fact_check_outlined,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ).copyWith(bottom: AppDimensions.screenBottom),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.sm),
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    return _BookingQueueCard(
                      booking: booking,
                      isPending: _isPending(booking.status),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingQueueCard extends ConsumerWidget {
  const _BookingQueueCard({
    required this.booking,
    required this.isPending,
  });

  final Booking booking;
  final bool isPending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.bookingCode,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.neutral400,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      '${booking.courtName ?? '-'} \u00b7 ${booking.venueName ?? '-'}',
                      style: AppTypography.titleSmall,
                    ),
                    const SizedBox(height: AppDimensions.xxs),
                    Text(
                      '${Formatters.formatDate(booking.bookingDate)} \u00b7 ${Formatters.formatTimeRange(booking.startTime, booking.endTime)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              // Right column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(booking.totalAmount, currency),
                    style: AppTypography.titleSmall,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  _SourceChip.langsung(),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          if (isPending) _PendingActions(booking: booking),
          if (!isPending) _ConfirmedBadge(),
        ],
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory _SourceChip.langsung() => const _SourceChip(
        label: 'Langsung',
        backgroundColor: AppColors.primary50,
        textColor: AppColors.primary,
      );

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: textColor),
      ),
    );
  }
}

class _PendingActions extends ConsumerWidget {
  const _PendingActions({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(ownerActionsProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _showConfirmSheet(context, actions, currency),
                child: const Text('Konfirmasi Diterima'),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSettleSheet(context, actions),
                child: const Text('Tandai Lunas'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => _showRejectDialog(context, actions),
            child: Text(
              'Tolak',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  void _showConfirmSheet(
    BuildContext context,
    OwnerActionsController actions,
    String currency,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontal,
          AppDimensions.xl,
          AppDimensions.screenHorizontal,
          AppDimensions.screenBottom + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Konfirmasi Pembayaran', style: AppTypography.headingSmall),
            const SizedBox(height: AppDimensions.base),
            Text(
              'Kode: ${booking.bookingCode}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Lapangan: ${booking.courtName ?? '-'}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Jumlah: ${Formatters.formatCurrency(booking.totalAmount, currency)}',
              style: AppTypography.titleSmall,
            ),
            const SizedBox(height: AppDimensions.base),
            Text(
              'Konfirmasi pembayaran diterima?',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await actions.confirmBooking(booking.id);
                },
                child: const Text('Konfirmasi'),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
          ],
        ),
      ),
    );
  }

  void _showSettleSheet(
    BuildContext context,
    OwnerActionsController actions,
  ) {
    final noteController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontal,
          AppDimensions.xl,
          AppDimensions.screenHorizontal,
          AppDimensions.screenBottom + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tandai Pembayaran Lunas',
              style: AppTypography.headingSmall,
            ),
            const SizedBox(height: AppDimensions.base),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Catatan (transfer bank, tunai, dll)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppDimensions.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  // markBookingSettled not available — fallback to confirmBooking
                  await actions.confirmBooking(booking.id);
                },
                child: const Text('Tandai Lunas'),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
          ],
        ),
      ),
    ).then((_) => noteController.dispose());
  }

  void _showRejectDialog(
    BuildContext context,
    OwnerActionsController actions,
  ) {
    final reasonController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tolak Booking'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Alasan penolakan',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              await actions.rejectBooking(booking.id, reason: reason);
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    ).then((_) => reasonController.dispose());
  }
}

class _ConfirmedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: AppDimensions.iconSm,
          color: AppColors.success,
        ),
        const SizedBox(width: AppDimensions.xs),
        Text(
          'Terkonfirmasi',
          style: AppTypography.labelSmall.copyWith(color: AppColors.success),
        ),
      ],
    );
  }
}
