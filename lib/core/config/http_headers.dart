/// HTTP header name and value constants used across the app.
///
/// Standard headers (Authorization, Accept, etc.) follow RFC 7230 casing.
/// Custom HyperArena headers use the `X-` prefix and PascalCase-with-dash
/// to match the backend API contract.
class HttpHeaders {
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';
  static const String contentType = 'Content-Type';
  static const String acceptLanguage = 'Accept-Language';

  static const String tenant = 'X-Tenant';
  static const String clientType = 'X-Client-Type';
  static const String deviceName = 'X-Device-Name';

  static const String clientTypeMobile = 'mobile';
}
