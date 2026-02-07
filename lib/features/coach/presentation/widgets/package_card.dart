import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';

class PackageCard extends StatelessWidget {
  final CoachPackage package;
  final VoidCallback? onSelect;

  const PackageCard({super.key, required this.package, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sportColor = sportTheme.color(package.sport);

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Sport-colored accent bar
            Container(width: 4, color: sportColor),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Package name
                    Text(
                      package.name,
                      style: AppTypography.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    // Description
                    Text(
                      package.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Pills row: sessions + duration
                    Row(
                      children: [
                        _InfoPill(
                          icon: Icons.repeat,
                          label: '${package.sessions} sesi',
                          color: sportColor,
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        _InfoPill(
                          icon: Icons.timer_outlined,
                          label: '${package.durationMinutes} min',
                          color: sportColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.md),
                    // Price + button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.formatRupiah(package.pricePerSession),
                              style: AppTypography.priceLarge,
                            ),
                            Text('/sesi', style: AppTypography.caption),
                          ],
                        ),
                        FilledButton(
                          onPressed: onSelect,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSm,
                              ),
                            ),
                          ),
                          child: const Text('Pilih Paket'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
