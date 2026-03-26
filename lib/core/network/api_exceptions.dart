sealed class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message) : super(message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message) : super(message, statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message) : super(message, statusCode: 404);
}

class ValidationException extends ApiException {
  final Map<String, List<dynamic>> errors;

  const ValidationException(
    String message, {
    this.errors = const {},
  }) : super(message, statusCode: 422);
}

class ServerException extends ApiException {
  const ServerException(String message, {int statusCode = 500})
      : super(message, statusCode: statusCode);
}
