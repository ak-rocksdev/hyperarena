import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// A consistent tap-target row for the pickers (coach, venue, date, time):
/// a tinted icon square, a stacked label + value, and a trailing affordance.
/// A filled tile firms its border to brand teal so a set value reads as done.
class PickerTile extends StatelessWidget {
  const PickerTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder = 'Pilih',
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final Widget? trailing;

  bool get _filled => value != null && value!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: _filled ? AppColors.primary50.withValues(alpha: 0.4) : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: _filled ? AppColors.primary200 : AppColors.neutral200,
            width: _filled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _IconSquare(icon: icon),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    _filled ? value! : placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMedium.copyWith(
                      color: _filled
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                      fontWeight: _filled ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  const _IconSquare({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Icon(icon, color: AppColors.primary, size: 20),
    );
  }
}
