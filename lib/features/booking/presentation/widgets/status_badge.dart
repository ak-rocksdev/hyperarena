import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  static String statusLabel(BookingStatus status) => switch (status) {
        BookingStatus.pendingPayment => 'Menunggu Pembayaran',
        BookingStatus.waitingConfirmation => 'Menunggu Konfirmasi',
        BookingStatus.confirmed => 'Terkonfirmasi',
        BookingStatus.completed => 'Selesai',
        BookingStatus.cancelled => 'Dibatalkan',
        BookingStatus.rejected => 'Ditolak',
        BookingStatus.expired => 'Kadaluarsa',
      };

  @override
  Widget build(BuildContext context) {
    final statusTheme =
        Theme.of(context).extension<BookingStatusThemeExtension>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusTheme.backgroundColor(status),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Text(
        statusLabel(status),
        style: AppTypography.badge.copyWith(
          color: statusTheme.textColor(status),
        ),
      ),
    );
  }
}
