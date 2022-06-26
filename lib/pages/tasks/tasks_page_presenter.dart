import 'package:todo_app/models/todo_board.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';

class TasksPagePresenter {
  TasksPagePresenter({
    required this.todoBoards,
  });

  factory TasksPagePresenter.fromModel({
    required List<TodoBoard> todoBoards,
  }) {
    return TasksPagePresenter(
      todoBoards: todoBoards.map(TodoBoardPagePresenter.fromModel).toList(),
    );
  }

  final List<TodoBoardPagePresenter> todoBoards;
}
