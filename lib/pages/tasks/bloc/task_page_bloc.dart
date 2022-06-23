import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/mock.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';

part 'task_page_event.dart';
part 'task_page_state.dart';

typedef _State = TaskPageState;
typedef _Event = TaskPageEvent;

class TaskPageBloc extends Bloc<_Event, _State> {
  TaskPageBloc() : super(InitialState()) {
    on<StartedEvent>(_onStartedEvent);
  }

  void _onStartedEvent(
    StartedEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState(workspaces: Mock.workspaces));
  }
}
