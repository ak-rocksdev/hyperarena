import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/core/theme/app_enums.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    required UserRole role,
    @Default(false) bool isVerified,
    int? tenantId,
    String? tenantSlug,
    String? tenantName,
    String? activeRole,
    String? locale,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
