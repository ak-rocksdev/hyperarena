import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'open_session.freezed.dart';
part 'open_session.g.dart';

@freezed
class OpenSession with _$OpenSession {
  const factory OpenSession({
    required String id,
    required String title,
    required Sport sport,
    required String hostId,
    required String hostName,
    required String venueName,
    required String venueId,
    required DateTime date,
    required String startTime,
    required String endTime,
    @Default(0) int currentPlayers,
    required int maxPlayers,
    LevelTier? minLevel,
    LevelTier? maxLevel,
    required int pricePerPerson,
    String? description,
    @Default([]) List<String> participantNames,
  }) = _OpenSession;

  factory OpenSession.fromJson(Map<String, dynamic> json) =>
      _$OpenSessionFromJson(json);
}
