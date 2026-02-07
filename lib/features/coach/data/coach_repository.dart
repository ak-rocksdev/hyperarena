import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/features/coach/data/models/coach.dart';

abstract class CoachRepository {
  Future<List<Coach>> getCoaches({Sport? sport});
  Future<Coach> getCoach(String id);
}
