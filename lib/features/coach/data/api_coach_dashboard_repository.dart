import 'package:dio/dio.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/club/data/models/coach_student.dart';
import 'package:hyperarena/features/coach/data/models/coach_action_counts.dart';
import 'package:hyperarena/features/coach/data/models/coach_performance.dart';

/// Backs the dashboard's aggregate summary. Each method maps to one
/// SectionResult slot in CoachDashboardSummary. When a BE summary endpoint
/// does not yet exist, the implementation derives the value from existing
/// list endpoints.
class ApiCoachDashboardRepository {
  ApiCoachDashboardRepository(this._dio);
  // ignore: unused_field
  final Dio _dio;

  Future<CoachPerformance> getPerformance({required String coachId}) async {
    throw UnimplementedError('Phase 8: getPerformance');
  }

  Future<CoachActionCounts> getActionCounts({required String coachId}) async {
    throw UnimplementedError('Phase 5: getActionCounts');
  }

  Future<List<CoachStudentRosterItem>> getAttentionList({required String coachId}) async {
    throw UnimplementedError('Phase 6: getAttentionList');
  }

  Future<Map<Sport, int>> getSportBreakdown({required String coachId}) async {
    throw UnimplementedError('Phase 7: getSportBreakdown');
  }
}
