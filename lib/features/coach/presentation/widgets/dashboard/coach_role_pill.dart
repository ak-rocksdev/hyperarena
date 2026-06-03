import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class CoachRolePill extends ConsumerWidget {
  const CoachRolePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final hasMultipleRoles = (user?.availableRoles.length ?? 0) > 1;

    final pill = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.coachAccent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          const Icon(Icons.sports, color: Colors.white, size: 14),
          const SizedBox(width: AppDimensions.xxs),
          Text(
            'MODE COACH',
            style: AppTypography.badge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (hasMultipleRoles) ...[
            const SizedBox(width: AppDimensions.xxs),
            const Icon(Icons.chevron_right, color: Colors.white, size: 14),
          ],
        ],
      ),
    );

    if (!hasMultipleRoles) return pill;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.go(AppRoutes.profile(UserRole.coach)),
      child: pill,
    );
  }
}
