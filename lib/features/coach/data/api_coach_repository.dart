import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/api_coach_session_repository.dart';
import 'package:hyperarena/features/coach/data/api_marketplace_coach_repository.dart';
import 'package:hyperarena/features/coach/data/coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/data/models/coach_session.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/coach/data/models/marketplace_coach.dart';

/// Adapter implementing the legacy [CoachRepository] interface on top of the
/// real API repositories. Several abstract methods are LOSSY because the BE
/// does not expose all the fields the abstract requires:
///
/// - `getCoaches` / `getCoach`: backed by [ApiMarketplaceCoachRepository].
///   Missing fields (rating, totalReviews, certifications, etc.) default to
///   reasonable zero/empty values. UI screens that depend on these fields
///   degrade gracefully (no crashes, just empty/zero values).
/// - `getCoachPackages`: synthesizes a single "Sesi Coaching" package from
///   the coach's `ratePerSession` until a dedicated BE endpoint exists.
/// - `getCoachBookings`: maps [CoachSession] (group class sessions) onto
///   the [CoachingBooking] shape with lossy field substitution. Used by the
///   coach dashboard's Today Schedule.
/// - `createCoachingBooking` / `createAssessment`: throw UnimplementedError
///   because no BE endpoint exists. No UI calls them today.
/// - `getAssessments`: returns an empty list (BE endpoint pending). The
///   Recent Assessments dashboard section renders its EmptyState.
/// - `getStudentNames`: derived from session participation.
class ApiCoachRepository implements CoachRepository {
  ApiCoachRepository(this._marketplace, this._sessions);
  final ApiMarketplaceCoachRepository _marketplace;
  final ApiCoachSessionRepository _sessions;

  @override
  Future<List<Coach>> getCoaches({Sport? sport}) async {
    final page = await _marketplace.getCoaches(
      sportId: sport != null ? _sportToId(sport) : null,
    );
    return page.items.map(_marketplaceToCoach).toList();
  }

  @override
  Future<Coach> getCoach(String id) async {
    // Marketplace list-and-find. Inefficient but the marketplace endpoint
    // does not yet expose a coach-detail route. Acceptable for the small
    // coach roster per tenant.
    final page = await _marketplace.getCoaches();
    final match = page.items.firstWhere(
      (m) => m.id == id,
      orElse: () => throw StateError('Coach $id not found in marketplace'),
    );
    return _marketplaceToCoach(match);
  }

  @override
  Future<List<CoachPackage>> getCoachPackages(String coachId) async {
    // Synthesize one package from the coach's ratePerSession. BE has no
    // dedicated packages endpoint — replace with a real fetch when it ships.
    final coach = await getCoach(coachId);
    return [
      CoachPackage(
        id: 'session-default-$coachId',
        coachId: coachId,
        name: 'Sesi Coaching',
        description: 'Satu sesi coaching dengan ${coach.name}',
        sport: coach.sports.isNotEmpty ? coach.sports.first : Sport.tennis,
        sessions: 1,
        pricePerSession: coach.hourlyRate,
        durationMinutes: 60,
      ),
    ];
  }

  @override
  Future<List<CoachingBooking>> getCoachBookings({
    String? coachId,
    String? playerId,
  }) async {
    final page = await _sessions.getSessions();
    return page.items
        .map((s) => _sessionToBooking(s, coachId: coachId))
        .toList();
  }

  @override
  Future<CoachingBooking> createCoachingBooking({
    required String coachId,
    required String packageId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String venueName,
  }) {
    throw UnimplementedError(
      'createCoachingBooking has no BE endpoint yet — only club session '
      'scheduling exists today.',
    );
  }

  @override
  Future<List<Assessment>> getAssessments({
    String? coachId,
    String? studentId,
  }) async {
    // No BE endpoint yet. Returning an empty list lets the dashboard's
    // Recent Assessments section render its EmptyState gracefully.
    return const [];
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
  }) {
    throw UnimplementedError(
      'createAssessment has no BE endpoint yet.',
    );
  }

  @override
  Future<List<String>> getStudentNames(String coachId) async {
    final page = await _sessions.getSessions();
    final names = <String>{};
    for (final s in page.items) {
      for (final st in s.sessionStudents) {
        final name = _studentFullName(st);
        if (name.isNotEmpty) names.add(name);
      }
    }
    return names.toList();
  }

  // ── Mappers ────────────────────────────────────────────────────────────

  Coach _marketplaceToCoach(MarketplaceCoach m) {
    final user = m.user;
    final sport = m.sport;
    return Coach(
      id: m.id,
      name: user?.name ?? 'Coach',
      bio: m.bio ?? '',
      avatarUrl: user?.photoUrls?['md'] ?? user?.photoUrls?['sm'],
      sports: sport != null ? [_parseSport(sport.name)] : const [],
      hourlyRate: m.ratePerSession ?? 0,
      city: '', // marketplace API does not return city today
    );
  }

  CoachingBooking _sessionToBooking(CoachSession s, {String? coachId}) {
    final firstStudent =
        s.sessionStudents.isNotEmpty ? s.sessionStudents.first : null;
    final firstCoach = s.coaches.isNotEmpty ? s.coaches.first : null;
    return CoachingBooking(
      id: s.id,
      coachId: firstCoach?.id ?? coachId ?? '',
      coachName: firstCoach?.user?.name ?? '',
      playerId: firstStudent != null
          ? (firstStudent.studentProfile?.id ?? firstStudent.studentProfileId)
          : '',
      playerName: firstStudent != null
          ? _studentFullName(firstStudent)
          : '(Tidak ada peserta)',
      packageId: '',
      packageName: '',
      sport: _parseSport(s.type),
      date: s.startAt,
      startTime: _formatHm(s.startAt),
      endTime: _formatHm(s.startAt.add(Duration(minutes: s.durationMinutes))),
      venueName: s.venue?.name ?? '',
      amount: 0,
      status: _parseBookingStatus(s.status),
      createdAt: s.startAt,
    );
  }

  Sport _parseSport(String? raw) {
    if (raw == null) return Sport.tennis;
    final lower = raw.toLowerCase();
    for (final sp in Sport.values) {
      if (sp.name.toLowerCase() == lower) return sp;
    }
    return Sport.tennis;
  }

  BookingStatus _parseBookingStatus(String? raw) {
    if (raw == null) return BookingStatus.pendingPayment;
    switch (raw.toLowerCase()) {
      case 'completed':
      case 'complete':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      case 'confirmed':
      case 'ongoing':
      case 'scheduled':
        return BookingStatus.confirmed;
      default:
        return BookingStatus.pendingPayment;
    }
  }

  String _formatHm(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  int? _sportToId(Sport sport) {
    // Marketplace endpoint uses numeric sport IDs. The mapping is
    // tenant-defined — for now, omit the filter (null = no filter) which is
    // a reasonable fallback. When the BE-FE sport-ID mapping is documented,
    // replace this with the real lookup.
    return null;
  }

  String _studentFullName(CoachSessionStudent sessionStudent) {
    final profile = sessionStudent.studentProfile;
    if (profile == null) return '';
    final fn = profile.firstName ?? '';
    final ln = profile.lastName ?? '';
    return '$fn $ln'.trim();
  }
}
