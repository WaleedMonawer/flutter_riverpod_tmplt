/// Network Exceptions
/// Contains all network-related exceptions used throughout the application
import 'app_exceptions.dart';

/// Exception thrown when there's no internet connection
class NoInternetException extends AppException {
  const NoInternetException([String? message])
      : super(
          message ?? 'No internet connection available',
          'NO_INTERNET_CONNECTION',
        );
}

/// Exception thrown when the server is unreachable
class ServerUnreachableException extends AppException {
  const ServerUnreachableException([String? message])
      : super(
          message ?? 'Server is unreachable',
          'SERVER_UNREACHABLE',
        );
}

/// Exception thrown when the request times out
class TimeoutException extends AppException {
  const TimeoutException([String? message])
      : super(
          message ?? 'Request timed out',
          'TIMEOUT',
        );
}

/// Exception thrown when there's a connection error
class ConnectionException extends AppException {
  const ConnectionException([String? message])
      : super(
          message ?? 'Connection error occurred',
          'CONNECTION_ERROR',
        );
}

/// Exception thrown when the API returns a 401 Unauthorized
class UnauthorizedException extends AppException {
  const UnauthorizedException([String? message])
      : super(
          message ?? 'Unauthorized access',
          'UNAUTHORIZED',
        );
}

/// Exception thrown when the API returns a 403 Forbidden
class ForbiddenException extends AppException {
  const ForbiddenException([String? message])
      : super(
          message ?? 'Access forbidden',
          'FORBIDDEN',
        );
}

/// Exception thrown when the API returns a 404 Not Found
class NotFoundException extends AppException {
  const NotFoundException([String? message])
      : super(
          message ?? 'Resource not found',
          'NOT_FOUND',
        );
}

/// Exception thrown when the API returns a 422 Validation Error
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException([String? message, this.errors])
      : super(
          message ?? 'Validation error occurred',
          'VALIDATION_ERROR',
        );
}

/// Exception thrown when the API returns a 500 Server Error
class ServerException extends AppException {
  const ServerException([String? message])
      : super(
          message ?? 'Server error occurred',
          'SERVER_ERROR',
        );
}

/// Exception thrown when the API returns an unexpected status code
class UnexpectedException extends AppException {
  final int statusCode;

  const UnexpectedException(this.statusCode, [String? message])
      : super(
          message ?? 'Unexpected error occurred (Status: $statusCode)',
          'UNEXPECTED_ERROR',
        );
}

/// Exception thrown when there's a parsing error
class ParsingException extends AppException {
  const ParsingException([String? message])
      : super(
          message ?? 'Error parsing response',
          'PARSING_ERROR',
        );
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException([String? message])
      : super(
          message ?? 'Cache error occurred',
          'CACHE_ERROR',
        );
}

/// Exception thrown when there's a retry limit exceeded
class RetryLimitExceededException extends AppException {
  const RetryLimitExceededException([String? message])
      : super(
          message ?? 'Retry limit exceeded',
          'RETRY_LIMIT_EXCEEDED',
        );
}

/// Exception thrown when there's a rate limit exceeded
class RateLimitExceededException extends AppException {
  const RateLimitExceededException([String? message])
      : super(
          message ?? 'Rate limit exceeded',
          'RATE_LIMIT_EXCEEDED',
        );
}

/// Exception thrown when there's a certificate error
class CertificateException extends AppException {
  const CertificateException([String? message])
      : super(
          message ?? 'Certificate error occurred',
          'CERTIFICATE_ERROR',
        );
}

/// Exception thrown when there's a DNS resolution error
class DnsException extends AppException {
  const DnsException([String? message])
      : super(
          message ?? 'DNS resolution error',
          'DNS_ERROR',
        );
}

/// Exception thrown when there's a socket error
class SocketException extends AppException {
  const SocketException([String? message])
      : super(
          message ?? 'Socket error occurred',
          'SOCKET_ERROR',
        );
} 