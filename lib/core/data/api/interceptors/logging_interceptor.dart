import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../logger.dart';

class LoggingInterceptor extends Interceptor {
  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final bool logError;

  LoggingInterceptor({
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponseHeaders = true,
    this.logResponseBody = true,
    this.logError = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }

    final requestPath = '${options.baseUrl}${options.path}';
    Logger.info('🌐 HTTP REQUEST');
    Logger.info('   Method: ${options.method}');
    Logger.info('   URL: $requestPath');
    
    if (logRequestHeaders && options.headers.isNotEmpty) {
      Logger.info('   Headers: ${options.headers}');
    }
    
    if (logRequestBody && options.data != null) {
      Logger.info('   Body: ${options.data}');
    }
    
    if (options.queryParameters.isNotEmpty) {
      Logger.info('   Query Parameters: ${options.queryParameters}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }

    final requestPath = '${response.requestOptions.baseUrl}${response.requestOptions.path}';
    Logger.info('✅ HTTP RESPONSE');
    Logger.info('   Status: ${response.statusCode}');
    Logger.info('   Method: ${response.requestOptions.method}');
    Logger.info('   URL: $requestPath');
    
    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      Logger.info('   Headers: ${response.headers}');
    }
    
    if (logResponseBody && response.data != null) {
      final data = response.data;
      if (data is List) {
        Logger.info('   Body: List with ${data.length} items');
        if (data.isNotEmpty) {
          Logger.info('   First Item: ${data.first}');
        }
      } else if (data is Map) {
        Logger.info('   Body: ${data.toString().substring(0, data.toString().length > 200 ? 200 : data.toString().length)}...');
      } else {
        Logger.info('   Body: $data');
      }
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(err);
      return;
    }

    final requestPath = '${err.requestOptions.baseUrl}${err.requestOptions.path}';
    Logger.error('❌ HTTP ERROR');
    Logger.error('   Status: ${err.response?.statusCode}');
    Logger.error('   Method: ${err.requestOptions.method}');
    Logger.error('   URL: $requestPath');
    Logger.error('   Message: ${err.message}');
    
    if (logError && err.response?.data != null) {
      Logger.error('   Error Response: ${err.response?.data}');
    }
    
    if (err.type == DioExceptionType.connectionTimeout) {
      Logger.error('   Type: Connection Timeout');
    } else if (err.type == DioExceptionType.receiveTimeout) {
      Logger.error('   Type: Receive Timeout');
    } else if (err.type == DioExceptionType.sendTimeout) {
      Logger.error('   Type: Send Timeout');
    } else if (err.type == DioExceptionType.badResponse) {
      Logger.error('   Type: Bad Response');
    } else if (err.type == DioExceptionType.cancel) {
      Logger.error('   Type: Request Cancelled');
    } else if (err.type == DioExceptionType.connectionError) {
      Logger.error('   Type: Connection Error');
    } else {
      Logger.error('   Type: Unknown Error');
    }

    handler.next(err);
  }
} 