import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/todo_board/bloc/todo_board_page_body_bloc.dart';
import 'package:todo_app/pages/todo_board/todo_board_page_presenter.dart';
import 'package:todo_app/widgets/check_box.dart';
import 'package:todo_app/widgets/modal_bottom_sheet.dart';

class TodoBoardPageBody extends StatelessWidget {
  const TodoBoardPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBoardPageBodyBloc, TodoBoardPageBodyState>(
      builder: (context, state) {
        if (state is LoadSuccessState) {
          return _buildLoadSuccess(context, todoBoard: state.presenter);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoadSuccess(
    BuildContext context, {
    required TodoBoardPagePresenter todoBoard,
  }) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (todoBoard.workInProgressTasks.isNotEmpty) ...[
          _buildWorkInProgressTasks(context, todoBoard: todoBoard),
        ],
        if (todoBoard.completedTasks.isNotEmpty &&
            todoBoard.workInProgressTasks.isNotEmpty) ...[
          const Divider(height: 32, color: Colors.black),
        ],
        if (todoBoard.completedTasks.isNotEmpty) ...[
          _buildCompletedTasks(context, todoBoard: todoBoard),
        ],
      ],
    );
  }

  Widget _buildWorkInProgressTasks(
    BuildContext context, {
    required TodoBoardPagePresenter todoBoard,
  }) {
    return Column(
      children: [
        ...todoBoard.workInProgressTasks
            .map((task) => _buildTask(context, task: task))
            .intersperse(const SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildCompletedTasks(
    BuildContext context, {
    required TodoBoardPagePresenter todoBoard,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textTheme = theme.material.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed Tasks (${todoBoard.completedTasks.length})',
          style: textTheme.headline3,
        ),
        const SizedBox(height: 16),
        ...todoBoard.completedTasks
            .map((task) => _buildTask(context, task: task))
            .intersperse(const SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildTask(
    BuildContext context, {
    required TaskPresenter task,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textTheme = theme.material.textTheme;
    final bloc = context.read<TodoBoardPageBodyBloc>();

    return Row(
      children: [
        CheckBox(
          isChecked: task.isCompleted,
          onPressed: () => bloc.add(TaskCheckedEvent(taskId: task.id)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showTaskFormModalSheet(
              context,
              initialTask: Task.fromPresenter(task),
              onSubmitForm: (task) => bloc.add(
                TaskEditedEvent(task: task),
              ),
              onDeleteTask: () => bloc.add(
                TaskDeletedEvent(taskId: task.id),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: textTheme.bodyText1?.copyWith(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    decorationThickness: 2,
                  ),
                  maxLines: 2,
                ),
                if (task.description != null) ...[
                  Text(
                    task.description ?? '',
                    style: textTheme.caption?.copyWith(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      decorationThickness: 2,
                    ),
                    maxLines: 1,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
