import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/review/data/models/review.dart';

abstract final class MockReviews {
  static List<Review> get reviews {
    final now = DateTime.now();
    return [
      // 2 reviews for coach-001 on session-today-1
      Review(
        id: 'review-001',
        reviewerId: 'user-001',
        reviewerName: 'Budi Santoso',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        sessionId: 'session-today-1',
        sessionTitle: 'Latihan Tennis Pagi',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 1)),
        rating: 5,
        comment:
            'Coach Andi sangat sabar dan detail dalam menjelaskan teknik. Forehand saya jadi lebih konsisten setelah sesi ini.',
      ),
      Review(
        id: 'review-002',
        reviewerId: 'user-002',
        reviewerName: 'Siti Rahayu',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        sessionId: 'session-today-1',
        sessionTitle: 'Latihan Tennis Pagi',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 1)),
        rating: 4,
        comment:
            'Sesi yang produktif. Coach memberikan drill yang bervariasi. Hanya saja waktu istirahat agak kurang.',
      ),
      // 2 reviews for coach-001 on a different session
      Review(
        id: 'review-003',
        reviewerId: 'user-001',
        reviewerName: 'Budi Santoso',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        sessionId: 'session-001',
        sessionTitle: 'Latihan Tennis Sore',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 7)),
        rating: 5,
        comment:
            'Seperti biasa, coaching dari Coach Andi selalu berkualitas. Sesi ini fokus di serve dan hasilnya langsung terasa.',
      ),
      Review(
        id: 'review-004',
        reviewerId: 'user-003',
        reviewerName: 'Dika Pratama',
        coachId: 'coach-001',
        coachName: 'Andi Prasetyo',
        sessionId: 'session-001',
        sessionTitle: 'Latihan Tennis Sore',
        sport: Sport.tennis,
        date: now.subtract(const Duration(days: 7)),
        rating: 4,
        comment:
            'Coach Andi punya metode latihan yang efektif. Cocok untuk yang mau serius belajar tenis.',
      ),
      // 2 reviews for coach-002 on session-today-2
      Review(
        id: 'review-005',
        reviewerId: 'user-002',
        reviewerName: 'Siti Rahayu',
        coachId: 'coach-002',
        coachName: 'Maya Sari',
        sessionId: 'session-today-2',
        sessionTitle: 'Latihan Badminton Siang',
        sport: Sport.badminton,
        date: now.subtract(const Duration(days: 2)),
        rating: 5,
        comment:
            'Coach Maya luar biasa! Teknik netting saya meningkat pesat. Sangat direkomendasikan untuk pemain badminton.',
      ),
      Review(
        id: 'review-006',
        reviewerId: 'user-001',
        reviewerName: 'Budi Santoso',
        coachId: 'coach-002',
        coachName: 'Maya Sari',
        sessionId: 'session-today-2',
        sessionTitle: 'Latihan Badminton Siang',
        sport: Sport.badminton,
        date: now.subtract(const Duration(days: 2)),
        rating: 3,
        comment:
            'Sesi cukup oke, tapi rasanya kurang personalized. Mungkin karena pesertanya cukup banyak.',
      ),
    ];
  }
}
