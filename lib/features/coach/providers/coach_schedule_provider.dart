import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final coachScheduleProvider =
    FutureProvider<List<CoachingBooking>>((ref) async {
  final repo = ref.read(coachRepositoryProvider);
  return repo.getCoachBookings(coachId: 'coach-001');
});
