import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/pages/page_scaffold.dart';
import 'package:todo_app/pages/tasks/bloc/task_page_bloc.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/todo_board/bloc/todo_board_page_body_bloc.dart'
    as page_body;
import 'package:todo_app/pages/todo_board/todo_board_page_body.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';
import 'package:todo_app/widgets/modal_bottom_sheet.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPageBloc, TaskPageState>(
      builder: (context, state) {
        if (state is LoadSuccessState) {
          return _buildLoadSuccess(
            context,
            presenter: state.presenter,
            todoBoardBlocs: state.todoBoardBlocs,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadSuccess(
    BuildContext context, {
    required TasksPagePresenter presenter,
    required List<page_body.TodoBoardPageBodyBloc> todoBoardBlocs,
  }) {
    return DefaultTabController(
      length: presenter.todoBoards.length,
      child: Builder(builder: (context) {
        return PageScaffold(
          appBar: _buildAppBar(context, presenter: presenter),
          floatingActionButton: presenter.todoBoards.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => showTaskFormModalSheet(
                    context,
                    onSubmitForm: (task) => _createNewTask(
                      context,
                      presenter: presenter,
                      task: task,
                    ),
                  ),
                  child: const Icon(Icons.add, size: 30),
                )
              : null,
          child: TabBarView(
            children: [
              ...todoBoardBlocs.map(
                (bloc) => _buildTodoBoardsPageBody(
                  context,
                  todoBoardBloc: bloc,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(
    BuildContext context, {
    required TasksPagePresenter presenter,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;

    return AppBar(
      centerTitle: true,
      title: Text(
        'Tasks',
        style: textStyle.headline1,
      ),
      actions: [
        _buildMenuButton(context, presenter: presenter),
      ],
      bottom: presenter.todoBoards.isNotEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                tabs: [
                  ...presenter.todoBoards.map(
                    (todoBoard) => Tab(
                      child: Text(
                        todoBoard.name,
                        style: textStyle.button,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required TasksPagePresenter presenter,
  }) {
    return PopupMenuButton<PopupMenu>(
      padding: const EdgeInsets.only(right: 20),
      icon: const Icon(Icons.menu, size: 30),
      onSelected: (menu) => _onSelectedPopupMenuButton(
        context,
        menu: menu,
        presenter: presenter,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.createNewTodoBoard,
          child: Text('New Todo Board'),
        ),
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.editTodoBoard,
          child: Text('Edit Todo Board'),
        ),
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.deleteCompletedTasks,
          child: Text('Delete Completed Tasks'),
        ),
      ],
    );
  }

  Widget _buildTodoBoardsPageBody(
    BuildContext context, {
    required page_body.TodoBoardPageBodyBloc todoBoardBloc,
  }) {
    return BlocProvider<page_body.TodoBoardPageBodyBloc>.value(
      value: todoBoardBloc,
      child: const TodoBoardPageBody(),
    );
  }

  void _createNewTask(
    BuildContext context, {
    required TasksPagePresenter presenter,
    required TaskPresenter task,
  }) {
    final index = DefaultTabController.of(context)?.index ?? 0;
    final boardId = presenter.todoBoards[index].id;
    final bloc = context.read<TaskPageBloc>();

    bloc.add(TaskCreatedEvent(boardId: boardId, task: task));
  }

  void _onSelectedPopupMenuButton(
    BuildContext context, {
    required PopupMenu menu,
    required TasksPagePresenter presenter,
  }) {
    final index = DefaultTabController.of(context)?.index ?? 0;
    final bloc = context.read<TaskPageBloc>();

    switch (menu) {
      case PopupMenu.createNewTodoBoard:
        showTodoBoardFormModalSheet(
          context,
          onSubmitForm: (todoBoard) => bloc.add(
            TodoBoardCreatedEvent(todoBoard: todoBoard),
          ),
        );
        break;
      case PopupMenu.editTodoBoard:
        final boardId = presenter.todoBoards[index].id;

        showTodoBoardFormModalSheet(
          context,
          initialTodoBoard: presenter.todoBoards[index],
          onSubmitForm: (todoBoard) => bloc.add(
            TodoBoardUpdatedEvent(todoBoard: todoBoard),
          ),
          onDeleteTodoBoard: () => bloc.add(
            TodoBoardDeletedEvent(boardId: boardId),
          ),
        );
        break;
      case PopupMenu.deleteCompletedTasks:
        final boardId = presenter.todoBoards[index].id;

        bloc.add(DeleteCompletedTasksRequestedEvent(boardId: boardId));
        break;
    }
  }
}

enum PopupMenu {
  createNewTodoBoard,
  editTodoBoard,
  deleteCompletedTasks,
}
