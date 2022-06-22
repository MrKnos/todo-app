import 'package:collection/collection.dart';

class TasksPagePresenter {
  TasksPagePresenter({
    required this.workspaces,
  });

  final List<WorkspacePresenter> workspaces;
}

class WorkspacePresenter {
  WorkspacePresenter({
    required this.title,
    required List<TaskPresenter> tasks,
  }) : _tasks = tasks;

  final String title;
  final List<TaskPresenter> _tasks;

  List<TaskPresenter> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<TaskPresenter> get workInProgressTasks {
    return _tasks.whereNot((task) => task.isCompleted).toList();
  }
}

class TaskPresenter {
  TaskPresenter({
    required this.title,
    required this.dueDate,
    required this.isCompleted,
    this.description,
  });

  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isCompleted;
}
