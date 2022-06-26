import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/mock.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/workspace/bloc/workspace_page_body_bloc.dart'
    as workspace_bloc;

part 'task_page_event.dart';
part 'task_page_state.dart';

typedef _State = TaskPageState;
typedef _Event = TaskPageEvent;

class TaskPageBloc extends Bloc<_Event, _State> {
  TaskPageBloc() : super(InitialState()) {
    on<StartedEvent>(_onStartedEvent);
    on<TaskCreatedEvent>(_onTaskCreatedEvent);
    on<WorkspaceCreatedEvent>(_onWorkspaceCreatedEvent);
    on<WorkspaceUpdatedEvent>(_onWorkspaceUpdatedEvent);
    on<WorkspaceDeletedEvent>(_onWorkspaceDeletedEvent);
    on<DeleteCompletedTasksRequestedEvent>(
      _onDeleteCompletedTasksRequestedEvent,
    );
  }

  void _onStartedEvent(
    StartedEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState(workspaces: Mock.workspaces));
  }

  void _onTaskCreatedEvent(
    TaskCreatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.workspaces
        .firstWhereOrNull((workspace) => workspace.id == event.workspaceId)
        ?.upsertTask(event.task);

    emit(LoadSuccessState(workspaces: kState.workspaces));
  }

  void _onWorkspaceCreatedEvent(
    WorkspaceCreatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.workspaces.add(event.workspace);
    emit(LoadSuccessState(workspaces: kState.workspaces));
  }

  void _onWorkspaceUpdatedEvent(
    WorkspaceUpdatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.workspaces.upsert(workspace: event.workspace);
    emit(LoadSuccessState(workspaces: kState.workspaces));
  }

  void _onWorkspaceDeletedEvent(
    WorkspaceDeletedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.workspaces.removeWhere(
      (workspace) => workspace.id == event.workspaceId,
    );
    emit(LoadSuccessState(workspaces: kState.workspaces));
  }

  void _onDeleteCompletedTasksRequestedEvent(
    DeleteCompletedTasksRequestedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.workspaces
        .firstWhereOrNull((workspace) => workspace.id == event.workspaceId)
        ?.removeCompletedTask();

    emit(LoadSuccessState(workspaces: kState.workspaces));
  }
}
