import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Minimum time the in-tile spinner stays visible. Without this floor, a
/// fast (~50ms) API response causes the spinner to flicker for one frame
/// — feels like a glitch rather than a deliberate transition.
const _kMinLoadingDisplay = Duration(milliseconds: 200);

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

    final switchingTo = ref.watch(isSwitchingRoleProvider);

    final mappedRoles = user.availableRoles
        .map(mapBackendRole)
        .toSet()
        .toList();

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
                    activeRole: user.role,
                    switchingTo: switchingTo,
                    onTap: () =>
                        _onRoleTap(context, ref, user, mappedRoles[i]),
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

  Future<void> _onRoleTap(
    BuildContext context,
    WidgetRef ref,
    User user,
    UserRole newRole,
  ) async {
    AppHaptics.tap();

    if (newRole == user.role) return;
    // Already switching — haptic above is enough; don't fire a second call.
    if (ref.read(isSwitchingRoleProvider) != null) return;

    // Capture the controller UP-FRONT. `switchRole` mutates global auth
    // state, which fires the router's auth redirect and tears down THIS
    // widget's element mid-await. Any `ref.*` after that throws
    // "Cannot use ref after the widget was disposed", which would leave
    // `isSwitchingRole` stuck non-null → frozen spinner + every later
    // switch blocked by the guard above. The controller is app-scoped
    // (non-autoDispose), so it stays valid after the widget is gone.
    final switching = ref.read(isSwitchingRoleProvider.notifier);
    final router = ref.read(authNotifierProvider.notifier);
    switching.state = newRole;

    final stopwatch = Stopwatch()..start();
    try {
      await router.switchRole(newRole);
      // Floor the loading display so the spinner doesn't flicker.
      final elapsed = stopwatch.elapsed;
      if (elapsed < _kMinLoadingDisplay) {
        await Future.delayed(_kMinLoadingDisplay - elapsed);
      }
      // Reset via the captured controller — the widget may already be
      // disposed by the router redirect, so `ref` is unsafe here.
      switching.state = null;
      // If the widget survived (router didn't redirect), navigate
      // explicitly; otherwise the redirect already landed us on the new
      // role's home.
      if (context.mounted) {
        context.go(AppRoutes.home(newRole));
      }
    } catch (e) {
      switching.state = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal beralih peran: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _RoleTile extends StatelessWidget {
  final UserRole role;
  final UserRole activeRole;
  final UserRole? switchingTo;
  final VoidCallback onTap;

  const _RoleTile({
    required this.role,
    required this.activeRole,
    required this.switchingTo,
    required this.onTap,
  });

  bool get _isActive => role == activeRole;
  bool get _isLoading => switchingTo == role;
  bool get _isOtherDimmed => switchingTo != null && switchingTo != role;

  @override
  Widget build(BuildContext context) {
    // Tile being switched TO previews the active styling so the transition
    // into the new role's home screen feels continuous (the tile reads
    // "becoming active" rather than "loading something opaque").
    final showActiveStyling = _isActive || _isLoading;

    return Opacity(
      opacity: _isOtherDimmed ? 0.4 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          // Suppress onTap on dimmed tiles AND on the loading tile itself
          // so a re-tap doesn't fire a duplicate API call.
          onTap: switchingTo != null ? null : onTap,
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
                    color: showActiveStyling
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.neutral100,
                  ),
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : Icon(
                          _roleIcon(role),
                          size: 20,
                          color: showActiveStyling
                              ? AppColors.primary
                              : AppColors.neutral500,
                        ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(
                    _roleLabel(role),
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: showActiveStyling
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: showActiveStyling
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (_isLoading)
                  _StatusPill(label: 'Beralih…')
                else if (_isActive)
                  _StatusPill(label: 'Aktif'),
              ],
            ),
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

class _StatusPill extends StatelessWidget {
  final String label;
  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
