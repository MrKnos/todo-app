part of 'task_page_bloc.dart';

@immutable
abstract class TaskPageEvent {}

class StartedEvent extends _Event {}

class TaskCreatedEvent extends _Event {
  TaskCreatedEvent({
    required this.boardId,
    required this.task,
  });

  final String boardId;
  final Task task;
}

class TodoBoardCreatedEvent extends _Event {
  TodoBoardCreatedEvent({required this.todoBoard});

  final TodoBoard todoBoard;
}

class TodoBoardUpdatedEvent extends _Event {
  TodoBoardUpdatedEvent({required this.todoBoard});

  final TodoBoard todoBoard;
}

class TodoBoardDeletedEvent extends _Event {
  TodoBoardDeletedEvent({required this.boardId});

  final String boardId;
}

class DeleteCompletedTasksRequestedEvent extends _Event {
  DeleteCompletedTasksRequestedEvent({required this.boardId});

  final String boardId;
}
