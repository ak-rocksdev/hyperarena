import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/payment/data/models/payment_method.dart';
import 'package:hyperarena/features/payment/data/models/purchase_card_summary.dart';
import 'package:hyperarena/features/payment/data/models/purchase_full_detail.dart';
import 'package:hyperarena/features/payment/data/models/purchase_status.dart';
import 'package:hyperarena/features/payment/data/repositories/payment_repository.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

/// Singleton repository.
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PaymentRepository(apiClient);
});

/// Fetches available payment methods for a given tenant slug.
final availablePaymentMethodsProvider =
    FutureProvider.autoDispose.family<List<PaymentMethod>, String>((ref, tenantSlug) async {
  return ref.watch(paymentRepositoryProvider).getAvailableMethods(tenantSlug);
});

/// Lists all purchases for the current user, optionally filtered by [status].
/// Pass null or 'all' to show everything.
final myPurchasesProvider = FutureProvider.autoDispose
    .family<List<PurchaseCardSummary>, String?>((ref, status) async {
  return ref.watch(paymentRepositoryProvider).getMyPurchases(status: status);
});

/// Full detail + rebook_eligibility for a single purchase [id].
final purchaseDetailProvider = FutureProvider.autoDispose
    .family<PurchaseDetailResponse, int>((ref, id) async {
  return ref.watch(paymentRepositoryProvider).getPurchaseDetail(id);
});

/// Purchase statuses that end the payment lifecycle — consumers of the
/// status stream must key off this set, never off "not pending".
const kTerminalPurchaseStatuses = {
  'confirmed',
  'expired',
  'cancelled',
  'rejected',
};

/// Polls purchase status every 3 seconds until terminal status (confirmed, expired,
/// cancelled, rejected). Closes the stream once terminal so the screen stops polling.
/// Auto-disposes when no longer listened to (e.g. user leaves the screen).
final purchaseStatusStreamProvider = StreamProvider.autoDispose
    .family<PurchaseStatus, int>((ref, purchaseId) async* {
  final repo = ref.watch(paymentRepositoryProvider);

  while (true) {
    try {
      final status = await repo.getStatus(purchaseId);
      yield status;
      if (kTerminalPurchaseStatuses.contains(status.status)) {
        return;
      }
    } catch (_) {
      // Transient error (network blip) — keep polling.
      // The stream's error state is not surfaced; only successful status updates flow.
    }
    await Future<void>.delayed(const Duration(seconds: 3));
  }
});
