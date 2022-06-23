part of 'task_page_bloc.dart';

@immutable
abstract class TaskPageState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({
    required this.workspaces,
  })  : presenter = TasksPagePresenter.fromModel(workspaces: workspaces),
        workspaceBlocs = workspaces
            .map((workspace) => workspace_bloc.WorkspacePageBodyBloc()
              ..add(workspace_bloc.StartedEvent(workspace: workspace)))
            .toList();

  final List<Workspace> workspaces;
  final TasksPagePresenter presenter;
  final List<workspace_bloc.WorkspacePageBodyBloc> workspaceBlocs;
}
