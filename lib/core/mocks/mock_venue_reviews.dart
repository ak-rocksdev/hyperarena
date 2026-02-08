import 'package:hyperarena/features/review/data/models/venue_review.dart';

abstract final class MockVenueReviews {
  static List<VenueReview> get reviews => [
    VenueReview(
      id: 'vr-001',
      reviewerId: 'user-002',
      reviewerName: 'Andi Pratama',
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
      bookingId: 'booking-007',
      courtName: 'Lapangan Tenis 1',
      date: DateTime.now().subtract(const Duration(days: 5)),
      rating: 5,
      comment:
          'Lapangan tenis terbaik di Jakarta! Permukaan rata, pencahayaan bagus, dan loker bersih. Pasti balik lagi.',
    ),
    VenueReview(
      id: 'vr-002',
      reviewerId: 'user-003',
      reviewerName: 'Siti Rahmawati',
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
      bookingId: 'booking-008',
      courtName: 'Lapangan Badminton A',
      date: DateTime.now().subtract(const Duration(days: 10)),
      rating: 4,
      comment:
          'Fasilitas lengkap, parkir luas. Sayangnya AC di ruang ganti agak kurang dingin.',
    ),
    VenueReview(
      id: 'vr-003',
      reviewerId: 'user-004',
      reviewerName: 'Riko Hendarto',
      venueId: 'venue-001',
      venueName: 'GOR Senayan Sports Center',
      bookingId: 'booking-009',
      courtName: 'Lapangan Tenis 2',
      date: DateTime.now().subtract(const Duration(days: 15)),
      rating: 4,
      comment:
          'Bagus secara keseluruhan. Staff ramah dan helpful. Harga cukup reasonable untuk kualitasnya.',
    ),
    VenueReview(
      id: 'vr-004',
      reviewerId: 'user-002',
      reviewerName: 'Andi Pratama',
      venueId: 'venue-002',
      venueName: 'Tennis Club Kemang',
      bookingId: 'booking-010',
      courtName: 'Court A',
      date: DateTime.now().subtract(const Duration(days: 3)),
      rating: 5,
      comment:
          'Premium banget! Court-nya terawat, ada ball machine juga. Worth the price.',
    ),
    VenueReview(
      id: 'vr-005',
      reviewerId: 'user-005',
      reviewerName: 'Dewi Kusuma',
      venueId: 'venue-002',
      venueName: 'Tennis Club Kemang',
      bookingId: 'booking-011',
      courtName: 'Court B',
      date: DateTime.now().subtract(const Duration(days: 8)),
      rating: 4,
      comment:
          'Suasana nyaman, cafe-nya enak. Lapangan bersih. Cuma parkirnya agak sempit.',
    ),
    VenueReview(
      id: 'vr-006',
      reviewerId: 'user-003',
      reviewerName: 'Siti Rahmawati',
      venueId: 'venue-004',
      venueName: 'Lapangan Badminton Sudirman',
      bookingId: 'booking-012',
      courtName: 'Lapangan 1',
      date: DateTime.now().subtract(const Duration(days: 4)),
      rating: 3,
      comment:
          'Lapangannya oke, tapi toilet perlu diperbaiki. Harga murah sih.',
    ),
    VenueReview(
      id: 'vr-007',
      reviewerId: 'user-006',
      reviewerName: 'Fajar Nugroho',
      venueId: 'venue-004',
      venueName: 'Lapangan Badminton Sudirman',
      bookingId: 'booking-013',
      courtName: 'Lapangan 2',
      date: DateTime.now().subtract(const Duration(days: 12)),
      rating: 4,
      comment:
          'Lokasi strategis, dekat MRT. Lantai lapangan bagus, shuttle cock bisa beli di tempat.',
    ),
    VenueReview(
      id: 'vr-008',
      reviewerId: 'user-004',
      reviewerName: 'Riko Hendarto',
      venueId: 'venue-005',
      venueName: 'Futsal Arena Kelapa Gading',
      bookingId: 'booking-014',
      courtName: 'Lapangan A',
      date: DateTime.now().subtract(const Duration(days: 2)),
      rating: 4,
      comment:
          'Rumput sintetisnya bagus, tidak licin. Ada tribun kecil buat nonton. Recommended!',
    ),
    VenueReview(
      id: 'vr-009',
      reviewerId: 'user-005',
      reviewerName: 'Dewi Kusuma',
      venueId: 'venue-005',
      venueName: 'Futsal Arena Kelapa Gading',
      bookingId: 'booking-015',
      courtName: 'Lapangan B',
      date: DateTime.now().subtract(const Duration(days: 7)),
      rating: 5,
      comment:
          'Top! Fasilitas lengkap, ada musholla dan kantin. Booking online-nya juga gampang.',
    ),
  ];
}
