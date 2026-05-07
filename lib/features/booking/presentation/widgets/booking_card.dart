import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/booking/presentation/widgets/status_badge.dart';
import 'package:hyperarena/routing/app_routes.dart';

class BookingCard extends ConsumerWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;
    final currency = ref.watch(tenantCurrencyProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: statusTheme.textColor(booking.status),
              width: 4,
            ),
          ),
        ),
        child: InkWell(
        onTap: () => context.push(AppRoutes.booking(booking.id)),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.venueName ?? 'Venue',
                      style: AppTypography.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: booking.status),
                ],
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                booking.courtName ?? 'Court',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    Formatters.formatDate(booking.bookingDate),
                    style: AppTypography.caption,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Icon(Icons.access_time, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    Formatters.formatTimeRange(
                        booking.startTime, booking.endTime),
                    style: AppTypography.caption,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                Formatters.formatCurrency(booking.totalAmount, currency),
                style: AppTypography.priceSmall,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
