import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_controller.g.dart';

// Simple counter controller using @riverpod
@riverpod
class CounterController extends _$CounterController {
  @override
  int build() {
    // Initial state
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }

  void setValue(int value) {
    state = value;
  }
}

// Async counter controller example
@riverpod
Future<int> asyncCounter(Ref ref) async {
  // Simulate async operation
  await Future.delayed(const Duration(seconds: 2));
  return 42;
}

// Family provider example
@riverpod
int counterWithOffset(Ref ref, int offset) {
  final baseValue = ref.watch(counterControllerProvider);
  return baseValue + offset;
}

// Computed provider example
@riverpod
String counterText(Ref ref) {
  final count = ref.watch(counterControllerProvider);
  return 'العداد: $count';
} 