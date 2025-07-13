import 'package:flutter_riverpod_tmplt/features/todo/domain/entities/todo.dart';
import 'package:flutter_riverpod_tmplt/features/todo/presentation/controllers/todo_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'todo_controller.g.dart';

// Controller using traditional Riverpod
@riverpod
class TodoController extends _$TodoController {
 
  @override
  TodoState build() {
    return const TodoState();
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      final todos = [
        Todo(id: '1', title: 'تعلم Flutter', completed: true),
        Todo(id: '2', title: 'تعلم Riverpod', completed: false),
        Todo(id: '3', title: 'بناء تطبيق', completed: false),
      ];
      
      state = state.copyWith(isLoading: false, todos: todos);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل المهام: $e',
      );
    }
  }

  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    
    state = state.copyWith(
      todos: [...state.todos, newTodo],
    );
  }

  void toggleTodo(String id) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    
    state = state.copyWith(todos: updatedTodos);
  }

  void deleteTodo(String id) {
    final updatedTodos = state.todos.where((todo) => todo.id != id).toList();
    state = state.copyWith(todos: updatedTodos);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}


// Computed providers
final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoControllerProvider).todos;
  return todos.where((todo) => todo.completed).toList();
});

final pendingTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoControllerProvider).todos;
  return todos.where((todo) => !todo.completed).toList();
});

final todosCountProvider = Provider<int>((ref) {
  return ref.watch(todoControllerProvider).todos.length;
});

final completedCountProvider = Provider<int>((ref) {
  return ref.watch(completedTodosProvider).length;
}); 