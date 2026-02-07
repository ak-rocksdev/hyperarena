import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';

abstract class SessionRepository {
  Future<List<OpenSession>> getSessions({Sport? sport});
  Future<OpenSession> getSession(String id);
}
