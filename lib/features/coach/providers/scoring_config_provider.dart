import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/coach/data/api_scoring_config_repository.dart';
import 'package:hyperarena/features/coach/data/models/scoring_config.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final scoringConfigRepoProvider = Provider<ApiScoringConfigRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiScoringConfigRepository(apiClient);
});

/// Tenant-level scoring config. Loaded once per session and cached.
final scoringConfigProvider = FutureProvider<ScoringConfig>((ref) async {
  final repo = ref.watch(scoringConfigRepoProvider);
  return repo.getConfig();
});
