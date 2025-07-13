/// Base Error Model
/// Provides a consistent structure for error handling throughout the application

/// Base error model
class ErrorModel {
  final String message;
  final String code;
  final String? details;
  final Map<String, dynamic>? metadata;
  final DateTime? timestamp;
  final String? stackTrace;

  const ErrorModel({
    required this.message,
    required this.code,
    this.details,
    this.metadata,
    this.timestamp,
    this.stackTrace,
  });

  /// Create from exception
  factory ErrorModel.fromException(dynamic exception, {String? details}) {
    return ErrorModel(
      message: exception.toString(),
      code: 'EXCEPTION',
      details: details,
      timestamp: DateTime.now(),
    );
  }

  /// Create network error
  factory ErrorModel.networkError({
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message ?? 'Network error occurred',
      code: 'NETWORK_ERROR',
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create validation error
  factory ErrorModel.validationError({
    required String message,
    Map<String, List<String>>? fieldErrors,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message,
      code: 'VALIDATION_ERROR',
      details: fieldErrors?.toString(),
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create authentication error
  factory ErrorModel.authError({
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message ?? 'Authentication failed',
      code: 'AUTH_ERROR',
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create authorization error
  factory ErrorModel.authorizationError({
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message ?? 'Access denied',
      code: 'AUTHORIZATION_ERROR',
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create server error
  factory ErrorModel.serverError({
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message ?? 'Server error occurred',
      code: 'SERVER_ERROR',
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Create unknown error
  factory ErrorModel.unknownError({
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return ErrorModel(
      message: message ?? 'An unknown error occurred',
      code: 'UNKNOWN_ERROR',
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'details': details,
      'metadata': metadata,
      'timestamp': timestamp?.toIso8601String(),
      'stackTrace': stackTrace,
    };
  }

  /// Create from JSON
  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['message'] as String,
      code: json['code'] as String,
      details: json['details'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      stackTrace: json['stackTrace'] as String?,
    );
  }

  /// Copy with modifications
  ErrorModel copyWith({
    String? message,
    String? code,
    String? details,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    String? stackTrace,
  }) {
    return ErrorModel(
      message: message ?? this.message,
      code: code ?? this.code,
      details: details ?? this.details,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  String toString() {
    return 'ErrorModel(message: $message, code: $code, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ErrorModel &&
        other.message == message &&
        other.code == code &&
        other.details == details;
  }

  @override
  int get hashCode {
    return message.hashCode ^ code.hashCode ^ details.hashCode;
  }
}

/// Validation error model
class ValidationErrorModel extends ErrorModel {
  final Map<String, List<String>> fieldErrors;

  const ValidationErrorModel({
    required super.message,
    required this.fieldErrors,
    super.details,
    super.metadata,
    super.timestamp,
    super.stackTrace,
  }) : super(code: 'VALIDATION_ERROR');

  /// Create from field errors
  factory ValidationErrorModel.fromFieldErrors(
    Map<String, List<String>> fieldErrors, {
    String? message,
    Map<String, dynamic>? metadata,
  }) {
    return ValidationErrorModel(
      message: message ?? 'Validation failed',
      fieldErrors: fieldErrors,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Get all error messages
  List<String> getAllErrorMessages() {
    final messages = <String>[];
    for (final errors in fieldErrors.values) {
      messages.addAll(errors);
    }
    return messages;
  }

  /// Check if specific field has errors
  bool hasFieldError(String fieldName) {
    return fieldErrors.containsKey(fieldName) &&
        fieldErrors[fieldName]!.isNotEmpty;
  }

  /// Get errors for specific field
  List<String> getFieldErrors(String fieldName) {
    return fieldErrors[fieldName] ?? [];
  }

  /// Get first error for specific field
  String? getFirstFieldError(String fieldName) {
    final errors = getFieldErrors(fieldName);
    return errors.isNotEmpty ? errors.first : null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'fieldErrors': fieldErrors,
    };
  }

  @override
  factory ValidationErrorModel.fromJson(Map<String, dynamic> json) {
    return ValidationErrorModel(
      message: json['message'] as String,
      fieldErrors: (json['fieldErrors'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
      ),
      details: json['details'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      stackTrace: json['stackTrace'] as String?,
    );
  }
}

/// Network error model
class NetworkErrorModel extends ErrorModel {
  final int? statusCode;
  final String? url;
  final String? method;

  const NetworkErrorModel({
    required super.message,
    this.statusCode,
    this.url,
    this.method,
    super.details,
    super.metadata,
    super.timestamp,
    super.stackTrace,
  }) : super(code: 'NETWORK_ERROR');

  /// Create from HTTP response
  factory NetworkErrorModel.fromHttpResponse({
    required int statusCode,
    required String url,
    String? method,
    String? message,
    String? details,
    Map<String, dynamic>? metadata,
  }) {
    return NetworkErrorModel(
      message: message ?? 'HTTP $statusCode error',
      statusCode: statusCode,
      url: url,
      method: method,
      details: details,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  /// Check if it's a client error (4xx)
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Check if it's a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Check if it's a timeout error
  bool get isTimeoutError => statusCode == 408 || message.toLowerCase().contains('timeout');

  /// Check if it's a connection error
  bool get isConnectionError => statusCode == null || statusCode == 0;

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'statusCode': statusCode,
      'url': url,
      'method': method,
    };
  }

  @override
  factory NetworkErrorModel.fromJson(Map<String, dynamic> json) {
    return NetworkErrorModel(
      message: json['message'] as String,
      statusCode: json['statusCode'] as int?,
      url: json['url'] as String?,
      method: json['method'] as String?,
      details: json['details'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      stackTrace: json['stackTrace'] as String?,
    );
  }
}

/// Extension methods for error handling
extension ErrorModelExtensions on ErrorModel {
  /// Check if error is network related
  bool get isNetworkError => code == 'NETWORK_ERROR';

  /// Check if error is validation related
  bool get isValidationError => code == 'VALIDATION_ERROR';

  /// Check if error is authentication related
  bool get isAuthError => code == 'AUTH_ERROR';

  /// Check if error is authorization related
  bool get isAuthorizationError => code == 'AUTHORIZATION_ERROR';

  /// Check if error is server related
  bool get isServerError => code == 'SERVER_ERROR';

  /// Check if error is unknown
  bool get isUnknownError => code == 'UNKNOWN_ERROR';

  /// Get user-friendly error message
  String get userFriendlyMessage {
    switch (code) {
      case 'NETWORK_ERROR':
        return 'Please check your internet connection and try again';
      case 'VALIDATION_ERROR':
        return 'Please check your input and try again';
      case 'AUTH_ERROR':
        return 'Please log in again';
      case 'AUTHORIZATION_ERROR':
        return 'You don\'t have permission to perform this action';
      case 'SERVER_ERROR':
        return 'Something went wrong on our end. Please try again later';
      case 'UNKNOWN_ERROR':
        return 'Something unexpected happened. Please try again';
      default:
        return message;
    }
  }
} 