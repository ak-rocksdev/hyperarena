import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'create_session_draft.freezed.dart';
part 'create_session_draft.g.dart';

/// Draft for creating a session, aligned 1:1 with the backend contract
/// (`App\Http\Requests\Admin\StoreSessionRequest`). See
/// docs/superpowers/plans for the field mapping.
@freezed
class CreateSessionDraft with _$CreateSessionDraft {
  const CreateSessionDraft._();

  const factory CreateSessionDraft({
    @Default(<int>[]) List<int> coachIds,
    @Default(SessionType.group) SessionType type,
    String? title,
    DateTime? date,
    String? startTime, // "HH:mm"
    @Default(60) int durationMinutes,
    int? capacity, // null = unlimited (also null for private)
    String? venueId,
    String? venueName,
    int? price, // minor units; null = free
    String? notes,
  }) = _CreateSessionDraft;

  factory CreateSessionDraft.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionDraftFromJson(json);

  /// `true` once the required fields for step 1 are satisfied.
  bool get step1Valid => coachIds.isNotEmpty;

  /// `true` once the whole draft can be submitted.
  bool get canSubmit =>
      coachIds.isNotEmpty &&
      date != null &&
      startTime != null &&
      durationMinutes >= 15 &&
      durationMinutes <= 480;

  /// Tenant-local `start_at` string ("yyyy-MM-dd HH:mm"), or null when the
  /// date/time aren't both set. No timezone offset — the backend interprets
  /// it in the tenant timezone (matches the admin panel).
  String? get startAtString {
    if (date == null || startTime == null) return null;
    final d = date!;
    final ymd =
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    return '$ymd $startTime';
  }

  /// Payload matching `StoreSessionRequest` exactly.
  Map<String, dynamic> toCreatePayload() {
    // capacity is meaningless for private sessions.
    final effectiveCapacity = type == SessionType.private ? null : capacity;
    final trimmedTitle = title?.trim();
    return {
      'coach_ids': coachIds,
      'type': type.name,
      'title': (trimmedTitle == null || trimmedTitle.isEmpty)
          ? null
          : trimmedTitle,
      'start_at': startAtString,
      'duration_minutes': durationMinutes,
      'capacity': effectiveCapacity,
      'venue_id': venueId == null ? null : int.tryParse(venueId!),
      'price': price,
      'notes': (notes == null || notes!.trim().isEmpty) ? null : notes!.trim(),
    };
  }
}
