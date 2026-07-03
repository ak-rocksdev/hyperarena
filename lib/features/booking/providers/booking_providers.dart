import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/booking/data/booking_repository.dart';
import 'package:hyperarena/features/booking/data/mock_booking_repository.dart';
import 'package:hyperarena/features/booking/data/models/booking.dart';
import 'package:hyperarena/features/booking/data/models/booking_summary.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/court_slot.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';
// ── DI ──────────────────────────────────────────────────────────

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return MockBookingRepository();
});

// ── Booking Flow ────────────────────────────────────────────────

final bookingFlowProvider =
    NotifierProvider<BookingFlowNotifier, BookingSummary>(
        BookingFlowNotifier.new);

class BookingFlowNotifier extends Notifier<BookingSummary> {
  @override
  BookingSummary build() => BookingSummary.empty();

  void selectCourt(Court court, Venue venue) {
    state = state.copyWith(court: court, venue: venue);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(date: date, slots: []);
  }

  void selectSlots(List<CourtSlot> slots) {
    final total = slots.fold<int>(0, (sum, s) => sum + s.price);
    state = state.copyWith(slots: slots, totalAmount: total);
  }

  void selectPaymentMethod(PaymentMethodType method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<Booking> submit() async {
    final repo = ref.read(bookingRepositoryProvider);
    final s = state;
    final slots = [...s.slots]..sort((a, b) => a.startTime.compareTo(b.startTime));
    final booking = await repo.createBooking(
      courtId: s.court!.id,
      venueId: s.venue!.id,
      date: s.date!,
      startTime: slots.first.startTime,
      endTime: slots.last.endTime,
      totalAmount: s.totalAmount,
      paymentMethod: s.paymentMethod!,
      venueName: s.venue!.name,
      courtName: s.court!.name,
    );
    // Carry the created booking's real payment deadline into the flow so the
    // payment screen counts down to the actual expiry.
    state = state.copyWith(expiresAt: booking.expiresAt);
    // Invalidate booking list so it refreshes
    ref.invalidate(bookingListProvider);
    return booking;
  }

  void reset() => state = BookingSummary.empty();
}

// ── Booking List ────────────────────────────────────────────────

final bookingListProvider = FutureProvider<List<Booking>>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getBookings();
});

// ── Booking Detail ──────────────────────────────────────────────

final bookingDetailProvider =
    FutureProvider.family<Booking, String>((ref, id) {
  final repo = ref.watch(bookingRepositoryProvider);
  return repo.getBooking(id);
});
