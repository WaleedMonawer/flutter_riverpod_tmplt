import 'package:flutter_riverpod_tmplt/features/todo/domain/entities/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_state.freezed.dart';
part 'todo_state.g.dart';

@freezed
abstract class TodoState with _$TodoState {
  const factory TodoState({
    @Default(false) bool isLoading,
    @Default([]) List<Todo> todos,
    String? error,
  }) = _TodoState;

  factory TodoState.fromJson(Map<String, dynamic> json) => _$TodoStateFromJson(json);


  
  
 
}
