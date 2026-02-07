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
    ];
  }
}
