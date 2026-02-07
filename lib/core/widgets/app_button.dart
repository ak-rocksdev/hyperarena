import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

enum AppButtonVariant { elevated, outlined, text, tonal }

/// Standardized button component.
/// Reference: DESIGN_SYSTEM.md Section 6.4
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isLarge;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.elevated,
    this.isLoading = false,
    this.isLarge = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final height =
        isLarge ? AppDimensions.buttonHeightLg : AppDimensions.buttonHeightMd;

    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: AppDimensions.iconSm),
                  const SizedBox(width: AppDimensions.sm),
                  Text(label),
                ],
              )
            : Text(label);

    final effectiveOnPressed = isLoading ? null : onPressed;

    return SizedBox(
      height: height,
      child: switch (variant) {
        AppButtonVariant.elevated => ElevatedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.outlined => OutlinedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.text => TextButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        AppButtonVariant.tonal => FilledButton.tonal(
            onPressed: effectiveOnPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary50,
              foregroundColor: AppColors.primary700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            child: child,
          ),
      },
    );
  }
}
