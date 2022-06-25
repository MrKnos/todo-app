import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/theme_cubit.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/workspace.dart';
import 'package:todo_app/pages/page_scaffold.dart';
import 'package:todo_app/pages/tasks/bloc/task_page_bloc.dart';
import 'package:todo_app/pages/tasks/tasks_page_presenter.dart';
import 'package:todo_app/pages/workspace/bloc/workspace_page_body_bloc.dart'
    as page_body;
import 'package:todo_app/pages/workspace/workspace_page_body.dart';
import 'package:todo_app/widgets/modal_bottom_sheet.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  void _createNewTask(
    BuildContext context, {
    required List<Workspace> workspaces,
    required Task task,
  }) {
    final index = DefaultTabController.of(context)?.index ?? 0;
    final workspaceId = workspaces[index].id;
    final bloc = context.read<TaskPageBloc>();

    bloc.add(TaskCreatedEvent(workspaceId: workspaceId, task: task));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskPageBloc, TaskPageState>(
      builder: (context, state) {
        if (state is LoadSuccessState) {
          return _buildLoadSuccess(
            context,
            presenter: state.presenter,
            workspaces: state.workspaces,
            workspaceBlocs: state.workspaceBlocs,
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
    required List<Workspace> workspaces,
    required List<page_body.WorkspacePageBodyBloc> workspaceBlocs,
  }) {
    return DefaultTabController(
      length: presenter.workspaces.length,
      child: Builder(builder: (context) {
        return PageScaffold(
          appBar: _buildAppBar(context, presenter: presenter),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showTaskFormModalSheet(
              context,
              onFormSubmitted: (task) => _createNewTask(
                context,
                workspaces: workspaces,
                task: task,
              ),
            ),
            child: const Icon(Icons.add, size: 30),
          ),
          child: TabBarView(
            children: [
              ...workspaceBlocs.map(
                (bloc) => _buildWorkSpacePageBody(
                  context,
                  workspaceBloc: bloc,
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
      actions: [_buildCreateNewWorkspaceButton(context)],
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
    );
  }

  Widget _buildCreateNewWorkspaceButton(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    final textStyle = theme.material.textTheme;
    final bloc = context.read<TaskPageBloc>();

    return GestureDetector(
      onTap: () => showWorkspaceFormModalSheet(
        context,
        onFormSubmitted: (workspace) => bloc.add(
          WorkspaceCreatedEvent(workspace: workspace),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              color: Colors.black,
            ),
            Text(
              'Workspace',
              style: textStyle.button?.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkSpacePageBody(
    BuildContext context, {
    required page_body.WorkspacePageBodyBloc workspaceBloc,
  }) {
    return BlocProvider<page_body.WorkspacePageBodyBloc>.value(
      value: workspaceBloc,
      child: const WorkspacePageBody(),
    );
  }
}
