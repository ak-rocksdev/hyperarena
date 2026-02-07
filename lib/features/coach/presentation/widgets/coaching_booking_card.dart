import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';

/// Card widget for displaying a coaching booking entry.
/// Reused in both coach dashboard and schedule screens.
class CoachingBookingCard extends StatelessWidget {
  final CoachingBooking booking;

  const CoachingBookingCard({super.key, required this.booking});

  String _statusLabel(BookingStatus status) => switch (status) {
        BookingStatus.pendingPayment => 'Menunggu Bayar',
        BookingStatus.waitingConfirmation => 'Menunggu Konfirmasi',
        BookingStatus.confirmed => 'Dikonfirmasi',
        BookingStatus.completed => 'Selesai',
        BookingStatus.cancelled => 'Dibatalkan',
        BookingStatus.rejected => 'Ditolak',
        BookingStatus.expired => 'Kedaluwarsa',
      };

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Sport-colored left accent bar
            Container(
              width: 4,
              color: sportTheme.color(booking.sport),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Student name + Status badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            booking.playerName,
                            style: AppTypography.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.sm,
                            vertical: AppDimensions.xxs,
                          ),
                          decoration: BoxDecoration(
                            color:
                                statusTheme.backgroundColor(booking.status),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            _statusLabel(booking.status),
                            style: AppTypography.labelMedium.copyWith(
                              color:
                                  statusTheme.textColor(booking.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Row 2: Date + Time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppDimensions.iconXs,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          Formatters.formatDate(booking.date),
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: AppDimensions.md),
                        Icon(
                          Icons.access_time,
                          size: AppDimensions.iconXs,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Text(
                          Formatters.formatTimeRange(
                            booking.startTime,
                            booking.endTime,
                          ),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),

                    // Row 3: Venue
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: AppDimensions.iconXs,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        Expanded(
                          child: Text(
                            booking.venueName,
                            style: AppTypography.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Row 4: Package name + Amount
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            booking.packageName,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          Formatters.formatRupiah(booking.amount),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),

                    // Sport pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: sportTheme.backgroundColor(booking.sport),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: Text(
                        SportChipSelector.sportLabel(booking.sport),
                        style: AppTypography.badge.copyWith(
                          color: sportTheme.textColor(booking.sport),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
