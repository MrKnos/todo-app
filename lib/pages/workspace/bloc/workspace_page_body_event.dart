part of 'workspace_page_body_bloc.dart';

@immutable
abstract class WorkspacePageBodyEvent {}

class StartedEvent extends _Event {
  StartedEvent({required this.workspace});

  final Workspace workspace;
}

class TaskCheckedEvent extends _Event {
  TaskCheckedEvent({required this.taskId});

  final String taskId;
}

class TaskEditedEvent extends _Event {
  TaskEditedEvent({required this.task});

  final Task task;
}
