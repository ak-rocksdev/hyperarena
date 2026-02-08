import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String reviewerId,
    required String reviewerName,
    required String coachId,
    required String coachName,
    required String sessionId,
    required String sessionTitle,
    required Sport sport,
    required DateTime date,
    required int rating,
    String? comment,
    @Default(false) bool isAnonymous,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
