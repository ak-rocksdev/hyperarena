import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/coach_repository.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';

class MockCoachRepository implements CoachRepository {
  final AppConfig config;

  MockCoachRepository(this.config);

  @override
  Future<List<Coach>> getCoaches({Sport? sport}) async {
    await Future.delayed(config.mockDelay);
    var coaches = MockData.coaches;
    if (sport != null) {
      coaches = coaches.where((c) => c.sports.contains(sport)).toList();
    }
    return coaches;
  }

  @override
  Future<Coach> getCoach(String id) async {
    await Future.delayed(config.mockDelay);
    return MockData.coaches.firstWhere((c) => c.id == id);
  }
}
