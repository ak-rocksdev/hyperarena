import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Subtle inline caption shown on marketplace cards (Sesi, Coach, Lapangan)
/// when the item's tenant differs from the authenticated user's tenant.
///
/// Intentionally low-contrast: the marketplace remains cross-tenant, this
/// only signals provenance so users recognise their own school's items first.
class OtherTenantCaption extends StatelessWidget {
  final String? tenantName;

  const OtherTenantCaption({super.key, this.tenantName});

  @override
  Widget build(BuildContext context) {
    final label = tenantName != null && tenantName!.isNotEmpty
        ? 'Sekolah lain · $tenantName'
        : 'Sekolah lain';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_outlined,
            size: AppDimensions.iconXs,
            color: AppColors.neutral500,
          ),
          const SizedBox(width: AppDimensions.xxs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}
