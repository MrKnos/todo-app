import 'package:collection/collection.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_board.dart';

class TodoBoardPagePresenter {
  TodoBoardPagePresenter({
    required this.id,
    required this.name,
    required List<TaskPresenter> tasks,
  }) : _tasks = tasks;

  final String id;
  final String name;
  final List<TaskPresenter> _tasks;

  factory TodoBoardPagePresenter.fromModel(TodoBoard todoBoard) {
    return TodoBoardPagePresenter(
      id: todoBoard.id,
      name: todoBoard.name,
      tasks: todoBoard.tasks.map(TaskPresenter.fromModel).toList(),
    );
  }

  List<TaskPresenter> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<TaskPresenter> get workInProgressTasks {
    return _tasks.whereNot((task) => task.isCompleted).toList();
  }
}

class TaskPresenter {
  TaskPresenter({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.description,
  });

  factory TaskPresenter.fromModel(Task task) {
    return TaskPresenter(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }

  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
}
