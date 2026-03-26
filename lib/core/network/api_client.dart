import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/config/app_config.dart';
import 'package:hyperarena/core/network/api_interceptor.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required AppConfig config,
    required SecureStorageService secureStorage,
    required GoRouter router,
    String? tenantSlug,
    String locale = 'id',
  }) : _dio = Dio(BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'X-Client-Type': 'mobile',
            'X-Device-Name': 'HyperArena Mobile',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        )) {
    _dio.interceptors.add(
      ApiInterceptor(
        secureStorage: secureStorage,
        router: router,
        tenantSlug: tenantSlug,
        locale: locale,
      ),
    );
    if (config.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.post(path, data: data, queryParameters: queryParameters);

  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.put(path, data: data, queryParameters: queryParameters);

  Future<Response> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.patch(path, data: data, queryParameters: queryParameters);

  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.delete(path, data: data, queryParameters: queryParameters);
}
