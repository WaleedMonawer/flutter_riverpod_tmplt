import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String message) = Failure<T>;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get data => when(
    success: (data) => data,
    failure: (_) => null,
  );
  
  String? get errorMessage => when(
    success: (_) => null,
    failure: (message) => message,
  );
} 