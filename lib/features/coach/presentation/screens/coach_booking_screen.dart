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
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/presentation/widgets/date_picker_strip.dart';
import 'package:hyperarena/features/coach/providers/coach_booking_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachBookingScreen extends ConsumerStatefulWidget {
  const CoachBookingScreen({super.key});

  @override
  ConsumerState<CoachBookingScreen> createState() => _CoachBookingScreenState();
}

class _CoachBookingScreenState extends ConsumerState<CoachBookingScreen> {
  final _venueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final venueName = ref.read(coachBookingProvider).venueName;
    if (venueName != null) {
      _venueController.text = venueName;
    }
  }

  @override
  void dispose() {
    _venueController.dispose();
    super.dispose();
  }

  /// Generate time slots from 07:00 to 20:00.
  /// Each slot's end time is based on the package duration.
  /// Slots that would end after 22:00 are excluded.
  List<({String start, String end})> _generateTimeSlots(int durationMinutes) {
    final slots = <({String start, String end})>[];
    for (int hour = 7; hour <= 20; hour++) {
      final startMinute = 0;
      final endTotalMinutes = hour * 60 + startMinute + durationMinutes;

      // Don't show slots that would end after 22:00
      if (endTotalMinutes > 22 * 60) break;

      final endHour = endTotalMinutes ~/ 60;
      final endMinute = endTotalMinutes % 60;

      final startStr =
          '${hour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
      final endStr =
          '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

      slots.add((start: startStr, end: endStr));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(coachBookingProvider);
    final currency = ref.watch(tenantCurrencyProvider);
    final notifier = ref.read(coachBookingProvider.notifier);
    final coach = bookingState.coach;
    final package = bookingState.package;

    if (coach == null || package == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Coaching')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    final timeSlots = _generateTimeSlots(package.durationMinutes);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Coaching')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.base),

                  // ── Package summary card ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.base),
                      decoration: BoxDecoration(
                        color: AppSurfaces.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusLg),
                        boxShadow: AppShadows.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coach.name,
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            package.name,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.sm,
                                  vertical: AppDimensions.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary50,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSm,
                                  ),
                                ),
                                child: Text(
                                  SportChipSelector.sportLabel(package.sport),
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primary700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppDimensions.sm),
                              Icon(
                                Icons.schedule,
                                size: AppDimensions.iconXs,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(width: AppDimensions.xs),
                              Text(
                                '${package.durationMinutes} menit',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            '${Formatters.formatCurrency(package.pricePerSession, currency)}/sesi',
                            style: AppTypography.price,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // ── Date section ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Text(
                      'Pilih Tanggal',
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  DatePickerStrip(
                    selectedDate: bookingState.date,
                    onDateSelected: (date) => notifier.selectDate(date),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // ── Time section ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Text(
                      'Pilih Waktu',
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Wrap(
                      spacing: AppDimensions.sm,
                      runSpacing: AppDimensions.sm,
                      children: timeSlots.map((slot) {
                        final isSelected =
                            bookingState.startTime == slot.start &&
                                bookingState.endTime == slot.end;

                        return GestureDetector(
                          onTap: () =>
                              notifier.selectTime(slot.start, slot.end),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.md,
                              vertical: AppDimensions.sm,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppSurfaces.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSm,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.neutral200,
                              ),
                              boxShadow:
                                  isSelected ? AppShadows.sm : AppShadows.xs,
                            ),
                            child: Text(
                              Formatters.formatTimeRange(
                                  slot.start, slot.end),
                              style: AppTypography.labelMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.xl),

                  // ── Venue name section ────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: Text(
                      'Lokasi Venue',
                      style: AppTypography.titleMedium,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: package.venueName != null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppDimensions.base),
                            decoration: BoxDecoration(
                              color: AppSurfaces.surface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                              boxShadow: AppShadows.xs,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: AppDimensions.iconMd,
                                ),
                                const SizedBox(width: AppDimensions.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        package.venueName!,
                                        style: AppTypography.titleSmall,
                                      ),
                                      const SizedBox(
                                          height: AppDimensions.xs),
                                      Text(
                                        'Dari paket coaching',
                                        style:
                                            AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : TextField(
                            controller: _venueController,
                            onChanged: (value) =>
                                notifier.setVenueName(value),
                            decoration: InputDecoration(
                              hintText: 'Contoh: GOR Senayan',
                              prefixIcon: const Icon(
                                  Icons.location_on_outlined),
                              filled: true,
                              fillColor: AppSurfaces.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.neutral200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                                borderSide: BorderSide(
                                    color: AppColors.neutral200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: AppDimensions.base,
                                vertical: AppDimensions.md,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: AppDimensions.xxl),
                ],
              ),
            ),
          ),

          // ── Bottom bar ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              boxShadow: AppShadows.bottomNav,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: AppTypography.caption,
                        ),
                        Text(
                          Formatters.formatCurrency(bookingState.totalAmount, currency),
                          style: AppTypography.priceLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.base),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                        boxShadow: bookingState.isComplete
                            ? AppShadows.colored
                            : null,
                      ),
                      child: AppButton(
                        label: 'Lanjutkan',
                        isLarge: true,
                        onPressed: bookingState.isComplete
                            ? () => context.push(AppRoutes.coachBookingPayment)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
