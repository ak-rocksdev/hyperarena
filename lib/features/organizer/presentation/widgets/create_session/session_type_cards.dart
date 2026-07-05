import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Presentation labels/icons for [SessionType] (kept out of the pure enum in
/// app_enums so that file stays material-free).
extension SessionTypeUi on SessionType {
  String get label => switch (this) {
        SessionType.trial => 'Trial',
        SessionType.group => 'Group',
        SessionType.private => 'Privat',
      };

  String get description => switch (this) {
        SessionType.trial => 'Uji coba',
        SessionType.group => 'Beregu',
        SessionType.private => '1-on-1',
      };

  IconData get icon => switch (this) {
        SessionType.trial => Icons.flag_outlined,
        SessionType.group => Icons.groups_outlined,
        SessionType.private => Icons.person_outline,
      };
}

/// Three selectable cards for the session type. Selecting `private` is handled
/// by the caller (it clears capacity).
class SessionTypeCards extends StatelessWidget {
  const SessionTypeCards({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final SessionType value;
  final ValueChanged<SessionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final t in SessionType.values) ...[
          Expanded(child: _Card(type: t, selected: t == value, onTap: () => onChanged(t))),
          if (t != SessionType.values.last)
            const SizedBox(width: AppDimensions.sm),
        ],
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.type, required this.selected, required this.onTap});

  final SessionType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.base,
              horizontal: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary50 : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.neutral200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.neutral100,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Icon(
                    type.icon,
                    size: 22,
                    color: selected ? Colors.white : AppColors.neutral500,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  type.label,
                  style: AppTypography.titleSmall.copyWith(
                    color:
                        selected ? AppColors.primary900 : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  type.description,
                  style: AppTypography.caption.copyWith(
                    color: selected ? AppColors.primary : AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: AppDimensions.sm,
              right: AppDimensions.sm,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
