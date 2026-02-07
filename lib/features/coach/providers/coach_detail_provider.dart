import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final coachDetailProvider =
    FutureProvider.family<Coach, String>((ref, coachId) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoach(coachId);
});

final coachPackagesProvider =
    FutureProvider.family<List<CoachPackage>, String>((ref, coachId) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoachPackages(coachId);
});
