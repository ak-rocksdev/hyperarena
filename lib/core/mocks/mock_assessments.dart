import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';

abstract final class MockAssessments {
  static List<Assessment> get assessments {
    final now = DateTime.now();
    return [
      Assessment(
        id: 'assess-001',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        studentId: 'user-001',
        studentName: 'Budi Santoso',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 7)),
        technique: 7,
        stamina: 6,
        tactics: 5,
        mentality: 8,
        consistency: 6,
        notes:
            'Forehand sudah cukup baik. Perlu perbaikan backhand dan footwork.',
        recommendedLevel: LevelTier.amateur,
        sessionId: 'session-001',
        sessionTitle: 'Latihan Tennis Sore',
        whatToImprove:
            'Backhand masih sering ke net. Coba perbaiki posisi kaki saat memukul backhand.',
        playingStyleNotes:
            'Pemain baseline dengan forehand dominan. Perlu variasi approach shot.',
        strengthHighlight: 'Forehand cross-court konsisten dan dalam.',
      ),
      Assessment(
        id: 'assess-002',
        coachId: 'coach-002',
        coachName: 'Maya Sari',
        studentId: 'user-001',
        studentName: 'Budi Santoso',
        sport: Sport.badminton,
        date: now.subtract(const Duration(days: 14)),
        technique: 5,
        stamina: 7,
        tactics: 4,
        mentality: 7,
        consistency: 5,
        notes:
            'Stamina baik tapi teknik smash perlu dilatih lebih sering.',
        recommendedLevel: LevelTier.rookie,
        sessionId: 'session-002',
        sessionTitle: 'Badminton Pemula',
        whatToImprove:
            'Teknik smash masih kurang power. Fokus di rotasi pergelangan tangan.',
        playingStyleNotes:
            'Pemain defensif yang mengandalkan stamina. Perlu lebih agresif di depan net.',
        strengthHighlight: 'Footwork dan stamina sangat baik untuk level pemula.',
      ),
      Assessment(
        id: 'assess-003',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        studentId: 'user-002',
        studentName: 'Siti Rahayu',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 3)),
        technique: 8,
        stamina: 7,
        tactics: 7,
        mentality: 8,
        consistency: 8,
        notes:
            'Pemain yang sangat konsisten. Siap untuk turnamen amateur.',
        recommendedLevel: LevelTier.intermediate,
      ),
      Assessment(
        id: 'assess-004',
        coachId: 'coach-005',
        coachName: 'Fajar Nugroho',
        studentId: 'user-003',
        studentName: 'Dika Pratama',
        sport: Sport.futsal,
        date: now.subtract(const Duration(days: 5)),
        technique: 6,
        stamina: 8,
        tactics: 5,
        mentality: 6,
        consistency: 7,
        notes:
            'Fisik kuat, perlu latihan kontrol bola dan passing akurasi.',
        recommendedLevel: LevelTier.amateur,
      ),
      Assessment(
        id: 'assess-005',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        studentId: 'user-001',
        studentName: 'Budi Santoso',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 1)),
        technique: 8,
        stamina: 7,
        tactics: 6,
        mentality: 8,
        consistency: 7,
        notes: 'Peningkatan signifikan dari sesi sebelumnya.',
        recommendedLevel: LevelTier.amateur,
        sessionId: 'session-today-1',
        sessionTitle: 'Latihan Tennis Pagi',
        whatToImprove:
            'Backhand slice masih sering ke net. Coba lebih rileks di pergelangan tangan saat slice.',
        playingStyleNotes:
            'Pemain baseline yang agresif. Forehand dominan, perlu variasi di net approach.',
        strengthHighlight: 'Forehand cross-court sangat konsisten dan dalam.',
      ),
      Assessment(
        id: 'assess-006',
        coachId: 'coach-002',
        coachName: 'Maya Sari',
        studentId: 'user-002',
        studentName: 'Siti Rahayu',
        sport: Sport.badminton,
        date: now.subtract(const Duration(days: 2)),
        technique: 7,
        stamina: 6,
        tactics: 6,
        mentality: 7,
        consistency: 7,
        notes: 'Perkembangan cepat di teknik netting.',
        recommendedLevel: LevelTier.amateur,
        sessionId: 'session-today-2',
        sessionTitle: 'Latihan Badminton Siang',
        whatToImprove:
            'Perlu latihan smash dari belakang court. Timing masih sering telat.',
        playingStyleNotes:
            'Pemain all-round yang mulai menunjukkan dominasi di net play.',
        strengthHighlight: 'Netting dan drop shot sangat akurat.',
      ),
    ];
  }
}
