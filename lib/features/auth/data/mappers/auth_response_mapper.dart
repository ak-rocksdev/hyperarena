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

  return User(
    id: json['id'].toString(),
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String?,
    avatarUrl: json['photo_path'] as String?,
    role: mapBackendRole(activeRole),
    activeRole: activeRole,
    tenantId: json['tenant_id'] as int?,
    tenantSlug: tenant?['slug'] as String?,
    tenantName: tenant?['name'] as String?,
    locale: json['locale'] as String?,
  );
}
