import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';
import 'package:hyperarena/routing/app_routes.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final GoRouter _router;
  final String? _tenantSlug;
  final String _locale;

  bool _isRedirecting = false;

  ApiInterceptor({
    required SecureStorageService secureStorage,
    required GoRouter router,
    String? tenantSlug,
    String locale = 'id',
  })  : _secureStorage = secureStorage,
        _router = router,
        _tenantSlug = tenantSlug,
        _locale = locale;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Bearer token (from in-memory cache — synchronous)
    final token = _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Dynamic headers (static headers set on BaseOptions)
    options.headers['Accept-Language'] = _locale;

    // Tenant slug (optional — null means skip)
    if (_tenantSlug != null) {
      options.headers['X-Tenant'] = _tenantSlug;
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
    // Fire-and-forget — cache is cleared synchronously inside deleteToken(),
    // encrypted storage write is async but non-critical here.
    _secureStorage.deleteToken();
    _router.go(AppRoutes.login);
    // Reset after a short delay to allow navigation to complete
    Future.delayed(const Duration(seconds: 1), () => _isRedirecting = false);
  }
}
