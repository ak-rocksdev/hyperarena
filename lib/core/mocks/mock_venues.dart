import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/models/payment_method_info.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

abstract final class MockVenues {
  static final venues = [
    Venue(
      id: 'venue-001',
      ownerId: 'owner-001',
      name: 'GOR Senayan Sports Center',
      description:
          'Pusat olahraga terlengkap di Jakarta Selatan dengan fasilitas premium. Tersedia lapangan tenis, badminton, dan futsal berstandar internasional.',
      address: 'Jl. Asia Afrika, Gelora, Tanah Abang',
      city: 'Jakarta Selatan',
      latitude: -6.2186,
      longitude: 106.8024,
      phone: '+622157853400',
      whatsappNumber: '+6281234560001',
      facilities: ['parking', 'shower', 'canteen', 'wifi', 'locker'],
      photos: [
        'https://picsum.photos/seed/venue1a/800/450',
        'https://picsum.photos/seed/venue1b/800/450',
      ],
      isVerified: true,
      avgRating: 4.5,
      totalReviews: 128,
      courts: [
        const Court(
          id: 'court-001',
          venueId: 'venue-001',
          name: 'Lapangan Tenis 1',
          sportType: Sport.tennis,
          surfaceType: 'hard_court',
          environment: 'outdoor',
        ),
        const Court(
          id: 'court-002',
          venueId: 'venue-001',
          name: 'Lapangan Tenis 2',
          sportType: Sport.tennis,
          surfaceType: 'hard_court',
          environment: 'covered',
        ),
        const Court(
          id: 'court-003',
          venueId: 'venue-001',
          name: 'Lapangan Badminton A',
          sportType: Sport.badminton,
          surfaceType: 'synthetic',
          environment: 'indoor',
        ),
      ],
    ),
    Venue(
      id: 'venue-002',
      ownerId: 'owner-002',
      name: 'Tennis Club Kemang',
      description:
          'Klub tenis eksklusif di Kemang dengan 4 lapangan hard court dan fasilitas lengkap.',
      address: 'Jl. Kemang Raya No. 45, Bangka',
      city: 'Jakarta Selatan',
      latitude: -6.2607,
      longitude: 106.8145,
      phone: '+622171793344',
      whatsappNumber: '+6281234560002',
      facilities: ['parking', 'shower', 'canteen', 'locker'],
      photos: [
        'https://picsum.photos/seed/venue2a/800/450',
        'https://picsum.photos/seed/venue2b/800/450',
      ],
      isVerified: true,
      avgRating: 4.7,
      totalReviews: 85,
      courts: [
        const Court(
          id: 'court-004',
          venueId: 'venue-002',
          name: 'Court A',
          sportType: Sport.tennis,
          surfaceType: 'hard_court',
          environment: 'outdoor',
        ),
        const Court(
          id: 'court-005',
          venueId: 'venue-002',
          name: 'Court B',
          sportType: Sport.tennis,
          surfaceType: 'clay',
          environment: 'outdoor',
        ),
      ],
    ),
    Venue(
      id: 'venue-003',
      ownerId: 'owner-003',
      name: 'Padel House PIK',
      description:
          'Lapangan padel pertama di PIK dengan standar internasional. Nikmati pengalaman bermain padel di fasilitas modern.',
      address: 'Jl. Pantai Indah Utara 2, Kapuk Muara',
      city: 'Jakarta Utara',
      latitude: -6.1086,
      longitude: 106.7448,
      whatsappNumber: '+6281234560003',
      facilities: ['parking', 'shower', 'canteen', 'wifi'],
      photos: [
        'https://picsum.photos/seed/venue3a/800/450',
      ],
      isVerified: true,
      avgRating: 4.3,
      totalReviews: 42,
      courts: [
        const Court(
          id: 'court-006',
          venueId: 'venue-003',
          name: 'Padel Court 1',
          sportType: Sport.padel,
          surfaceType: 'artificial_turf',
          environment: 'covered',
        ),
        const Court(
          id: 'court-007',
          venueId: 'venue-003',
          name: 'Padel Court 2',
          sportType: Sport.padel,
          surfaceType: 'artificial_turf',
          environment: 'indoor',
        ),
      ],
    ),
    Venue(
      id: 'venue-004',
      ownerId: 'owner-004',
      name: 'Lapangan Badminton Sudirman',
      description:
          'GOR badminton dengan 6 lapangan berstandar BWF. Cocok untuk latihan rutin maupun turnamen.',
      address: 'Jl. Jend. Sudirman Kav. 86, Karet Tengsin',
      city: 'Jakarta Pusat',
      latitude: -6.2268,
      longitude: 106.8126,
      phone: '+622125557788',
      whatsappNumber: '+6281234560004',
      facilities: ['parking', 'canteen', 'locker'],
      photos: [
        'https://picsum.photos/seed/venue4a/800/450',
        'https://picsum.photos/seed/venue4b/800/450',
      ],
      isVerified: false,
      avgRating: 4.1,
      totalReviews: 67,
      courts: [
        const Court(
          id: 'court-008',
          venueId: 'venue-004',
          name: 'Lapangan 1',
          sportType: Sport.badminton,
          surfaceType: 'synthetic',
          environment: 'indoor',
        ),
        const Court(
          id: 'court-009',
          venueId: 'venue-004',
          name: 'Lapangan 2',
          sportType: Sport.badminton,
          surfaceType: 'synthetic',
          environment: 'indoor',
        ),
        const Court(
          id: 'court-010',
          venueId: 'venue-004',
          name: 'Lapangan 3',
          sportType: Sport.badminton,
          surfaceType: 'synthetic',
          environment: 'indoor',
        ),
      ],
    ),
    Venue(
      id: 'venue-005',
      ownerId: 'owner-005',
      name: 'Futsal Arena Kelapa Gading',
      description:
          'Arena futsal premium dengan lapangan vinyl berkualitas tinggi. Buka 24 jam untuk booking.',
      address: 'Jl. Boulevard Raya Blok QJ, Kelapa Gading',
      city: 'Jakarta Utara',
      latitude: -6.1579,
      longitude: 106.9055,
      whatsappNumber: '+6281234560005',
      facilities: ['parking', 'canteen', 'wifi'],
      photos: [
        'https://picsum.photos/seed/venue5a/800/450',
      ],
      isVerified: true,
      avgRating: 4.4,
      totalReviews: 203,
      courts: [
        const Court(
          id: 'court-011',
          venueId: 'venue-005',
          name: 'Lapangan A',
          sportType: Sport.futsal,
          surfaceType: 'vinyl',
          environment: 'indoor',
        ),
        const Court(
          id: 'court-012',
          venueId: 'venue-005',
          name: 'Lapangan B',
          sportType: Sport.futsal,
          surfaceType: 'vinyl',
          environment: 'indoor',
        ),
      ],
    ),
  ];

