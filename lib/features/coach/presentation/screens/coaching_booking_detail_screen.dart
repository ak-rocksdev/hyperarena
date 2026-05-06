import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_coaching_bookings.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachingBookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const CoachingBookingDetailScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CoachingBooking? booking = MockCoachingBookings.bookings
        .where((b) => b.id == bookingId)
        .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Booking Coaching')),
      body: booking == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconXl,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  Text(
                    'Booking tidak ditemukan',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            )
          : _BookingContent(booking: booking),
    );
  }
}

class _BookingContent extends StatelessWidget {
  final CoachingBooking booking;

  const _BookingContent({required this.booking});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Status badge ────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: statusTheme
                        .backgroundColor(booking.status)
                        .withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                  child: Row(
                    children: [
                      StatusBadge(status: booking.status),
                      const Spacer(),
                      Text(
                        booking.id.toUpperCase(),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── Player info ─────────────────────────────────
                Container(
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
                      Text('Pemain', style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      )),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        booking.playerName,
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.base),

                // ── Package info ────────────────────────────────
                Container(
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
                      Text('Paket', style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      )),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        booking.packageName,
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.sm),
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
                const SizedBox(height: AppDimensions.base),

                // ── Schedule ────────────────────────────────────
                Container(
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
                      Text('Jadwal', style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      )),
                      const SizedBox(height: AppDimensions.xs),
                      _DetailRow(
                        Icons.calendar_today,
                        Formatters.formatDate(booking.date),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      _DetailRow(
                        Icons.access_time,
                        Formatters.formatTimeRange(
                          booking.startTime,
                          booking.endTime,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.base),

                // ── Venue ───────────────────────────────────────
                Container(
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
                      Text('Venue', style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      )),
                      const SizedBox(height: AppDimensions.xs),
                      _DetailRow(
                        Icons.location_on,
                        booking.venueName,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.base),

                // ── Amount ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.base),
                  decoration: BoxDecoration(
                    color: AppSurfaces.surface,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLg),
                    boxShadow: AppShadows.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTypography.titleSmall),
                      Text(
                        Formatters.formatRupiah(booking.amount),
                        style: AppTypography.priceLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),
        ),

        // ── Bottom action buttons ─────────────────────────────
        if (booking.status == BookingStatus.completed ||
            booking.status == BookingStatus.pendingPayment)
          _BottomAction(booking: booking),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final CoachingBooking booking;

  const _BottomAction({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.md,
        AppDimensions.screenHorizontal,
        AppDimensions.screenBottom,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        boxShadow: AppShadows.xs,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeightLg,
        child: booking.status == BookingStatus.completed
            ? FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Penilaian sekarang dilakukan dari detail sesi.',
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  'Buat Penilaian',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              )
            : FilledButton(
                onPressed: () {
                  context.push(AppRoutes.coachBookingPayment);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: Text(
                  'Bayar Sekarang',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconXs, color: AppColors.textSecondary),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(text, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }
}
