import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final assessmentListProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);
  return repo.getAssessments(coachId: coachId);
});
