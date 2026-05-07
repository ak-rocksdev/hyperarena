import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/presentation/widgets/slot_grid.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class SlotSelectionScreen extends ConsumerStatefulWidget {
  const SlotSelectionScreen({super.key});

  @override
  ConsumerState<SlotSelectionScreen> createState() =>
      _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends ConsumerState<SlotSelectionScreen> {
  final Set<String> _selectedSlotIds = {};
  final List<CourtSlot> _selectedSlots = [];

  int get _totalAmount =>
      _selectedSlots.fold<int>(0, (sum, s) => sum + s.price);

  void _toggleSlot(CourtSlot slot) {
    setState(() {
      if (_selectedSlotIds.contains(slot.id)) {
        _selectedSlotIds.remove(slot.id);
        _selectedSlots.removeWhere((s) => s.id == slot.id);
      } else {
        _selectedSlotIds.add(slot.id);
        _selectedSlots.add(slot);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(bookingFlowProvider);
    final currency = ref.watch(tenantCurrencyProvider);
    final courtId = flow.court?.id ?? '';
    final date = flow.date ?? DateTime.now();

    final slotsAsync = ref.watch(
      courtSlotsProvider((courtId: courtId, date: date)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Jadwal')),
      body: Column(
        children: [
          // Date header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppSurfaces.surfaceHighlight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: AppShadows.xs,
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    Formatters.formatDate(date),
                    style: AppTypography.titleSmall,
                  ),
                ],
              ),
            ),
          ),

          // Slot grid
          Expanded(
            child: SingleChildScrollView(
              child: AsyncValueWidget(
                value: slotsAsync,
                loading: () => Padding(
                  padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
                  child: Column(
                    children: List.generate(
                      6,
                      (_) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimensions.sm),
                        child: ShimmerLoading.card(height: 60),
                      ),
                    ),
                  ),
                ),
                error: (e, _) => ErrorView(error: e),
                data: (slots) => SlotGrid(
                  slots: slots,
                  selectedSlotIds: _selectedSlotIds,
                  onSlotToggle: _toggleSlot,
                ),
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: AppShadows.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_selectedSlots.length} slot dipilih',
                        style: AppTypography.caption,
                      ),
                      Text(
                        Formatters.formatCurrency(_totalAmount, currency),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm),
                    boxShadow: _selectedSlots.isNotEmpty
                        ? AppShadows.colored
                        : null,
                  ),
                  child: AppButton(
                    label: 'Lanjutkan',
                    onPressed: _selectedSlots.isNotEmpty
                        ? () {
                            ref
                                .read(bookingFlowProvider.notifier)
                                .selectSlots(_selectedSlots);
                            context.push(AppRoutes.bookingFlowSummary);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
