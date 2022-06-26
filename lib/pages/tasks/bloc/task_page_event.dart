part of 'task_page_bloc.dart';

@immutable
abstract class TaskPageEvent {}

class StartedEvent extends _Event {}

class TaskCreatedEvent extends _Event {
  TaskCreatedEvent({
    required this.workspaceId,
    required this.task,
  });

  final String workspaceId;
  final Task task;
}

class WorkspaceCreatedEvent extends _Event {
  WorkspaceCreatedEvent({required this.workspace});

  final Workspace workspace;
}

class WorkspaceUpdatedEvent extends _Event {
  WorkspaceUpdatedEvent({required this.workspace});

  final Workspace workspace;
}

class WorkspaceDeletedEvent extends _Event {
  WorkspaceDeletedEvent({required this.workspaceId});

  final String workspaceId;
}

class DeleteCompletedTasksRequestedEvent extends _Event {
  DeleteCompletedTasksRequestedEvent({required this.workspaceId});

  final String workspaceId;
}
