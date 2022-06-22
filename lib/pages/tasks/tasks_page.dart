import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/mock.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/widgets/check_box.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;
    final presenter = Mock.tasksPagePresenter;

    return DefaultTabController(
      length: presenter.workspaces.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Tasks',
            style: textStyle.headline1?.copyWith(
              height: 2,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: TabBar(
              isScrollable: true,
              indicatorColor: Colors.black,
              tabs: [
                ...presenter.workspaces.map(
                  (workspace) => Tab(
                    child: Text(
                      workspace.title,
                      style: textStyle.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ...presenter.workspaces.map(
              (workspace) => _buildWorkspace(
                context,
                workspace: workspace,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspace(
    BuildContext context, {
    required WorkspacePresenter workspace,
  }) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (workspace.workInProgressTasks.isNotEmpty)
          _buildWorkInProgressTasks(context, workspace: workspace),
        if (workspace.completedTasks.isNotEmpty) ...[
          const Divider(height: 32, color: Colors.black),
          _buildCompletedTasks(context, workspace: workspace),
        ],
      ],
    );
  }

  Widget _buildWorkInProgressTasks(
    BuildContext context, {
    required WorkspacePresenter workspace,
  }) {
    return Column(
      children: [
        ...workspace.workInProgressTasks.map(
          (task) => _buildTaskTile(context, task: task),
        ),
      ],
    );
  }

  Widget _buildCompletedTasks(
    BuildContext context, {
    required WorkspacePresenter workspace,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textTheme = theme.material.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed Tasks',
          style: textTheme.headline3,
        ),
        const SizedBox(height: 16),
        ...workspace.completedTasks
            .map((task) => _buildTaskTile(context, task: task))
            .intersperse(const SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildTaskTile(
    BuildContext context, {
    required TaskPresenter task,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textTheme = theme.material.textTheme;

    return Row(
      children: [
        CheckBox(isChecked: task.isCompleted),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: textTheme.bodyText1,
                maxLines: 2,
              ),
              if (task.description != null)
                Text(
                  task.description ?? '',
                  style: textTheme.caption,
                  maxLines: 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
