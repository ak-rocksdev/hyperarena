import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';

/// The active coach's ID, derived from the authenticated user.
///
/// Throws `StateError` if the user is not currently in a coach role.
/// This is intentional — the dashboard is behind a role guard so reaching
/// this provider without a coach user indicates a routing bug.
final coachIdProvider = Provider<String>((ref) {
  final user = ref.watch(authNotifierProvider);
  if (user == null) {
    throw StateError('coachIdProvider read with no authenticated user');
  }
  final isCoach = user.role == UserRole.coach ||
      user.activeRole?.toLowerCase() == 'coach';
  if (!isCoach) {
    throw StateError(
        'coachIdProvider read while active role is not coach (role=${user.role}, active=${user.activeRole})');
  }
  return user.id;
});
