import 'package:collection/collection.dart';
import 'package:todo_app/models/form/task_form_field_names.dart';
import 'package:todo_app/models/form/todo_board_form_field_names.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_board.dart';

class TodoBoardPagePresenter {
  TodoBoardPagePresenter({
    required this.id,
    required this.name,
    required this.tasks,
  });

  final String id;
  final String name;
  final List<TaskPresenter> tasks;

  factory TodoBoardPagePresenter.fromModel(TodoBoard todoBoard) {
    return TodoBoardPagePresenter(
      id: todoBoard.id,
      name: todoBoard.name,
      tasks: todoBoard.tasks.map(TaskPresenter.fromModel).toList(),
    );
  }

  factory TodoBoardPagePresenter.fromFormFields(Map<String, dynamic> fields) {
    assert(fields[TodoBoardFormFieldNames.name] != null);

    return TodoBoardPagePresenter(
      id: DateTime.now().toString(),
      name: fields[TodoBoardFormFieldNames.name]?.toString() ?? '-',
      tasks: [],
    );
  }

  List<TaskPresenter> get completedTasks {
    return tasks.where((task) => task.isCompleted).toList();
  }

  List<TaskPresenter> get workInProgressTasks {
    return tasks.whereNot((task) => task.isCompleted).toList();
  }

  TodoBoardPagePresenter copyWith({
    String? id,
    String? name,
    List<TaskPresenter>? tasks,
  }) {
    return TodoBoardPagePresenter(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
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

  factory TaskPresenter.fromFormFields(Map<String, dynamic> fields) {
    assert(fields[TaskFormFieldNames.title] != null);

    return TaskPresenter(
      id: DateTime.now().toString(),
      title: fields[TaskFormFieldNames.title]?.toString() ?? '',
      description: fields[TaskFormFieldNames.description]?.toString(),
      isCompleted: false,
    );
  }

  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  TaskPresenter copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TaskPresenter(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
