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
          appBar: _buildAppBar(
            context,
            presenter: presenter,
            workspaces: workspaces,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showTaskFormModalSheet(
              context,
              onSubmitForm: (task) => _createNewTask(
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
    required List<Workspace> workspaces,
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
        _buildMenuButton(context, workspaces: workspaces),
      ],
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

  Widget _buildMenuButton(
    BuildContext context, {
    required List<Workspace> workspaces,
  }) {
    return PopupMenuButton<PopupMenu>(
      padding: const EdgeInsets.only(right: 20),
      icon: const Icon(Icons.menu, size: 30),
      onSelected: (menu) => _onSelectedPopupMenuButton(
        context,
        menu: menu,
        workspaces: workspaces,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.createNewWorkspace,
          child: Text('New Workspace'),
        ),
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.editWorkspace,
          child: Text('Edit Workspace'),
        ),
        const PopupMenuItem<PopupMenu>(
          value: PopupMenu.deleteCompletedTasks,
          child: Text('Delete Completed Tasks'),
        ),
      ],
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

  void _onSelectedPopupMenuButton(
    BuildContext context, {
    required PopupMenu menu,
    required List<Workspace> workspaces,
  }) {
    final index = DefaultTabController.of(context)?.index ?? 0;
    final bloc = context.read<TaskPageBloc>();

    switch (menu) {
      case PopupMenu.createNewWorkspace:
        showWorkspaceFormModalSheet(
          context,
          onSubmitForm: (workspace) => bloc.add(
            WorkspaceCreatedEvent(workspace: workspace),
          ),
        );
        break;
      case PopupMenu.editWorkspace:
        final workspaceId = workspaces[index].id;

        showWorkspaceFormModalSheet(
          context,
          initialWorkspace: workspaces[index],
          onSubmitForm: (workspace) => bloc.add(
            WorkspaceUpdatedEvent(workspace: workspace),
          ),
          onDeleteWorkspace: () => bloc.add(
            WorkspaceDeletedEvent(workspaceId: workspaceId),
          ),
        );
        break;
      case PopupMenu.deleteCompletedTasks:
        final workspaceId = workspaces[index].id;

        bloc.add(DeleteCompletedTasksRequestedEvent(workspaceId: workspaceId));
        break;
    }
  }
}

enum PopupMenu {
  createNewWorkspace,
  editWorkspace,
  deleteCompletedTasks,
}
