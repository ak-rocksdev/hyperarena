import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

final coachScheduleProvider =
    FutureProvider<List<CoachingBooking>>((ref) async {
  final repo = ref.watch(coachRepositoryProvider);
  final coachId = ref.watch(coachIdProvider);
  return repo.getCoachBookings(coachId: coachId);
});
