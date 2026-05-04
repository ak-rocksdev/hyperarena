import 'package:dio/dio.dart';
import 'package:hyperarena/core/config/http_headers.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final void Function()? _onUnauthorized;
  final String? _tenantSlug;
  final String _locale;

  bool _isRedirecting = false;

  ApiInterceptor({
    required SecureStorageService secureStorage,
    void Function()? onUnauthorized,
    String? tenantSlug,
    String locale = 'id',
  })  : _secureStorage = secureStorage,
        _onUnauthorized = onUnauthorized,
        _tenantSlug = tenantSlug,
        _locale = locale;

  static const _publicPaths = [
    '/v1/auth/login',
    '/v1/auth/register',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip auth header for public endpoints
    final isPublic = _publicPaths.any((p) => options.path.endsWith(p));
    if (!isPublic) {
      final token = _secureStorage.getToken();
      if (token != null) {
        options.headers[HttpHeaders.authorization] = 'Bearer $token';
      }
    }

    // Dynamic headers (static headers set on BaseOptions)
    options.headers[HttpHeaders.acceptLanguage] = _locale;

    // Tenant slug (optional — null means skip)
    if (_tenantSlug != null) {
      options.headers[HttpHeaders.tenant] = _tenantSlug;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final dataMap = err.response?.data is Map<String, dynamic>
        ? err.response!.data as Map<String, dynamic>
        : null;
    final message = dataMap?['message'] as String? ?? '';

    switch (statusCode) {
      case 401:
        _handleUnauthorized();
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(message),
            response: err.response,
          ),
        );
      case 403:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ForbiddenException(message),
            response: err.response,
          ),
        );
      case 404:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: NotFoundException(message),
            response: err.response,
          ),
        );
      case 422:
        final errors = (dataMap?['errors'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as List<dynamic>)) ??
            {};
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ValidationException(message, errors: errors),
            response: err.response,
          ),
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: ServerException(message, statusCode: statusCode),
              response: err.response,
            ),
          );
        } else {
          handler.next(err);
        }
    }
  }

  void _handleUnauthorized() {
    if (_isRedirecting) return;
    _isRedirecting = true;
    _secureStorage.deleteToken();
    _onUnauthorized?.call();
    Future.delayed(const Duration(seconds: 1), () => _isRedirecting = false);
  }
}
