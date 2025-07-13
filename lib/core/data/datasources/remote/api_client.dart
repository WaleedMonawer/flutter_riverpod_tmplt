/// API Client Interface
/// Defines the contract for API clients

import 'package:dio/dio.dart';
import '../../models/base/api_response.dart';
import '../../models/base/error_model.dart';

/// Base API client interface
abstract class ApiClient {
  /// Get HTTP client instance
  Dio get dio;

  /// Base URL for API
  String get baseUrl;

  /// Default headers
  Map<String, String> get defaultHeaders;

  /// Make GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Make POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Make PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Make PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Make DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Upload file
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required String filePath,
    String? fieldName,
    Map<String, dynamic>? formData,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  });

  /// Download file
  Future<ApiResponse<String>> download(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });

  /// Set authentication token
  void setAuthToken(String token);

  /// Clear authentication token
  void clearAuthToken();

  /// Add interceptor
  void addInterceptor(Interceptor interceptor);

  /// Remove interceptor
  void removeInterceptor(Interceptor interceptor);

  /// Handle error response
  ErrorModel handleError(dynamic error);
}

/// HTTP methods enum
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

/// API request options
class ApiRequestOptions {
  final Map<String, dynamic>? queryParameters;
  final Map<String, String>? headers;
  final Duration? timeout;
  final bool followRedirects;
  final int? maxRedirects;
  final bool validateStatus;
  final bool receiveDataWhenStatusError;

  const ApiRequestOptions({
    this.queryParameters,
    this.headers,
    this.timeout,
    this.followRedirects = true,
    this.maxRedirects = 5,
    this.validateStatus = true,
    this.receiveDataWhenStatusError = true,
  });

  /// Create from options
  factory ApiRequestOptions.fromOptions(ApiRequestOptions? options) {
    return ApiRequestOptions(
      queryParameters: options?.queryParameters,
      headers: options?.headers,
      timeout: options?.timeout,
      followRedirects: options?.followRedirects ?? true,
      maxRedirects: options?.maxRedirects ?? 5,
      validateStatus: options?.validateStatus ?? true,
      receiveDataWhenStatusError: options?.receiveDataWhenStatusError ?? true,
    );
  }

  /// Merge with other options
  ApiRequestOptions merge(ApiRequestOptions? other) {
    if (other == null) return this;
    
    return ApiRequestOptions(
      queryParameters: {...?queryParameters, ...?other.queryParameters},
      headers: {...?headers, ...?other.headers},
      timeout: other.timeout ?? timeout,
      followRedirects: other.followRedirects ?? followRedirects,
      maxRedirects: other.maxRedirects ?? maxRedirects,
      validateStatus: other.validateStatus ?? validateStatus,
      receiveDataWhenStatusError: other.receiveDataWhenStatusError ?? receiveDataWhenStatusError,
    );
  }
}

/// API response wrapper
class ApiResponseWrapper<T> {
  final T? data;
  final int? statusCode;
  final Map<String, List<String>>? headers;
  final String? message;
  final ErrorModel? error;

  const ApiResponseWrapper({
    this.data,
    this.statusCode,
    this.headers,
    this.message,
    this.error,
  });

  /// Check if response is successful
  bool get isSuccess => error == null && statusCode != null && statusCode! >= 200 && statusCode! < 300;

  /// Check if response has error
  bool get hasError => error != null;

  /// Get error message
  String get errorMessage => error?.message ?? message ?? 'Unknown error';

  /// Create success response
  factory ApiResponseWrapper.success({
    required T data,
    int? statusCode,
    Map<String, List<String>>? headers,
    String? message,
  }) {
    return ApiResponseWrapper<T>(
      data: data,
      statusCode: statusCode,
      headers: headers,
      message: message,
    );
  }

  /// Create error response
  factory ApiResponseWrapper.error({
    required ErrorModel error,
    int? statusCode,
    Map<String, List<String>>? headers,
  }) {
    return ApiResponseWrapper<T>(
      error: error,
      statusCode: statusCode,
      headers: headers,
    );
  }

  /// Convert to API response
  ApiResponse<T> toApiResponse() {
    if (isSuccess) {
      return ApiResponse.success(
        data: data!,
        message: message,
        statusCode: statusCode,
        metadata: headers?.map((key, value) => MapEntry(key, value)),
      );
    } else {
      return ApiResponse.error(
        message: errorMessage,
        errorCode: error?.code ?? 'UNKNOWN_ERROR',
        statusCode: statusCode,
        errors: error?.metadata,
        metadata: headers?.map((key, value) => MapEntry(key, value)),
      );
    }
  }
} 