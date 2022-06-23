import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/tasks/bloc/task_page_bloc.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/workspace/bloc/workspace_page_body_bloc.dart'
    as page_body;
import 'package:todo_app/pages/workspace/workspace_page_body.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPageBloc, TaskPageState>(
      builder: (context, state) {
        if (state is LoadSuccessState) {
          return _buildLoadSuccess(
            context,
            presenter: state.presenter,
            workspaces: state.workspaces,
          );
        } else {
          return const SizedBox.expand(
            child: Center(
              child: Text('Something went wrong.'),
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadSuccess(
    BuildContext context, {
    required TasksPagePresenter presenter,
    required List<Workspace> workspaces,
  }) {
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;

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
                      workspace.name,
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
            ...workspaces.map(
              (workspace) => _buildWorkSpacePageBody(
                context,
                workspace: workspace,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  Widget _buildWorkSpacePageBody(
    BuildContext context, {
    required Workspace workspace,
  }) {
    return BlocProvider<page_body.WorkspacePageBodyBloc>(
      create: (context) => page_body.WorkspacePageBodyBloc()
        ..add(page_body.StartedEvent(workspace: workspace)),
      child: const WorkspacePageBody(),
    );
  }
}
