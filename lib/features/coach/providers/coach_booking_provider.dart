import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';
import 'package:hyperarena/features/coach/data/models/coach_package.dart';

class CoachBookingState {
  final Coach? coach;
  final CoachPackage? package;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? venueName;
  final PaymentMethodType paymentMethod;

  const CoachBookingState({
    this.coach,
    this.package,
    this.date,
    this.startTime,
    this.endTime,
    this.venueName,
    this.paymentMethod = PaymentMethodType.qris,
  });

  bool get isComplete =>
      coach != null &&
      package != null &&
      date != null &&
      startTime != null &&
      endTime != null &&
      venueName != null &&
      venueName!.isNotEmpty;

  int get totalAmount => package?.pricePerSession ?? 0;
}

class CoachBookingNotifier extends Notifier<CoachBookingState> {
  @override
  CoachBookingState build() => const CoachBookingState();

  void setCoach(Coach coach) {
    state = CoachBookingState(coach: coach);
  }

  void selectPackage(CoachPackage pkg) {
    state = CoachBookingState(
      coach: state.coach,
      package: pkg,
      venueName: pkg.venueName,
    );
  }

  void selectDate(DateTime date) {
    state = CoachBookingState(
      coach: state.coach,
      package: state.package,
      date: date,
      startTime: state.startTime,
      endTime: state.endTime,
      venueName: state.venueName,
      paymentMethod: state.paymentMethod,
    );
  }

  void selectTime(String start, String end) {
    state = CoachBookingState(
      coach: state.coach,
      package: state.package,
      date: state.date,
      startTime: start,
      endTime: end,
      venueName: state.venueName,
      paymentMethod: state.paymentMethod,
    );
  }

  void setVenueName(String venue) {
    state = CoachBookingState(
      coach: state.coach,
      package: state.package,
      date: state.date,
      startTime: state.startTime,
      endTime: state.endTime,
      venueName: venue,
      paymentMethod: state.paymentMethod,
    );
  }

  void selectPaymentMethod(PaymentMethodType method) {
    state = CoachBookingState(
      coach: state.coach,
      package: state.package,
      date: state.date,
      startTime: state.startTime,
      endTime: state.endTime,
      venueName: state.venueName,
      paymentMethod: method,
    );
  }

  void reset() {
    state = const CoachBookingState();
  }
}

final coachBookingProvider =
    NotifierProvider<CoachBookingNotifier, CoachBookingState>(
  CoachBookingNotifier.new,
);
