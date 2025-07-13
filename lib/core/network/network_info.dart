import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';


abstract class NetworkInfo {
  Future<Result<bool>> get isConnected;
  Stream<Result<bool>> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  
  NetworkInfoImpl(this.connectivity);

  @override
  Future<Result<bool>> get isConnected async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      return Result.success(connectivityResult != ConnectivityResult.none);
    } catch (e) {
      return Result.failure('Failed to check connectivity: $e');
    }
  }

  @override
  Stream<Result<bool>> get connectivityStream {
    return connectivity.onConnectivityChanged.map((result) {
      return Result.success(result != ConnectivityResult.none);
    }).handleError((error) {
      return Result.failure('Connectivity stream error: $error');
    });
  }
} 