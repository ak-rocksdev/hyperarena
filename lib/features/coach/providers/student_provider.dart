import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final studentListProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getStudentNames('coach-001');
});

final studentAssessmentsProvider =
    FutureProvider.family<List<Assessment>, String>(
        (ref, studentName) async {
  final repo = ref.read(coachRepositoryProvider);
  final all = await repo.getAssessments(coachId: 'coach-001');
  return all.where((a) => a.studentName == studentName).toList();
});