  static final paymentMethods = <String, List<PaymentMethodInfo>>{
    'venue-001': [
      const PaymentMethodInfo(
        id: 'pm-001',
        type: PaymentMethodType.qris,
        qrisImageUrl: 'https://picsum.photos/seed/qris1/300/300',
      ),
      const PaymentMethodInfo(
        id: 'pm-002',
        type: PaymentMethodType.bankTransfer,
        bankName: 'BCA',
        accountNumber: '1234567890',
        accountHolderName: 'PT Senayan Sports',
      ),
    ],
    'venue-002': [
      const PaymentMethodInfo(
        id: 'pm-003',
        type: PaymentMethodType.qris,
        qrisImageUrl: 'https://picsum.photos/seed/qris2/300/300',
      ),
      const PaymentMethodInfo(
        id: 'pm-004',
        type: PaymentMethodType.bankTransfer,
        bankName: 'BCA',
        accountNumber: '0987654321',
        accountHolderName: 'Tennis Club Kemang',
      ),
    ],
    'venue-003': [
      const PaymentMethodInfo(
        id: 'pm-005',
        type: PaymentMethodType.qris,
        qrisImageUrl: 'https://picsum.photos/seed/qris3/300/300',
      ),
      const PaymentMethodInfo(
        id: 'pm-006',
        type: PaymentMethodType.bankTransfer,
        bankName: 'BCA',
        accountNumber: '1122334455',
        accountHolderName: 'PT Padel House Indonesia',
      ),
    ],
    'venue-004': [
      const PaymentMethodInfo(
        id: 'pm-007',
        type: PaymentMethodType.qris,
        qrisImageUrl: 'https://picsum.photos/seed/qris4/300/300',
      ),
      const PaymentMethodInfo(
        id: 'pm-008',
        type: PaymentMethodType.bankTransfer,
        bankName: 'BCA',
        accountNumber: '5566778899',
        accountHolderName: 'GOR Sudirman',
      ),
    ],
    'venue-005': [
      const PaymentMethodInfo(
        id: 'pm-009',
        type: PaymentMethodType.qris,
        qrisImageUrl: 'https://picsum.photos/seed/qris5/300/300',
      ),
      const PaymentMethodInfo(
        id: 'pm-010',
        type: PaymentMethodType.bankTransfer,
        bankName: 'BCA',
        accountNumber: '6677889900',
        accountHolderName: 'Futsal Arena KG',
      ),
    ],
  };
}
