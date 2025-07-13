/// API Constants
/// Contains all API-related constants used throughout the application
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String devBaseUrl = 'https://dev-api.example.com';
  static const String stagingBaseUrl = 'https://staging-api.example.com';
  static const String prodBaseUrl = 'https://api.example.com';

  // Endpoints
  static const String postsEndpoint = '/posts';
  static const String usersEndpoint = '/users';
  static const String commentsEndpoint = '/comments';
  static const String todosEndpoint = '/todos';

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  static const String userAgentHeader = 'User-Agent';

  // Content Types
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const int cacheTimeout = 3600000; // 1 hour
  static const int shortCacheTimeout = 300000; // 5 minutes

  // Retry
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Error Codes
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String unauthorizedError = 'UNAUTHORIZED';
  static const String forbiddenError = 'FORBIDDEN';
  static const String notFoundError = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String timeoutError = 'TIMEOUT_ERROR';

  // Success Codes
  static const String success = 'SUCCESS';
  static const String created = 'CREATED';
  static const String updated = 'UPDATED';
  static const String deleted = 'DELETED';
} 