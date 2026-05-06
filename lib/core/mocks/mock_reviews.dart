import 'package:hyperarena/features/review/data/models/review.dart';

abstract final class MockReviews {
  static List<Review> get reviews {
    final now = DateTime.now();
    return [
      Review(
        id: 'review-001',
        coachId: 'coach-001',
        sessionId: 'session-today-1',
        rating: 5,
        comment:
            'Coach Andi sangat sabar dan detail dalam menjelaskan teknik. Forehand saya jadi lebih konsisten setelah sesi ini.',
        createdAt: now.subtract(const Duration(days: 1)),
        coachName: 'Andi Prasetyo',
        sessionTitle: 'Latihan Tennis Pagi',
        sessionDate: now.subtract(const Duration(days: 1)),
      ),
      Review(
        id: 'review-002',
        coachId: 'coach-001',
        sessionId: 'session-today-1',
        rating: 4,
        comment:
            'Sesi yang produktif. Coach memberikan drill yang bervariasi. Hanya saja waktu istirahat agak kurang.',
        createdAt: now.subtract(const Duration(days: 1)),
        coachName: 'Andi Prasetyo',
        sessionTitle: 'Latihan Tennis Pagi',
        sessionDate: now.subtract(const Duration(days: 1)),
      ),
      Review(
        id: 'review-003',
        coachId: 'coach-001',
        sessionId: 'session-001',
        rating: 5,
        comment:
            'Seperti biasa, coaching dari Coach Andi selalu berkualitas. Sesi ini fokus di serve dan hasilnya langsung terasa.',
        createdAt: now.subtract(const Duration(days: 7)),
        coachName: 'Andi Prasetyo',
        sessionTitle: 'Latihan Tennis Sore',
        sessionDate: now.subtract(const Duration(days: 7)),
      ),
      Review(
        id: 'review-004',
        coachId: 'coach-001',
        sessionId: 'session-001',
        rating: 4,
        comment:
            'Coach Andi punya metode latihan yang efektif. Cocok untuk yang mau serius belajar tenis.',
        createdAt: now.subtract(const Duration(days: 7)),
        coachName: 'Andi Prasetyo',
        sessionTitle: 'Latihan Tennis Sore',
        sessionDate: now.subtract(const Duration(days: 7)),
      ),
      Review(
        id: 'review-005',
        coachId: 'coach-002',
        sessionId: 'session-today-2',
        rating: 5,
        comment:
            'Coach Maya luar biasa! Teknik netting saya meningkat pesat. Sangat direkomendasikan untuk pemain badminton.',
        createdAt: now.subtract(const Duration(days: 2)),
        coachName: 'Maya Sari',
        sessionTitle: 'Latihan Badminton Siang',
        sessionDate: now.subtract(const Duration(days: 2)),
      ),
      Review(
        id: 'review-006',
        coachId: 'coach-002',
        sessionId: 'session-today-2',
        rating: 3,
        comment:
            'Sesi cukup oke, tapi rasanya kurang personalized. Mungkin karena pesertanya cukup banyak.',
        createdAt: now.subtract(const Duration(days: 2)),
        coachName: 'Maya Sari',
        sessionTitle: 'Latihan Badminton Siang',
        sessionDate: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
