import 'package:collection/collection.dart';
import 'package:todo_app/models/form/todo_board_form_field_names.dart';
import 'package:todo_app/models/task.dart';

class TodoBoard {
  TodoBoard({
    required this.id,
    required this.name,
    required this.tasks,
  });

  final String id;
  final String name;
  final List<Task> tasks;

  factory TodoBoard.fromFormFields(Map<String, dynamic> fields) {
    assert(fields[TodoBoardFormFieldNames.name] != null);

    return TodoBoard(
      id: DateTime.now().toString(),
      name: fields[TodoBoardFormFieldNames.name]?.toString() ?? '-',
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

    if (oldTaskIndex < 0) {
      tasks.insert(0, newTask);
    } else {
      tasks.replaceRange(oldTaskIndex, oldTaskIndex + 1, [newTask]);
    }
  }

  void removeCompletedTask() => tasks.removeWhere((task) => task.isCompleted);

  TodoBoard copyWith({
    String? id,
    String? name,
    List<Task>? tasks,
  }) {
    return TodoBoard(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }
}

extension TodoBoardsExtension on List<TodoBoard> {
  void upsert({required TodoBoard board}) {
    final boardIndex = indexWhere(
      (kBoard) => kBoard.id == board.id,
    );

    if (boardIndex < 0) {
      return add(board);
    } else {
      replaceRange(boardIndex, boardIndex + 1, [board]);
    }
  }
}
