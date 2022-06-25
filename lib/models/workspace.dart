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
    final removedTask = removeTask(taskId: taskId);
    if (removedTask != null) tasks.insert(0, removedTask.makeComplete());
  }

  void markAsWorkInProgress({required String taskId}) {
    final removedTask = removeTask(taskId: taskId);
    if (removedTask != null) tasks.insert(0, removedTask.makeIncomplete());
  }

  Task? removeTask({required String taskId}) {
    final task = findTask(taskId: taskId);
    if (task == null) return null;

    tasks.removeWhere((kTask) => kTask.id == task.id);
    return task;
  }

  void upsertTask(Task newTask) {
    final oldTaskIndex = tasks.indexWhere((task) => task.id == newTask.id);
    final oldTask = removeTask(taskId: newTask.id);

    if (oldTask == null) {
      tasks.insert(0, newTask);
    } else {
      tasks.insert(oldTaskIndex, oldTask.copyWithTask(newTask));
    }
  }
}
