class DioRestClientException implements Exception {
  const DioRestClientException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

class BadRequestException extends DioRestClientException {
  const BadRequestException(String message) : super(message, statusCode: 400);
}

class UnauthorizedException extends DioRestClientException {
  const UnauthorizedException(String message) : super(message, statusCode: 401);
}

class ForbiddenException extends DioRestClientException {
  const ForbiddenException(String message) : super(message, statusCode: 403);
}

class NotFoundException extends DioRestClientException {
  const NotFoundException(String message) : super(message, statusCode: 404);
}

class InternalServerErrorException extends DioRestClientException {
  const InternalServerErrorException(String message) : super(message, statusCode: 500);
}
