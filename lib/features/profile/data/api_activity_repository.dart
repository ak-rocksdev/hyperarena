import 'package:hyperarena/core/network/api_client.dart';
import 'package:hyperarena/features/profile/data/activity_repository.dart';
import 'package:hyperarena/features/profile/data/models/activity_item.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

class ApiActivityRepository implements ActivityRepository {
  final ApiClient _apiClient;

  ApiActivityRepository(this._apiClient);

  @override
  Future<CursorPage<ActivityItem>> getActivity({
    String? cursor,
    int perPage = 20,
  }) async {
    final res = await _apiClient.get('/v1/me/activity', queryParameters: {
      'per_page': perPage,
      'cursor': ?cursor,
    });
    return CursorPage.fromJson<ActivityItem>(
      res.data as Map<String, dynamic>,
      ActivityItem.fromJson,
    );
  }
}
