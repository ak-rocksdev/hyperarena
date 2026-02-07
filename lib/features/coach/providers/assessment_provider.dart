import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final assessmentListProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getAssessments(coachId: 'coach-001');
});
