import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'court.freezed.dart';
part 'court.g.dart';

@freezed
class Court with _$Court {
  const factory Court({
    required String id,
    required String venueId,
    required String name,
    required Sport sportType,
    String? surfaceType,
    required String environment,
    @Default([]) List<String> photos,
    @Default(true) bool isActive,
  }) = _Court;

  factory Court.fromJson(Map<String, dynamic> json) => _$CourtFromJson(json);
}
