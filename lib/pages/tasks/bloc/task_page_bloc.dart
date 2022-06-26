import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/mock.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo_board.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/todo_board/bloc/todo_board_page_body_bloc.dart'
    as board_bloc;

part 'task_page_event.dart';
part 'task_page_state.dart';

typedef _State = TaskPageState;
typedef _Event = TaskPageEvent;

class TaskPageBloc extends Bloc<_Event, _State> {
  TaskPageBloc() : super(InitialState()) {
    on<StartedEvent>(_onStartedEvent);
    on<TaskCreatedEvent>(_onTaskCreatedEvent);
    on<TodoBoardCreatedEvent>(_onTodoBoardCreatedEvent);
    on<TodoBoardUpdatedEvent>(_onTodoBoardUpdatedEvent);
    on<TodoBoardDeletedEvent>(_onTodoBoardDeletedEvent);
    on<DeleteCompletedTasksRequestedEvent>(
      _onDeleteCompletedTasksRequestedEvent,
    );
  }

  void _onStartedEvent(
    StartedEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState(todoBoards: Mock.todoBoards));
  }

  void _onTaskCreatedEvent(
    TaskCreatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoards
        .firstWhereOrNull((board) => board.id == event.boardId)
        ?.upsertTask(event.task);

    emit(LoadSuccessState(todoBoards: kState.todoBoards));
  }

  void _onTodoBoardCreatedEvent(
    TodoBoardCreatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoards.add(event.todoBoard);
    emit(LoadSuccessState(todoBoards: kState.todoBoards));
  }

  void _onTodoBoardUpdatedEvent(
    TodoBoardUpdatedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoards.upsert(board: event.todoBoard);
    emit(LoadSuccessState(todoBoards: kState.todoBoards));
  }

  void _onTodoBoardDeletedEvent(
    TodoBoardDeletedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoards.removeWhere(
      (board) => board.id == event.boardId,
    );

    emit(LoadSuccessState(todoBoards: kState.todoBoards));
  }

  void _onDeleteCompletedTasksRequestedEvent(
    DeleteCompletedTasksRequestedEvent event,
    Emitter<_State> emit,
  ) {
    final kState = state;
    if (kState is! LoadSuccessState) return;

    kState.todoBoards
        .firstWhereOrNull((board) => board.id == event.boardId)
        ?.removeCompletedTask();

    emit(LoadSuccessState(todoBoards: kState.todoBoards));
  }
}
