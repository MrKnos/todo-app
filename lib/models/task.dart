import 'package:todo_app/models/task_form.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.description,
  });

  factory Task.fromFormFields(Map<String, dynamic> fields) {
    assert(fields[TaskFormFieldNames.title] != null);

    return Task(
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

  Task makeComplete() => copyWith(isCompleted: true);

  Task makeIncomplete() => copyWith(isCompleted: false);
}
