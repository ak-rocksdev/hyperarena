import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'coach.freezed.dart';
part 'coach.g.dart';

@freezed
class Coach with _$Coach {
  const factory Coach({
    required String id,
    required String name,
    required String bio,
    String? avatarUrl,
    @Default([]) List<Sport> sports,
    @Default(0.0) double rating,
    @Default(0) int totalReviews,
    required int hourlyRate,
    required String city,
    @Default(false) bool isVerified,
    @Default(LevelTier.amateur) LevelTier level,
    @Default(0) int totalStudents,
    @Default([]) List<String> certifications,
    @Default([]) List<String> availableDays,
    String? availableStartTime,
    String? availableEndTime,
  }) = _Coach;

  factory Coach.fromJson(Map<String, dynamic> json) => _$CoachFromJson(json);
}
