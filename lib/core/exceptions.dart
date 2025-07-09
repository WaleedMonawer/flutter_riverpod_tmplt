abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException(String message, [String? code]) : super(message, code);
}

class ServerException extends AppException {
  const ServerException(String message, [String? code]) : super(message, code);
}

class CacheException extends AppException {
  const CacheException(String message, [String? code]) : super(message, code);
}

class ValidationException extends AppException {
  const ValidationException(String message, [String? code]) : super(message, code);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message, [String? code]) : super(message, code);
} 