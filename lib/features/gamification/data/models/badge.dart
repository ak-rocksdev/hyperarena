import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required String description,
    required String iconName,
    @Default(false) bool isUnlocked,
    DateTime? unlockedAt,
    @Default(0) int xpReward,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}
