import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/features/profile/data/activity_repository.dart';
import 'package:hyperarena/features/profile/data/api_activity_repository.dart';
import 'package:hyperarena/features/profile/data/models/activity_item.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiActivityRepository(apiClient);
});

/// Recent activity for the authenticated user (first page only).
/// Profile screen renders the top 3; full list lives in a future paginated screen.
final activityListProvider = FutureProvider<List<ActivityItem>>((ref) async {
  final repo = ref.watch(activityRepositoryProvider);
  final page = await repo.getActivity(perPage: 20);
  return page.items;
});
