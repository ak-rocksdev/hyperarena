import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';

abstract class CoachRepository {
  Future<List<Coach>> getCoaches({Sport? sport});
  Future<Coach> getCoach(String id);
  Future<List<CoachPackage>> getCoachPackages(String coachId);
  Future<List<CoachingBooking>> getCoachBookings({
    String? coachId,
    String? playerId,
  });
  Future<CoachingBooking> createCoachingBooking({
    required String coachId,
    required String packageId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String venueName,
  });
  Future<List<Assessment>> getAssessments({
    String? coachId,
    String? studentId,
  });
  Future<Assessment> createAssessment({
    required String studentId,
    required String studentName,
    required Sport sport,
    required int technique,
    required int stamina,
    required int tactics,
    required int mentality,
    required int consistency,
    String? notes,
    required LevelTier recommendedLevel,
    String? sessionId,
    String? sessionTitle,
    String? whatToImprove,
    String? playingStyleNotes,
    String? strengthHighlight,
  });
  Future<List<String>> getStudentNames(String coachId);
}
