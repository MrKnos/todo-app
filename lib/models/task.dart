import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.description,
  });

  factory Task.fromPresenter(TaskPresenter presenter) {
    return Task(
      id: presenter.id,
      title: presenter.title,
      description: presenter.description,
      isCompleted: presenter.isCompleted,
    );
  }

  final String id;
  final String title;
  final String? description;
  final bool isCompleted;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Task copyWithTask(Task task) {
    return copyWith(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }

  Task makeComplete() => copyWith(isCompleted: true);

  Task makeIncomplete() => copyWith(isCompleted: false);
}
