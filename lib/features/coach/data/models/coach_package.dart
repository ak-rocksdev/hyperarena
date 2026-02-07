import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'coach_package.freezed.dart';
part 'coach_package.g.dart';

@freezed
class CoachPackage with _$CoachPackage {
  const factory CoachPackage({
    required String id,
    required String coachId,
    required String name,
    required String description,
    required Sport sport,
    required int sessions,
    required int pricePerSession,
    required int durationMinutes,
    @Default(true) bool isActive,
  }) = _CoachPackage;

  factory CoachPackage.fromJson(Map<String, dynamic> json) =>
      _$CoachPackageFromJson(json);
}
