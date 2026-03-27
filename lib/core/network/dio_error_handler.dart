import 'package:dio/dio.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';

/// Unwraps a DioException to rethrow the inner ApiException if present.
/// Used by all marketplace API repositories.
Never rethrowDio(DioException e) {
  if (e.error is ApiException) throw e.error!;
  throw e;
}
