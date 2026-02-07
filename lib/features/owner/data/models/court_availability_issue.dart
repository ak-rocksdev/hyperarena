import 'package:freezed_annotation/freezed_annotation.dart';

part 'court_availability_issue.freezed.dart';
part 'court_availability_issue.g.dart';

@freezed
class CourtAvailabilityIssue with _$CourtAvailabilityIssue {
  const factory CourtAvailabilityIssue({
    required String id,
    required String courtId,
    required String courtName,
    required String venueId,
    required String venueName,
    required DateTime from,
    required DateTime to,
    required String reason,
    @Default(false) bool requiresOrganizerNotice,
  }) = _CourtAvailabilityIssue;

  factory CourtAvailabilityIssue.fromJson(Map<String, dynamic> json) =>
      _$CourtAvailabilityIssueFromJson(json);
}
