import 'dart:math';

import 'package:hyperarena/core/mocks/mock_assessments.dart';
import 'package:hyperarena/core/mocks/mock_badges.dart';
import 'package:hyperarena/core/mocks/mock_bookings.dart';
import 'package:hyperarena/core/mocks/mock_coach_packages.dart';
import 'package:hyperarena/core/mocks/mock_coaches.dart';
import 'package:hyperarena/core/mocks/mock_coaching_bookings.dart';
import 'package:hyperarena/core/mocks/mock_organizer_data.dart';
import 'package:hyperarena/core/mocks/mock_owner_data.dart';
import 'package:hyperarena/core/mocks/mock_notifications.dart';
import 'package:hyperarena/core/mocks/mock_reviews.dart';
import 'package:hyperarena/core/mocks/mock_venue_reviews.dart';
import 'package:hyperarena/core/mocks/mock_sessions.dart';
import 'package:hyperarena/core/mocks/mock_session_participants.dart';
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
import 'package:hyperarena/features/notification/data/models/notification_item.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/data/models/venue_review.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';
import 'package:hyperarena/features/profile/data/models/player_profile.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

/// Central registry for all mock data.
abstract final class MockData {
  static final List<Booking> _bookingStore = List.from(MockBookings.bookings);
  static final List<OpenSession> _sessionStore = List.from(
    MockSessions.sessions,
  );
  static final List<SessionParticipant> _sessionParticipantStore = List.from(
    MockSessionParticipants.participants,
  );
  static final List<Venue> _venueStore = List.from(MockVenues.venues);
  static final List<CourtAvailabilityIssue> _ownerIssueStore = List.from(
    MockOwnerData.issues,
  );
  static final List<Review> _reviewStore = List.from(MockReviews.reviews);
  static final List<VenueReview> _venueReviewStore = List.from(MockVenueReviews.reviews);
  static final List<NotificationItem> _notificationStore = List.from(
    MockNotifications.notifications,
  );

  static User get currentUser => MockUsers.currentUser;
  static User get organizerUser => MockUsers.organizerUser;
  static User get ownerUser => MockUsers.ownerUser;
  static PlayerProfile get currentProfile => MockUsers.currentProfile;
  static List<Venue> get venues => _venueStore;
  static List<Booking> get bookings => _bookingStore;
  static List<Badge> get badges => MockBadges.badges;
  static List<Coach> get coaches => MockCoaches.coaches;
  static List<OpenSession> get sessions => _sessionStore;
  static List<SessionParticipant> get sessionParticipants =>
      _sessionParticipantStore;
  static List<CoachPackage> get coachPackages => MockCoachPackages.packages;
  static List<Assessment> get assessments => MockAssessments.assessments;
  static List<CoachingBooking> get coachingBookings =>
      MockCoachingBookings.bookings;
  static ClubProfile get clubProfile => MockOrganizerData.clubProfile;
  static List<ClubMember> get clubMembers => MockOrganizerData.clubMembers;
  static Map<String, String> get organizerSessionTemplates =>
      MockOrganizerData.sessionTemplates;
  static List<CourtAvailabilityIssue> get ownerIssues => _ownerIssueStore;
  static List<Review> get reviews => _reviewStore;
  static List<VenueReview> get venueReviews => _venueReviewStore;
  static List<NotificationItem> get notifications => _notificationStore;

  static void upsertBooking(Booking booking) {
    final index = _bookingStore.indexWhere((b) => b.id == booking.id);
    if (index == -1) {
      _bookingStore.insert(0, booking);
      return;
    }
    _bookingStore[index] = booking;
  }

  static void upsertSession(OpenSession session) {
    final index = _sessionStore.indexWhere((s) => s.id == session.id);
    if (index == -1) {
      _sessionStore.insert(0, session);
      return;
    }
    _sessionStore[index] = session;
  }

  static void upsertParticipant(SessionParticipant participant) {
    final index = _sessionParticipantStore.indexWhere(
      (p) => p.id == participant.id,
    );
    if (index == -1) {
      _sessionParticipantStore.insert(0, participant);
      return;
    }
    _sessionParticipantStore[index] = participant;
  }

  static void upsertVenue(Venue venue) {
    final index = _venueStore.indexWhere((v) => v.id == venue.id);
    if (index == -1) {
      _venueStore.insert(0, venue);
      return;
    }
    _venueStore[index] = venue;
  }

  static void addReview(Review review) {
    _reviewStore.insert(0, review);
  }

  static void addVenueReview(VenueReview review) {
    _venueReviewStore.insert(0, review);
  }

  static void markNotificationRead(String id) {
    final index = _notificationStore.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notificationStore[index] = _notificationStore[index].copyWith(
        isRead: true,
      );
    }
  }

  static void markAllNotificationsRead() {
    for (var i = 0; i < _notificationStore.length; i++) {
      if (!_notificationStore[i].isRead) {
        _notificationStore[i] = _notificationStore[i].copyWith(isRead: true);
      }
    }
  }

  static void upsertOwnerIssue(CourtAvailabilityIssue issue) {
    final index = _ownerIssueStore.indexWhere((i) => i.id == issue.id);
    if (index == -1) {
      _ownerIssueStore.insert(0, issue);
      return;
    }
    _ownerIssueStore[index] = issue;
  }

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
      final isPeak = (hour >= 7 && hour <= 8) || (hour >= 17 && hour <= 20);
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
