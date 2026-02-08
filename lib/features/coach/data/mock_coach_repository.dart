import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';

class MockCoachRepository implements CoachRepository {
  final AppConfig config;

  // Mock current user constants
  static const _currentCoachId = 'coach-001';
  static const _currentPlayerId = 'user-001';
  static const _currentPlayerName = 'Budi Santoso';

  MockCoachRepository(this.config);

  @override
  Future<List<Coach>> getCoaches({Sport? sport}) async {
    await Future.delayed(config.mockDelay);
    var coaches = MockData.coaches;
    if (sport != null) {
      coaches = coaches.where((c) => c.sports.contains(sport)).toList();
    }
    return coaches;
  }

  @override
  Future<Coach> getCoach(String id) async {
    await Future.delayed(config.mockDelay);
    return MockData.coaches.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<CoachPackage>> getCoachPackages(String coachId) async {
    await Future.delayed(config.mockDelay);
    return MockData.coachPackages
        .where((p) => p.coachId == coachId)
        .toList();
  }

  @override
  Future<List<CoachingBooking>> getCoachBookings({
    String? coachId,
    String? playerId,
  }) async {
    await Future.delayed(config.mockDelay);
    var bookings = MockData.coachingBookings;
    if (coachId != null) {
      bookings = bookings.where((b) => b.coachId == coachId).toList();
    }
    if (playerId != null) {
      bookings = bookings.where((b) => b.playerId == playerId).toList();
    }
    return bookings;
  }

  @override
  Future<CoachingBooking> createCoachingBooking({
    required String coachId,
    required String packageId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String venueName,
  }) async {
    await Future.delayed(config.mockDelay);
    final coach = MockData.coaches.firstWhere((c) => c.id == coachId);
    final package = MockData.coachPackages.firstWhere((p) => p.id == packageId);
    return CoachingBooking(
      id: 'cb-${DateTime.now().millisecondsSinceEpoch}',
      coachId: coachId,
      coachName: coach.name,
      playerId: _currentPlayerId,
      playerName: _currentPlayerName,
      packageId: packageId,
      packageName: package.name,
      sport: package.sport,
      date: date,
      startTime: startTime,
      endTime: endTime,
      venueName: venueName,
      amount: package.pricePerSession,
      status: BookingStatus.pendingPayment,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<Assessment>> getAssessments({
    String? coachId,
    String? studentId,
  }) async {
    await Future.delayed(config.mockDelay);
    var assessments = MockData.assessments;
    if (coachId != null) {
      assessments =
          assessments.where((a) => a.coachId == coachId).toList();
    }
    if (studentId != null) {
      assessments =
          assessments.where((a) => a.studentId == studentId).toList();
    }
    return assessments;
  }

  @override
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
  }) async {
    await Future.delayed(config.mockDelay);
    final coach =
        MockData.coaches.firstWhere((c) => c.id == _currentCoachId);
    return Assessment(
      id: 'assess-${DateTime.now().millisecondsSinceEpoch}',
      coachId: _currentCoachId,
      coachName: coach.name,
      studentId: studentId,
      studentName: studentName,
      sport: sport,
      date: DateTime.now(),
      technique: technique,
      stamina: stamina,
      tactics: tactics,
      mentality: mentality,
      consistency: consistency,
      notes: notes,
      recommendedLevel: recommendedLevel,
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      whatToImprove: whatToImprove,
      playingStyleNotes: playingStyleNotes,
      strengthHighlight: strengthHighlight,
    );
  }

  @override
  Future<List<String>> getStudentNames(String coachId) async {
    await Future.delayed(config.mockDelay);
    final bookings = MockData.coachingBookings
        .where((b) => b.coachId == coachId)
        .toList();
    final names = bookings.map((b) => b.playerName).toSet().toList();
    return names;
  }
}
