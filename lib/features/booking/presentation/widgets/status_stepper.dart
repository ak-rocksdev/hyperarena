import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class StatusStepper extends StatelessWidget {
  final BookingStatus status;

  const StatusStepper({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['Dibuat', 'Pembayaran', 'Konfirmasi', 'Selesai'];
    final activeIndex = _activeIndex(status);
    final isError = status == BookingStatus.cancelled ||
        status == BookingStatus.rejected ||
        status == BookingStatus.expired;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.base,
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line
            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < activeIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted
                    ? (isError ? AppColors.error : AppColors.primary)
                    : AppColors.neutral200,
              ),
            );
          }
          // Step circle + label
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < activeIndex;
          final isActive = stepIndex == activeIndex;

          Color circleColor;
          Widget circleChild;

          if (isCompleted) {
            circleColor = isError && stepIndex == activeIndex - 1
                ? AppColors.error
                : AppColors.primary;
            circleChild = const Icon(Icons.check, size: 14, color: Colors.white);
          } else if (isActive) {
            circleColor = isError ? AppColors.error : AppColors.primary;
            circleChild = isError
                ? const Icon(Icons.close, size: 14, color: Colors.white)
                : Text(
                    '${stepIndex + 1}',
                    style: AppTypography.badge.copyWith(color: Colors.white),
                  );
          } else {
            circleColor = AppColors.neutral200;
            circleChild = Text(
              '${stepIndex + 1}',
              style:
                  AppTypography.badge.copyWith(color: AppColors.textTertiary),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: circleChild),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex],
                style: AppTypography.badge.copyWith(
                  color: isActive || isCompleted
                      ? AppColors.textPrimary
                      : AppColors.textTertiary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  int _activeIndex(BookingStatus status) => switch (status) {
        BookingStatus.pendingPayment => 1,
        BookingStatus.waitingConfirmation => 2,
        BookingStatus.confirmed => 3,
        BookingStatus.completed => 4,
        BookingStatus.cancelled => 2,
        BookingStatus.rejected => 2,
        BookingStatus.expired => 1,
      };
}
