import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/session_repository.dart';

class MockSessionRepository implements SessionRepository {
  final AppConfig config;

  MockSessionRepository(this.config);

  @override
  Future<List<OpenSession>> getSessions({Sport? sport}) async {
    await Future.delayed(config.mockDelay);
    var sessions = MockData.sessions;
    if (sport != null) {
      sessions = sessions.where((s) => s.sport == sport).toList();
    }
    return sessions;
  }

  @override
  Future<OpenSession> getSession(String id) async {
    await Future.delayed(config.mockDelay);
    return MockData.sessions.firstWhere((s) => s.id == id);
  }
}
