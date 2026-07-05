import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// A grouped block of the create-session form: white card, an uppercase
/// eyebrow (the app's dashboard idiom), optional helper line and a trailing
/// affordance, then its controls. Gives the form real hierarchy instead of a
/// flat run of bordered inputs.
class FormSectionCard extends StatelessWidget {
  const FormSectionCard({
    super.key,
    required this.eyebrow,
    required this.child,
    this.helper,
    this.trailing,
    this.optional = false,
  });

  final String eyebrow;
  final Widget child;
  final String? helper;
  final Widget? trailing;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.base,
        AppDimensions.base,
        AppDimensions.base,
        AppDimensions.base,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: AppColors.neutral100),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                eyebrow,
                style: AppTypography.overline.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              if (optional) ...[
                const SizedBox(width: 6),
                Text(
                  'opsional',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.neutral300,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
              const Spacer(),
              ?trailing,
            ],
          ),
          if (helper != null) ...[
            const SizedBox(height: 3),
            Text(
              helper!,
              style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
            ),
          ],
          const SizedBox(height: AppDimensions.md),
          child,
        ],
      ),
    );
  }
}
