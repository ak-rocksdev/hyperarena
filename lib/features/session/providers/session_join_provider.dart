import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

class SessionJoinState {
  final OpenSession? session;
  final int? selectedSlotIndex;
  final PaymentMethodType paymentMethod;

  const SessionJoinState({
    this.session,
    this.selectedSlotIndex,
    this.paymentMethod = PaymentMethodType.qris,
  });

  bool get hasSelectedSlot => selectedSlotIndex != null;
  bool get isFull =>
      session != null && session!.currentPlayers >= session!.maxPlayers;
  int get emptySlots =>
      session != null ? session!.maxPlayers - session!.currentPlayers : 0;
}

class SessionJoinNotifier extends Notifier<SessionJoinState> {
  @override
  SessionJoinState build() => const SessionJoinState();

  void setSession(OpenSession session) {
    state = SessionJoinState(session: session);
  }

  void selectSlot(int index) {
    state = SessionJoinState(
      session: state.session,
      selectedSlotIndex: index,
      paymentMethod: state.paymentMethod,
    );
  }

  void selectPaymentMethod(PaymentMethodType method) {
    state = SessionJoinState(
      session: state.session,
      selectedSlotIndex: state.selectedSlotIndex,
      paymentMethod: method,
    );
  }

  void reset() {
    state = const SessionJoinState();
  }
}

final sessionJoinProvider =
    NotifierProvider<SessionJoinNotifier, SessionJoinState>(
        SessionJoinNotifier.new);
