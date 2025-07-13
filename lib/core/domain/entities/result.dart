/// Result class for handling success and failure states
/// Provides a type-safe way to handle operations that can succeed or fail
class Result<T> {
  final T? _data;
  final String? _errorMessage;
  final bool _isSuccess;

  const Result._({
    T? data,
    String? errorMessage,
    required bool isSuccess,
  })  : _data = data,
        _errorMessage = errorMessage,
        _isSuccess = isSuccess;

  /// Create a successful result
  factory Result.success(T data) {
    return Result._(
      data: data,
      isSuccess: true,
    );
  }

  /// Create a failure result
  factory Result.failure(String message) {
    return Result._(
      errorMessage: message,
      isSuccess: false,
    );
  }

  /// Check if the result is successful
  bool get isSuccess => _isSuccess;

  /// Check if the result is a failure
  bool get isFailure => !_isSuccess;

  /// Get the data if successful, null otherwise
  T? get data => _isSuccess ? _data : null;

  /// Get the error message if failed, null otherwise
  String? get errorMessage => _isSuccess ? null : _errorMessage;

  /// Execute different functions based on success or failure
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) failure,
  }) {
    if (_isSuccess) {
      return success(_data!);
    } else {
      return failure(_errorMessage!);
    }
  }

  /// Execute a function only if successful
  Result<R> map<R>(R Function(T data) mapper) {
    if (_isSuccess) {
      return Result.success(mapper(_data!));
    } else {
      return Result.failure(_errorMessage!);
    }
  }

  /// Execute an async function only if successful
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    if (_isSuccess) {
      try {
        final result = await mapper(_data!);
        return Result.success(result);
      } catch (e) {
        return Result.failure(e.toString());
      }
    } else {
      return Result.failure(_errorMessage!);
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson([Object? Function(T)? toJsonT]) {
    if (_isSuccess) {
      return {
        'type': 'success',
        'data': toJsonT != null ? toJsonT(_data!) : _data,
      };
    } else {
      return {
        'type': 'failure',
        'message': _errorMessage,
      };
    }
  }

  /// Create from JSON
  factory Result.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    final type = json['type'] as String;
    switch (type) {
      case 'success':
        final data = fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T;
        return Result.success(data);
      case 'failure':
        return Result.failure(json['message'] as String);
      default:
        throw Exception('Unknown Result type: $type');
    }
  }

  @override
  String toString() {
    if (_isSuccess) {
      return 'Result.success($_data)';
    } else {
      return 'Result.failure($_errorMessage)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Result<T> &&
        other._isSuccess == _isSuccess &&
        other._data == _data &&
        other._errorMessage == _errorMessage;
  }

  @override
  int get hashCode {
    return Object.hash(_isSuccess, _data, _errorMessage);
  }
} 