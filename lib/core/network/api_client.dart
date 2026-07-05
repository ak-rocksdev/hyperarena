import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperarena/core/config/app_env.dart';
import 'package:hyperarena/core/config/http_headers.dart';
import 'package:hyperarena/core/network/api_interceptor.dart';
import 'package:hyperarena/core/storage/secure_storage_service.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required SecureStorageService secureStorage,
    void Function()? onUnauthorized,
    String? tenantSlug,
    String locale = 'id',
  }) : _dio = Dio(BaseOptions(
          baseUrl: AppEnv.apiBaseUrl,
          connectTimeout: AppEnv.httpTimeout,
          receiveTimeout: AppEnv.httpTimeout,
          headers: {
            HttpHeaders.clientType: HttpHeaders.clientTypeMobile,
            HttpHeaders.deviceName: 'HyperArena Mobile',
            HttpHeaders.accept: 'application/json',
            HttpHeaders.contentType: 'application/json',
          },
        )) {
    _dio.interceptors.add(
      ApiInterceptor(
        secureStorage: secureStorage,
        onUnauthorized: onUnauthorized,
        tenantSlug: tenantSlug,
        locale: locale,
      ),
    );
    if (AppEnv.isLocal) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  /// Test hook: lets http_mock_adapter attach a mock HttpClientAdapter.
  @visibleForTesting
  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? extraHeaders,
  }) =>
      _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: extraHeaders != null ? Options(headers: extraHeaders) : null,
      );

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
