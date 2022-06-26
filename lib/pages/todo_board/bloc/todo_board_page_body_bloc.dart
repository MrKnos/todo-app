import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_board.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';

part 'todo_board_page_body_event.dart';
part 'todo_board_page_body_state.dart';

typedef _State = TodoBoardPageBodyState;
typedef _Event = TodoBoardPageBodyEvent;

class TodoBoardPageBodyBloc extends Bloc<_Event, _State> {
  TodoBoardPageBodyBloc() : super(InitialState()) {
    on<StartedEvent>(_onStartedEvent);
    on<TaskCheckedEvent>(_onTaskCheckedEvent);
    on<TaskEditedEvent>(_onTaskEditedEvent);
    on<TaskDeletedEvent>(_onTaskDeletedEvent);
  }

  void _onStartedEvent(
    StartedEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState(todoBoard: event.todoBoard));
  }

  void _onTaskCheckedEvent(
    TaskCheckedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    final task = kState.todoBoard.findTask(taskId: event.taskId);
    if (task == null) return;

    if (task.isCompleted) {
      kState.todoBoard.markAsWorkInProgress(taskId: event.taskId);
    } else {
      kState.todoBoard.markAsCompleted(taskId: event.taskId);
    }

    emit(LoadSuccessState(todoBoard: kState.todoBoard));
  }

  void _onTaskEditedEvent(
    TaskEditedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoard.upsertTask(Task.fromPresenter(event.task));
    emit(LoadSuccessState(todoBoard: kState.todoBoard));
  }

  void _onTaskDeletedEvent(
    TaskDeletedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoard.removeTask(taskId: event.taskId);
    emit(LoadSuccessState(todoBoard: kState.todoBoard));
  }
}
