// lib/features/auth/data/mappers/auth_response_mapper.dart
import 'package:hyperarena/features/auth/data/mappers/role_mapper.dart';
import 'package:hyperarena/features/auth/data/models/auth_token.dart';
import 'package:hyperarena/features/auth/data/models/user.dart';

/// Parses the login/register response JSON into a [User] and [AuthToken].
///
/// Expected JSON shape:
/// ```json
/// { "user": { ... }, "token": "1|abc..." }
/// ```
(User, AuthToken) parseLoginResponse(Map<String, dynamic> json) {
  final userJson = json['user'] as Map<String, dynamic>;
  final tokenStr = json['token'] as String;

  return (
    _parseUser(userJson),
    AuthToken(token: tokenStr),
  );
}

/// Parses the user object from `GET /v1/auth/me`.
///
/// The /me endpoint returns the user object directly (not wrapped).
User parseUserResponse(Map<String, dynamic> json) {
  return _parseUser(json);
}

User _parseUser(Map<String, dynamic> json) {
  final tenant = json['tenant'] as Map<String, dynamic>?;
  final activeRole = json['active_role'] as String?;

  // Read from can_switch_to (flat string array) with fallback to roles
  final canSwitchTo = json['can_switch_to'];
  final availableRoles = canSwitchTo is List
      ? canSwitchTo.cast<String>().toList()
      : _extractRoleNames(json['roles']); // fallback for old API
  final effectiveRole = activeRole ?? _highestRole(availableRoles);

  return User(
    id: json['id'].toString(),
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String?,
    avatarUrl: _extractAvatarUrl(json),
    role: mapBackendRole(effectiveRole),
    activeRole: effectiveRole,
    tenantId: json['tenant_id'] as int?,
    tenantSlug: tenant?['slug'] as String?,
    tenantName: tenant?['name'] as String?,
    locale: json['locale'] as String?,
    availableRoles: availableRoles,
  );
}

/// Extracts the best available avatar URL from the user JSON.
/// Prefers photo_urls (sized variants) > photo_path (raw path).
String? _extractAvatarUrl(Map<String, dynamic> json) {
  final photoUrls = json['photo_urls'];
  if (photoUrls is Map) {
    // Prefer medium size, fall back to smallest available
    return (photoUrls['md'] ?? photoUrls['sm'] ?? photoUrls['lg'])
        as String?;
  }
  return json['photo_path'] as String?;
}

/// Extracts role name strings from the `roles` JSON relation.
List<String> _extractRoleNames(dynamic roles) {
  if (roles is! List || roles.isEmpty) return [];
  return roles
      .map((r) => r is Map ? r['name'] as String? : null)
      .whereType<String>()
      .toList();
}

/// Picks the highest-priority role name from an already-extracted list.
/// Priority: super-admin > admin > coach > member
String? _highestRole(List<String> names) {
  if (names.isEmpty) return null;
  const priority = ['super-admin', 'admin', 'coach', 'member'];
  for (final p in priority) {
    if (names.contains(p)) return p;
  }
  return names.firstOrNull;
}
