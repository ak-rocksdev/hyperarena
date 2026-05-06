import 'package:hyperarena/features/profile/data/models/activity_item.dart';
import 'package:hyperarena/shared/data/models/cursor_page.dart';

abstract class ActivityRepository {
  Future<CursorPage<ActivityItem>> getActivity({String? cursor, int perPage});
}
