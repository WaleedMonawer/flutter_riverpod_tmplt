/// HTTP Client Implementation
/// Provides HTTP client functionality using Dio

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/logging_interceptor.dart';
import 'api_client.dart';
import '../../models/base/api_response.dart';
import '../../models/base/error_model.dart';

/// HTTP client implementation
class HttpClient implements ApiClient {
  late final Dio _dio;
  final String _baseUrl;
  final Map<String, String> _defaultHeaders;

  HttpClient({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? timeout,
  }) : _baseUrl = baseUrl,
       _defaultHeaders = defaultHeaders ?? {} {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: _defaultHeaders,
      connectTimeout: timeout ?? const Duration(seconds: 30),
      receiveTimeout: timeout ?? const Duration(seconds: 30),
      sendTimeout: timeout ?? const Duration(seconds: 30),
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor(
        logRequestHeaders: true,
        logRequestBody: true,
        logResponseHeaders: true,
        logResponseBody: true,
        logError: true,
      ));
    }
  }

  @override
  Dio get dio => _dio;

  @override
  String get baseUrl => _baseUrl;

  @override
  Map<String, String> get defaultHeaders => _defaultHeaders;

  @override
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required String filePath,
    String? fieldName,
    Map<String, dynamic>? formData,
    Map<String, String>? headers,
    T Function(Object? json)? fromJson,
  }) async {
    try {
      final formDataObj = FormData.fromMap({
        ...?formData,
        fieldName ?? 'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        path,
        data: formDataObj,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: fromJson != null ? fromJson(response.data) : response.data as T,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  Future<ApiResponse<String>> download(
    String path, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      
      return ApiResponse.success(
        data: savePath,
        statusCode: response.statusCode,
        metadata: response.headers.map,
      );
    } catch (error) {
      return ApiResponse.error(
        message: _getErrorMessage(error),
        errorCode: _getErrorCode(error),
        statusCode: _getStatusCode(error),
      );
    }
  }

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  @override
  ErrorModel handleError(dynamic error) {
    if (error is DioException) {
      return ErrorModel.networkError(
        message: error.message,
        details: error.response?.data?.toString(),
        metadata: {
          'url': error.requestOptions.uri.toString(),
          'method': error.requestOptions.method,
          'statusCode': error.response?.statusCode,
        },
      );
    }
    
    return ErrorModel.fromException(error);
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      return error.message ?? 'Network error occurred';
    }
    return error.toString();
  }

  /// Get error code from exception
  String _getErrorCode(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        if (statusCode >= 400 && statusCode < 500) {
          return 'CLIENT_ERROR';
        } else if (statusCode >= 500) {
          return 'SERVER_ERROR';
        }
      }
      return 'NETWORK_ERROR';
    }
    return 'UNKNOWN_ERROR';
  }

  /// Get status code from exception
  int? _getStatusCode(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode;
    }
    return null;
  }
} 