part of 'todo_board_page_body_bloc.dart';

@immutable
abstract class TodoBoardPageBodyState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.todoBoard,
  }) : presenter = TodoBoardPagePresenter.fromModel(todoBoard);

  final TodoBoard todoBoard;
  final TodoBoardPagePresenter presenter;
}
