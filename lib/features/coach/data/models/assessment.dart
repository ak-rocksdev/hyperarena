import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'assessment.freezed.dart';
part 'assessment.g.dart';

@freezed
class Assessment with _$Assessment {
  const factory Assessment({
    required String id,
    required String coachId,
    required String coachName,
    required String studentId,
    required String studentName,
    required Sport sport,
    required DateTime date,
    required int technique,
    required int stamina,
    required int tactics,
    required int mentality,
    required int consistency,
    String? notes,
    @Default(LevelTier.rookie) LevelTier recommendedLevel,
    // Session link
    String? sessionId,
    String? sessionTitle,
    // Structured improvement feedback
    String? whatToImprove,
    String? playingStyleNotes,
    String? strengthHighlight,
  }) = _Assessment;

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
}
