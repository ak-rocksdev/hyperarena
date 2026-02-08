import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';

abstract final class MockCoachPackages {
  static final packages = [
    const CoachPackage(
      id: 'pkg-001',
      coachId: 'coach-001',
      name: 'Kelas Privat Tennis',
      description:
          'Latihan privat tenis 1-on-1 dengan fokus pada teknik dasar dan rally.',
      sport: Sport.tennis,
      sessions: 4,
      pricePerSession: 550000,
      durationMinutes: 60,
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
    ),
    const CoachPackage(
      id: 'pkg-002',
      coachId: 'coach-001',
      name: 'Intensif Tennis',
      description:
          'Program intensif 8 sesi untuk meningkatkan serve, volley, dan strategi permainan.',
      sport: Sport.tennis,
      sessions: 8,
      pricePerSession: 500000,
      durationMinutes: 90,
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
    ),
    const CoachPackage(
      id: 'pkg-003',
      coachId: 'coach-002',
      name: 'Dasar Badminton',
      description:
          'Pelajari teknik dasar badminton: grip, footwork, dan smash.',
      sport: Sport.badminton,
      sessions: 4,
      pricePerSession: 420000,
      durationMinutes: 60,
      venueId: 'venue-004',
      venueName: 'Lapangan Badminton Sudirman',
    ),
    const CoachPackage(
      id: 'pkg-004',
      coachId: 'coach-002',
      name: 'Kompetisi Badminton',
      description:
          'Program persiapan kompetisi dengan fokus taktik dan mental game.',
      sport: Sport.badminton,
      sessions: 12,
      pricePerSession: 380000,
      durationMinutes: 90,
      venueId: 'venue-004',
      venueName: 'Lapangan Badminton Sudirman',
    ),
    const CoachPackage(
      id: 'pkg-005',
      coachId: 'coach-003',
      name: 'Intro Padel',
      description:
          'Mengenal padel dari nol: posisi, pukulan dasar, dan aturan permainan.',
      sport: Sport.padel,
      sessions: 4,
      pricePerSession: 350000,
      durationMinutes: 60,
      venueId: 'venue-003',
      venueName: 'Padel House PIK',
    ),
    const CoachPackage(
      id: 'pkg-006',
      coachId: 'coach-003',
      name: 'Padel Advance',
      description:
          'Tingkatkan permainan padel: bandeja, vibora, dan strategi doubles.',
      sport: Sport.padel,
      sessions: 8,
      pricePerSession: 320000,
      durationMinutes: 60,
      venueId: 'venue-003',
      venueName: 'Padel House PIK',
    ),
    const CoachPackage(
      id: 'pkg-007',
      coachId: 'coach-004',
      name: 'Tennis Junior',
      description:
          'Program tenis untuk anak usia 8-15 tahun dengan pendekatan fun learning.',
      sport: Sport.tennis,
      sessions: 8,
      pricePerSession: 450000,
      durationMinutes: 60,
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
    ),
    const CoachPackage(
      id: 'pkg-008',
      coachId: 'coach-004',
      name: 'Badminton Dewasa',
      description:
          'Kelas badminton untuk dewasa pemula yang ingin belajar dari dasar.',
      sport: Sport.badminton,
      sessions: 4,
      pricePerSession: 400000,
      durationMinutes: 90,
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
    ),
    const CoachPackage(
      id: 'pkg-009',
      coachId: 'coach-005',
      name: 'Futsal Fundamental',
      description:
          'Kuasai dasar futsal: passing, dribbling, shooting, dan posisi bermain.',
      sport: Sport.futsal,
      sessions: 4,
      pricePerSession: 400000,
      durationMinutes: 90,
      venueId: 'venue-005',
      venueName: 'Futsal Arena Kelapa Gading',
    ),
    const CoachPackage(
      id: 'pkg-010',
      coachId: 'coach-005',
      name: 'Futsal Taktik',
      description:
          'Strategi dan taktik futsal: formasi, pressing, dan transisi cepat.',
      sport: Sport.futsal,
      sessions: 8,
      pricePerSession: 370000,
      durationMinutes: 120,
      venueId: 'venue-005',
      venueName: 'Futsal Arena Kelapa Gading',
    ),
  ];
}
