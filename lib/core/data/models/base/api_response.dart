/// Base API Response Model
/// Provides a consistent structure for all API responses

/// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
  final bool isSuccess;
  final String? errorCode;
  final Map<String, dynamic>? errors;

  const ApiResponse._({
    this.data,
    this.message,
    this.statusCode,
    this.metadata,
    required this.isSuccess,
    this.errorCode,
    this.errors,
  });

  /// Create a successful response
  factory ApiResponse.success({
    required T data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse._(
      data: data,
      message: message,
      statusCode: statusCode,
      metadata: metadata,
      isSuccess: true,
    );
  }

  /// Create an error response
  factory ApiResponse.error({
    required String message,
    required String errorCode,
    int? statusCode,
    Map<String, dynamic>? errors,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse._(
      message: message,
      statusCode: statusCode,
      metadata: metadata,
      isSuccess: false,
      errorCode: errorCode,
      errors: errors,
    );
  }

  /// Create a loading response
  factory ApiResponse.loading() {
    return const ApiResponse._(isSuccess: false);
  }

  /// Check if response is loading
  bool get isLoading => !isSuccess && data == null && errorCode == null;

  /// Get error message if error, null otherwise
  String? get errorMessage => isSuccess ? null : message;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'data': data,
      'message': message,
      'statusCode': statusCode,
      'metadata': metadata,
      'errorCode': errorCode,
      'errors': errors,
    };
  }

  /// Create from JSON
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    final isSuccess = json['isSuccess'] as bool? ?? false;
    
    if (isSuccess) {
      return ApiResponse.success(
        data: fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T,
        message: json['message'] as String?,
        statusCode: json['statusCode'] as int?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    } else {
      return ApiResponse.error(
        message: json['message'] as String? ?? 'Unknown error',
        errorCode: json['errorCode'] as String? ?? 'UNKNOWN_ERROR',
        statusCode: json['statusCode'] as int?,
        errors: json['errors'] as Map<String, dynamic>?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );
    }
  }
}

/// Paginated API response wrapper
class PaginatedApiResponse<T> {
  final List<T> data;
  final PaginationInfo pagination;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? metadata;

  const PaginatedApiResponse({
    required this.data,
    required this.pagination,
    this.message,
    this.statusCode,
    this.metadata,
  });

  /// Check if there are more pages
  bool get hasMorePages => pagination.hasNextPage;

  /// Get current page number
  int get currentPage => pagination.currentPage;

  /// Get total number of pages
  int get totalPages => pagination.totalPages;

  /// Get total number of items
  int get totalItems => pagination.totalItems;

  /// Get items per page
  int get itemsPerPage => pagination.itemsPerPage;

  /// Check if this is the first page
  bool get isFirstPage => pagination.currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => pagination.currentPage >= pagination.totalPages;

  /// Get next page number
  int? get nextPage => pagination.nextPage;

  /// Get previous page number
  int? get previousPage => pagination.previousPage;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'pagination': pagination.toJson(),
      'message': message,
      'statusCode': statusCode,
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedApiResponse<T>(
      data: (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Pagination information
class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int? nextPage;
  final int? previousPage;

  const PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.nextPage,
    this.previousPage,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'nextPage': nextPage,
      'previousPage': previousPage,
    };
  }

  /// Create from JSON
  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      nextPage: json['nextPage'] as int?,
      previousPage: json['previousPage'] as int?,
    );
  }
}

/// API Error Response
class ApiErrorResponse {
  final String message;
  final String errorCode;
  final int? statusCode;
  final Map<String, List<String>>? errors;
  final Map<String, dynamic>? metadata;
  final String? timestamp;
  final String? path;

  const ApiErrorResponse({
    required this.message,
    required this.errorCode,
    this.statusCode,
    this.errors,
    this.metadata,
    this.timestamp,
    this.path,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errorCode': errorCode,
      'statusCode': statusCode,
      'errors': errors,
      'metadata': metadata,
      'timestamp': timestamp,
      'path': path,
    };
  }

  /// Create from JSON
  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      message: json['message'] as String,
      errorCode: json['errorCode'] as String,
      statusCode: json['statusCode'] as int?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as List<dynamic>).cast<String>()),
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] as String?,
      path: json['path'] as String?,
    );
  }
}

/// API Success Response
class ApiSuccessResponse<T> {
  final T data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? metadata;
  final String? timestamp;

  const ApiSuccessResponse({
    required this.data,
    this.message,
    this.statusCode,
    this.metadata,
    this.timestamp,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'statusCode': statusCode,
      'metadata': metadata,
      'timestamp': timestamp,
    };
  }

  /// Create from JSON
  factory ApiSuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiSuccessResponse<T>(
      data: fromJsonT(json['data']),
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] as String?,
    );
  }
}

/// API Metadata
class ApiMetadata {
  final String? version;
  final String? timestamp;
  final String? requestId;
  final Map<String, dynamic>? additionalData;

  const ApiMetadata({
    this.version,
    this.timestamp,
    this.requestId,
    this.additionalData,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'timestamp': timestamp,
      'requestId': requestId,
      'additionalData': additionalData,
    };
  }

  /// Create from JSON
  factory ApiMetadata.fromJson(Map<String, dynamic> json) {
    return ApiMetadata(
      version: json['version'] as String?,
      timestamp: json['timestamp'] as String?,
      requestId: json['requestId'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }
} 