import 'package:collection/collection.dart';
import 'package:todo_app/models/form/workspace_form_field_names.dart';
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

  factory Workspace.fromFormFields(Map<String, dynamic> fields) {
    assert(fields[WorkspaceFormFieldNames.name] != null);

    return Workspace(
      id: DateTime.now().toString(),
      name: fields[WorkspaceFormFieldNames.name]?.toString() ?? '-',
      tasks: [],
    );
  }

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

  void removeCompletedTask() => tasks.removeWhere((task) => task.isCompleted);

  Workspace copyWith({
    String? id,
    String? name,
    List<Task>? tasks,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }
}

extension WorkspacesExtension on List<Workspace> {
  void upsert({required Workspace workspace}) {
    final workspaceIndex = indexWhere(
      (kWorkspace) => kWorkspace.id == workspace.id,
    );

    if (workspaceIndex < 0) {
      return add(workspace);
    } else {
      replaceRange(workspaceIndex, workspaceIndex + 1, [workspace]);
    }
  }
}
