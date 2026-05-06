sealed class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message) : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

class ConflictException extends ApiException {
  const ConflictException(super.message) : super(statusCode: 409);
}

class ValidationException extends ApiException {
  final Map<String, List<dynamic>> errors;

  const ValidationException(
    super.message, {
    this.errors = const {},
  }) : super(statusCode: 422);
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode = 500});
}
