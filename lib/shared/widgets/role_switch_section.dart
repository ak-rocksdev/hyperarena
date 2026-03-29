import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// A section that shows role-switching buttons when the user has multiple roles.
///
/// Only renders when [user.availableRoles] contains more than one distinct
/// [UserRole]. Each button navigates to the corresponding role's home screen.
class RoleSwitchSection extends ConsumerWidget {
  const RoleSwitchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    if (user == null) return const SizedBox.shrink();

    // Map backend role names to UserRole, deduplicate
    final mappedRoles = user.availableRoles
        .map(mapBackendRole)
        .toSet()
        .toList();

    // Only show when there are multiple distinct roles
    if (mappedRoles.length <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ganti Peran', style: AppTypography.titleMedium),
          const SizedBox(height: AppDimensions.md),
          Container(
            decoration: BoxDecoration(
              color: AppSurfaces.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              children: [
                for (var i = 0; i < mappedRoles.length; i++) ...[
                  _RoleTile(
                    role: mappedRoles[i],
                    isActive: mappedRoles[i] == user.role,
                    onTap: () => _onRoleTap(context, ref, user, mappedRoles[i]),
                  ),
                  if (i < mappedRoles.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  void _onRoleTap(
    BuildContext context,
    WidgetRef ref,
    User user,
    UserRole newRole,
  ) {
    if (newRole == user.role) return;
    ref.read(authNotifierProvider.notifier).switchRole(newRole);
    context.go(AppRoutes.home(newRole));
  }
}

class _RoleTile extends StatelessWidget {
  final UserRole role;
  final bool isActive;
  final VoidCallback onTap;

  const _RoleTile({
    required this.role,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.neutral100,
                ),
                child: Icon(
                  _roleIcon(role),
                  size: 20,
                  color: isActive ? AppColors.primary : AppColors.neutral500,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  _roleLabel(role),
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    'Aktif',
                    style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _roleIcon(UserRole role) => switch (role) {
        UserRole.player => Icons.sports_tennis,
        UserRole.coach => Icons.school,
        UserRole.organizer => Icons.shield_outlined,
        UserRole.courtOwner => Icons.store_outlined,
      };

  static String _roleLabel(UserRole role) => switch (role) {
        UserRole.player => 'Pemain',
        UserRole.coach => 'Coach',
        UserRole.organizer => 'Organizer',
        UserRole.courtOwner => 'Pemilik Venue',
      };
}
