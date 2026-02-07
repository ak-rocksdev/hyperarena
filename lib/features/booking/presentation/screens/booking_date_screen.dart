import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/booking/presentation/widgets/date_picker_strip.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';

class BookingDateScreen extends ConsumerStatefulWidget {
  final String courtId;

  const BookingDateScreen({super.key, required this.courtId});

  @override
  ConsumerState<BookingDateScreen> createState() => _BookingDateScreenState();
}

class _BookingDateScreenState extends ConsumerState<BookingDateScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Find the court from venues and set it in the flow provider
    _initCourt();
  }

  void _initCourt() {
    // Court + venue should already be set by CourtCard tap via bookingFlowProvider
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(bookingFlowProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Tanggal')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court info card
          if (flow.court != null && flow.venue != null)
            Container(
              margin: const EdgeInsets.all(AppDimensions.screenHorizontal),
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppSurfaces.surfaceHighlight,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusLg),
                boxShadow: AppShadows.xs,
              ),
              child: Row(
                children: [
                  Icon(
                    SportChipSelector.sportIcon(flow.court!.sportType),
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flow.court!.name,
                          style: AppTypography.titleSmall,
                        ),
                        Text(
                          flow.venue!.name,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
            ),
            child: Text('Pilih Tanggal', style: AppTypography.titleMedium),
          ),
          const SizedBox(height: AppDimensions.md),

          DatePickerStrip(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              ref.read(bookingFlowProvider.notifier).selectDate(date);
            },
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                boxShadow: _selectedDate != null ? AppShadows.colored : null,
              ),
              child: AppButton(
                label: 'Lanjutkan',
                isLarge: true,
                onPressed: _selectedDate != null
                    ? () => context.push('/booking/flow/slots')
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
