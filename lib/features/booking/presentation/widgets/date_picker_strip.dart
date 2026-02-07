import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';

class DatePickerStrip extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(
      14,
      (i) => DateTime(today.year, today.month, today.day + i),
    );

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal,
        ),
        itemCount: dates.length,
        itemBuilder: (_, i) {
          final date = dates[i];
          final isSelected = selectedDate != null &&
              date.year == selectedDate!.year &&
              date.month == selectedDate!.month &&
              date.day == selectedDate!.day;

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: GestureDetector(
              onTap: () => onDateSelected(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppSurfaces.surface,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  boxShadow: isSelected
                      ? AppShadows.sm
                      : AppShadows.xs,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Formatters.formatDayShort(date),
                      style: AppTypography.caption.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
