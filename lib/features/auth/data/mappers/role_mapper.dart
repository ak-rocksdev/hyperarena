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
