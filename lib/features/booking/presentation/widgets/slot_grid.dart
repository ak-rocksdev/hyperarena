import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';

class SlotGrid extends StatelessWidget {
  final List<CourtSlot> slots;
  final Set<String> selectedSlotIds;
  final ValueChanged<CourtSlot> onSlotToggle;

  const SlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlotIds,
    required this.onSlotToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: AppDimensions.sm,
        mainAxisSpacing: AppDimensions.sm,
      ),
      itemCount: slots.length,
      itemBuilder: (_, i) {
        final slot = slots[i];
        final isSelected = selectedSlotIds.contains(slot.id);
        final isAvailable = slot.isAvailable;

        Color bgColor;
        Color textColor;
        if (!isAvailable) {
          bgColor = AppColors.neutral100;
          textColor = AppColors.textDisabled;
        } else if (isSelected) {
          bgColor = AppColors.primary50;
          textColor = AppColors.primary;
        } else {
          bgColor = AppSurfaces.surface;
          textColor = AppColors.textPrimary;
        }

        return GestureDetector(
          onTap: isAvailable ? () => onSlotToggle(slot) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: !isAvailable
                  ? null
                  : isSelected
                      ? AppShadows.sm
                      : AppShadows.xs,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Formatters.formatTimeRange(slot.startTime, slot.endTime),
                  style: AppTypography.labelMedium.copyWith(color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatRupiah(slot.price),
                  style: AppTypography.priceSmall.copyWith(
                    color: isAvailable ? null : AppColors.textDisabled,
                  ),
                ),
                if (slot.isPeak)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent50,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXs),
                    ),
                    child: Text(
                      'Peak',
                      style: AppTypography.badge.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
