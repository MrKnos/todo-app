import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/workspace/workspace_page_presenter.dart';

part 'workspace_page_body_event.dart';
part 'workspace_page_body_state.dart';

typedef _State = WorkspacePageBodyState;
typedef _Event = WorkspacePageBodyEvent;

class WorkspacePageBodyBloc extends Bloc<_Event, _State> {
  WorkspacePageBodyBloc() : super(InitialState()) {
    on<StartedEvent>(_onStartedEvent);
    on<TaskCheckedEvent>(_onTaskCheckedEvent);
    on<TaskEditedEvent>(_onTaskEditedEvent);
  }

  void _onStartedEvent(
    StartedEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState(workspace: event.workspace));
  }

  void _onTaskCheckedEvent(
    TaskCheckedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    final task = kState.workspace.findTask(taskId: event.taskId);

    // TODO(Kittipong): Handle when task not found.
    if (task == null) throw Exception('Task Not found');

    if (task.isCompleted) {
      kState.workspace.markAsWorkInProgress(taskId: event.taskId);
    } else {
      kState.workspace.markAsCompleted(taskId: event.taskId);
    }

    emit(LoadSuccessState(workspace: kState.workspace));
  }

  void _onTaskEditedEvent(
    TaskEditedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    final updatedWorkspace = kState.workspace..upsertTask(event.task);
    emit(LoadSuccessState(workspace: updatedWorkspace));
  }
}
