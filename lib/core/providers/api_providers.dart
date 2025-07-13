import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_tmplt/core/common/constants/app_constants.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/remote/interceptors/logging_interceptor.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/remote/api_service.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/remote/http_client.dart';




// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
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
  
  return dio;
});

// ApiService Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiServiceImpl(apiClient: HttpClient(baseUrl: AppConstants.baseUrl, defaultHeaders: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }, timeout: const Duration(seconds: 10)));
});

// Alternative: RetrofitApiClient Provider (if you want to use Retrofit)
// final retrofitApiClientProvider = Provider<RetrofitApiClient>((ref) {
//   final dio = ref.watch(dioProvider);
//   return RetrofitApiClient(dio);
// }); 