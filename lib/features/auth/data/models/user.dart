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
    String? bio,
    String? city,
    String? avatarUrl,
    required UserRole role,
    @Default(false) bool isVerified,
    int? tenantId,
    String? tenantSlug,
    String? tenantName,
    String? tenantCurrency,
    String? tenantTimezone,
    /// Hex color (`#RRGGBB`) for fallback hero rendering — used by
    /// `SessionHero` when a session has no photo and falls back to the
    /// tenant logo (square logo centered on this color).
    String? tenantBrandColor,
    String? activeRole,
    String? locale,
    @Default([]) List<String> availableRoles,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
