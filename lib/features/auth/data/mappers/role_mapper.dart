// lib/features/auth/data/mappers/role_mapper.dart
import 'package:hyperarena/core/theme/app_enums.dart';

/// Maps the backend `active_role` string to the Flutter [UserRole] enum.
///
/// The backend has no `tenant.type` column, so mapping is based
/// solely on the role string.
UserRole mapBackendRole(String? activeRole) {
  return switch (activeRole) {
    'member' => UserRole.player,
    'coach' => UserRole.coach,
    'admin' => UserRole.organizer,
    'super-admin' => UserRole.organizer,
    _ => UserRole.player,
  };
}

/// Maps Flutter UserRole enum → backend role string.
/// Note: organizer maps to 'admin' (not 'super-admin') since the switch
/// endpoint validates against the user's actual Spatie roles.
String userRoleToBackend(UserRole role) => switch (role) {
  UserRole.player => 'member',
  UserRole.coach => 'coach',
  UserRole.organizer => 'admin',
  UserRole.courtOwner => 'court-owner', // future — not used yet
};

/// Find the original backend role string for a UserRole from the user's
/// availableRoles. This handles the super-admin ↔ organizer ambiguity:
/// both 'admin' and 'super-admin' map to UserRole.organizer, so when
/// switching back, we need the user's actual Spatie role string.
///
/// Falls back to [userRoleToBackend] if no match found in availableRoles.
String resolveBackendRole(UserRole role, List<String> availableRoles) {
  // For roles without ambiguity, direct mapping works
  if (role != UserRole.organizer) return userRoleToBackend(role);

  // For organizer: prefer super-admin if available, then admin
  if (availableRoles.contains('super-admin')) return 'super-admin';
  if (availableRoles.contains('admin')) return 'admin';
  return 'admin'; // fallback
}
