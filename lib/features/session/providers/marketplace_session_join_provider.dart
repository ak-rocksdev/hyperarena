import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/session/data/models/session_join_response.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class MarketplaceSessionJoinState {
  final bool isLoading;
  final SessionJoinResponse? response;
  final String? error;

  const MarketplaceSessionJoinState({
    this.isLoading = false,
    this.response,
    this.error,
  });
}

class MarketplaceSessionJoinNotifier
    extends Notifier<MarketplaceSessionJoinState> {
  @override
  MarketplaceSessionJoinState build() => const MarketplaceSessionJoinState();

  Future<SessionJoinResponse?> join(int sessionId) async {
    state = const MarketplaceSessionJoinState(isLoading: true);
    try {
      final repo = ref.read(marketplaceSessionRepoProvider);
      final response = await repo.joinSession(sessionId);
      state = MarketplaceSessionJoinState(response: response);
      return response;
    } catch (e) {
      state = MarketplaceSessionJoinState(error: e.toString());
      return null;
    }
  }

  Future<bool> uploadProof(int purchaseId, String filePath) async {
    try {
      final repo = ref.read(marketplaceSessionRepoProvider);
      await repo.uploadPaymentProof(purchaseId, filePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  void reset() => state = const MarketplaceSessionJoinState();
}

final marketplaceSessionJoinProvider = NotifierProvider<
    MarketplaceSessionJoinNotifier,
    MarketplaceSessionJoinState>(MarketplaceSessionJoinNotifier.new);
