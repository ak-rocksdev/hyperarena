import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Section header used across the organizer dashboard.
///
/// Layout: `[Title]  [count?]  [subtitle?]  ………………  [link?]`
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
    this.linkLabel,
    this.onLinkTap,
  });

  final String title;
  final String? subtitle;
  final int? count;
  final String? linkLabel;
  final VoidCallback? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              '$count',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(width: AppDimensions.sm),
          Flexible(
            child: Text(
              subtitle!,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        const Spacer(),
        if (linkLabel != null)
          InkWell(
            onTap: onLinkTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xs,
                vertical: 2,
              ),
              child: Text(
                linkLabel!,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
