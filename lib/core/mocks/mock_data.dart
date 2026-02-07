import 'dart:math';

import 'package:hyperarena/core/mocks/mock_assessments.dart';
import 'package:hyperarena/core/mocks/mock_badges.dart';
import 'package:hyperarena/core/mocks/mock_bookings.dart';
import 'package:hyperarena/core/mocks/mock_coach_packages.dart';
import 'package:hyperarena/core/mocks/mock_coaches.dart';
import 'package:hyperarena/core/mocks/mock_coaching_bookings.dart';
import 'package:hyperarena/core/mocks/mock_sessions.dart';
import 'package:hyperarena/core/mocks/mock_users.dart';
import 'package:hyperarena/core/mocks/mock_venues.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/booking/data/models/payment_method_info.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';
import 'package:hyperarena/features/coach/data/models/coaching_booking.dart';
import 'package:hyperarena/features/gamification/data/models/badge.dart';
import 'package:hyperarena/features/profile/data/models/player_profile.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

/// Central registry for all mock data.
abstract final class MockData {
  static User get currentUser => MockUsers.currentUser;
  static PlayerProfile get currentProfile => MockUsers.currentProfile;
  static List<Venue> get venues => MockVenues.venues;
  static List<Booking> get bookings => MockBookings.bookings;
  static List<Badge> get badges => MockBadges.badges;
  static List<Coach> get coaches => MockCoaches.coaches;
  static List<OpenSession> get sessions => MockSessions.sessions;
  static List<CoachPackage> get coachPackages => MockCoachPackages.packages;
  static List<Assessment> get assessments => MockAssessments.assessments;
  static List<CoachingBooking> get coachingBookings =>
      MockCoachingBookings.bookings;

  static List<PaymentMethodInfo> paymentMethodsForVenue(String venueId) =>
      MockVenues.paymentMethods[venueId] ?? [];

  /// Generate hourly slots from 07:00–22:00 for a given court and date.
  /// Peak hours: 07:00–09:00, 17:00–21:00 at +50% price.
  /// ~30% randomly marked unavailable.
  static List<CourtSlot> generateSlots(String courtId, DateTime date) {
    final random = Random(date.day * 100 + courtId.hashCode);
    const basePrice = 100000;

    return List.generate(15, (i) {
      final hour = 7 + i;
      final isPeak =
          (hour >= 7 && hour <= 8) || (hour >= 17 && hour <= 20);
      final price = isPeak ? (basePrice * 1.5).toInt() : basePrice;
      final isAvailable = random.nextDouble() > 0.3;

      return CourtSlot(
        id: 'slot-$courtId-${hour.toString().padLeft(2, '0')}',
        courtId: courtId,
        date: DateTime(date.year, date.month, date.day),
        startTime: '${hour.toString().padLeft(2, '0')}:00',
        endTime: '${(hour + 1).toString().padLeft(2, '0')}:00',
        price: price,
        isPeak: isPeak,
        isAvailable: isAvailable,
      );
    });
  }
}
