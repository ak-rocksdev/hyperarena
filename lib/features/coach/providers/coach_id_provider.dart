import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The active coach's ID for dashboard queries.
///
/// Transitional: returns the mock literal `'coach-001'` so the existing
/// mock repository keeps filtering correctly. When `coachRepositoryProvider`
/// switches from mock to API (see plan Scope Clarification #1), update this
/// provider to read `authNotifierProvider`'s `user.id`.
final coachIdProvider = Provider<String>((ref) {
  return 'coach-001';
});
