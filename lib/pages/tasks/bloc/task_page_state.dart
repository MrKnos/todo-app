part of 'task_page_bloc.dart';

@immutable
abstract class TaskPageState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.todoBoards,
  })  : presenter = TasksPagePresenter.fromModel(todoBoards: todoBoards),
        todoBoardBlocs = todoBoards
            .map((board) => board_bloc.TodoBoardPageBodyBloc()
              ..add(board_bloc.StartedEvent(todoBoard: board)))
            .toList();

  final List<TodoBoard> todoBoards;
  final TasksPagePresenter presenter;
  final List<board_bloc.TodoBoardPageBodyBloc> todoBoardBlocs;
}
