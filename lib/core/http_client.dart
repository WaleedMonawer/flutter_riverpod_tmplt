import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'interceptors/logging_interceptor.dart';

class HttpClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static void initialize() {
    // Add logging interceptor only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LoggingInterceptor(
          logRequestHeaders: true,
          logRequestBody: true,
          logResponseHeaders: true,
          logResponseBody: true,
          logError: true,
        ),
      );
    }
  }
} 