// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Coach review submitted by a student for a specific session.
///
/// Three response shapes from BE map into this model:
/// - **Submit (POST 201)** and **my-review (GET)**: flat — `id`, `coach_id`,
///   `session_id`, `rating`, `comment`, `created_at`. Use [Review.fromJson].
/// - **List endpoints** (`/me/reviews`, admin coach reviews): nested
///   `coach: {id, name}` and `session: {id, title, date}`. Use
///   [Review.fromListJson].
///
/// Calling the wrong factory on the wrong shape silently drops data.
@freezed
class Review with _$Review {
  const factory Review({
    @JsonKey(fromJson: idFromJson) required String id,
    @JsonKey(name: 'coach_id', fromJson: idFromJson) required String coachId,
    @JsonKey(name: 'session_id', fromJson: idFromJson)
    required String sessionId,
    required int rating,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Populated only by [Review.fromListJson]; null on submit/my-review.
    String? coachName,
    String? sessionTitle,
    DateTime? sessionDate,
  }) = _Review;

  /// For flat shape (submit + my-review). Do **not** use on list-endpoint
  /// items — call [Review.fromListJson] instead so nested `coach`/`session`
  /// names hydrate.
  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  /// For list-endpoint items with nested `coach` and `session` objects.
  /// Throws [FormatException] if either is missing — list endpoints always
  /// hydrate them, so absence indicates a backend contract bug.
  factory Review.fromListJson(Map<String, dynamic> json) {
    final coach = json['coach'] as Map<String, dynamic>?;
    final session = json['session'] as Map<String, dynamic>?;
    if (coach == null) {
      throw const FormatException(
        'Review.fromListJson: nested `coach` object is required.',
      );
    }
    if (session == null) {
      throw const FormatException(
        'Review.fromListJson: nested `session` object is required.',
      );
    }
    final sessionDateStr = session['date'] as String?;
    return Review(
      id: idFromJson(json['id']),
      coachId: idFromJson(coach['id']),
      sessionId: idFromJson(session['id']),
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      coachName: coach['name'] as String?,
      sessionTitle: session['title'] as String?,
      sessionDate: sessionDateStr != null ? DateTime.parse(sessionDateStr) : null,
    );
  }
}
