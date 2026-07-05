import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Capacity picker for trial/group sessions. `null` = unlimited; a value =
/// limited max spots (1–100). Hidden entirely by the caller for private.
class CapacitySelector extends StatelessWidget {
  const CapacitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.defaultLimit = 10,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final int defaultLimit;

  bool get _limited => value != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _Option(
                title: 'Tak terbatas',
                subtitle: 'Tanpa batas peserta',
                selected: !_limited,
                onTap: () => onChanged(null),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: _Option(
                title: 'Batasi',
                subtitle: 'Tetapkan maks',
                selected: _limited,
                onTap: () => onChanged(value ?? defaultLimit),
              ),
            ),
          ],
        ),
        if (_limited) ...[
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Text('Maks peserta',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              _StepButton(
                icon: Icons.remove,
                onTap: value! > 1 ? () => onChanged(value! - 1) : null,
              ),
              SizedBox(
                width: 44,
                child: Text('${value!}',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              _StepButton(
                icon: Icons.add,
                onTap: value! < 100 ? () => onChanged(value! + 1) : null,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: AppTypography.titleSmall.copyWith(
                  color: selected ? AppColors.primary900 : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            Text(subtitle,
                style: AppTypography.caption.copyWith(
                  color: selected ? AppColors.primary : AppColors.textTertiary,
                )),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: enabled ? AppColors.neutral300 : AppColors.neutral200),
        ),
        child: Icon(icon,
            size: 18,
            color: enabled ? AppColors.textPrimary : AppColors.neutral300),
      ),
    );
  }
}
