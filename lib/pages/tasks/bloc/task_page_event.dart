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
