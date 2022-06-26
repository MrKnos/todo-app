part of 'todo_board_page_body_bloc.dart';

@immutable
abstract class TodoBoardPageBodyEvent {}

class StartedEvent extends _Event {
  StartedEvent({required this.todoBoard});

  final TodoBoard todoBoard;
}

class TaskCheckedEvent extends _Event {
  TaskCheckedEvent({required this.taskId});

  final String taskId;
}

class TaskEditedEvent extends _Event {
  TaskEditedEvent({required this.task});

  final Task task;
}

class TaskDeletedEvent extends _Event {
  TaskDeletedEvent({required this.taskId});

  final String taskId;
}
