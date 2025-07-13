import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/features/todo/domain/entities/todo.dart';
import '../controllers/todo_controller.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load todos when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoControllerProvider.notifier).loadTodos();
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todoState = ref.watch(todoControllerProvider);
    final completedCount = ref.watch(completedCountProvider);
    final totalCount = ref.watch(todosCountProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todos),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(todoControllerProvider.notifier).loadTodos();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(l10n.totalTodos, totalCount.toString()),
                  _buildStatItem(l10n.completed, completedCount.toString()),
                  _buildStatItem(l10n.pending, (totalCount - completedCount).toString()),
                ],
              ),
            ),
          ),
          
          // Add Todo Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: l10n.addNewTodo,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.add_task),
                    ),
                    onSubmitted: _addTodo,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTodo(_todoController.text),
                  child: Text(l10n.add),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Loading Indicator
          if (todoState.isLoading)
            const Center(child: CircularProgressIndicator()),
          
          // Error Display
          if (todoState.error != null)
            _buildErrorWidget(todoState.error!),
          
          // Todos List
          Expanded(
            child: todoState.todos.isEmpty && !todoState.isLoading
                ? Center(
                    child: Text(
                      l10n.noTodos,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: todoState.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoState.todos[index];
                      return _buildTodoItem(todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            ref.read(todoControllerProvider.notifier).toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed 
                ? TextDecoration.lineThrough 
                : null,
            color: todo.completed 
                ? Colors.grey[600] 
                : null,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            ref.read(todoControllerProvider.notifier).deleteTodo(todo.id);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
            IconButton(
              onPressed: () {
                ref.read(todoControllerProvider.notifier).clearError();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo(String title) {
    if (title.trim().isNotEmpty) {
      ref.read(todoControllerProvider.notifier).addTodo(title);
      _todoController.clear();
    }
  }
} 