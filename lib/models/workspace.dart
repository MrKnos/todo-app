import 'package:collection/collection.dart';
import 'package:todo_app/models/task.dart';

class Workspace {
  Workspace({
    required this.id,
    required this.name,
    required this.tasks,
  });

  final String id;
  final String name;
  final List<Task> tasks;

  Task? findTask({required String taskId}) {
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }

  void markAsCompleted({required String taskId}) {
    tasks.firstWhereOrNull((task) => task.id == taskId)?.isCompleted = true;
  }

  void markAsWorkInProgress({required String taskId}) {
    tasks.firstWhereOrNull((task) => task.id == taskId)?.isCompleted = false;
  }
}
